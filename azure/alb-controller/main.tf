resource "azurerm_user_assigned_identity" "alb_controller" {
  name                = "${var.name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "alb_controller" {
  name      = "${var.name}-federated"
  audience  = ["api://AzureADTokenExchange"]
  issuer    = var.oidc_issuer_url
  parent_id = azurerm_user_assigned_identity.alb_controller.id
  subject   = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

resource "kubernetes_service_account" "alb_controller" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.alb_controller.client_id
    }
  }
}

resource "azurerm_role_assignment" "alb_contributor" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "AppGw for Containers Administrator"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}

resource "azurerm_application_load_balancer" "alb" {
  for_each            = var.albs
  name                = each.value.alb_name
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_application_load_balancer_frontend" "alb" {
  for_each                     = var.albs
  name                         = "frontend"
  application_load_balancer_id = azurerm_application_load_balancer.alb[each.key].id
}

resource "azurerm_application_load_balancer_subnet_association" "alb" {
  for_each                     = var.albs
  name                         = "association"
  application_load_balancer_id = azurerm_application_load_balancer.alb[each.key].id
  subnet_id                    = each.value.subnet_id
}

resource "helm_release" "alb_controller" {
  name             = "alb-controller"
  repository       = "oci://mcr.microsoft.com/application-lb/charts"
  chart            = "alb-controller"
  namespace        = var.namespace
  create_namespace = true
  version          = var.controller_version

  set {
    name  = "albController.podIdentity.clientID"
    value = azurerm_user_assigned_identity.alb_controller.client_id
  }

  depends_on = [
    azurerm_federated_identity_credential.alb_controller,
    kubernetes_service_account.alb_controller,
    azurerm_role_assignment.alb_contributor,
    azurerm_role_assignment.network_contributor
  ]
}

resource "null_resource" "wait_for_alb_controller" {
  depends_on = [helm_release.alb_controller]

  provisioner "local-exec" {
    command = <<EOT
      # Set max tries (e.g., 30 tries * 10 seconds = 5 minutes)
      max_tries=30
      count=0
      
      echo "Waiting for ALB Controller pods to be 'Ready' in namespace ${var.namespace}..."
      
      until kubectl get pods -n ${var.namespace} -l app.kubernetes.io/name=alb-controller | grep -q "1/1"; do
        count=$((count + 1))
        if [ $count -eq $max_tries ]; then
          echo "ALB Controller failed to become ready in time."
          exit 1
        fi
        echo "Attempt $count/$max_tries: Pods not ready yet. Sleeping 10s..."
        sleep 10
      done
      
      echo "ALB Controller is Ready! Proceeding with manifests..."
      # Optional: Small extra sleep to ensure the API server registered the CRDs
      sleep 5
    EOT
  }
}

resource "kubectl_manifest" "alb_resource" {
  for_each   = var.albs
  depends_on = [null_resource.wait_for_alb_controller]

  yaml_body = yamlencode({
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = each.value.alb_name
      namespace = var.namespace
    }
    spec = {
      frontendId = azurerm_application_load_balancer_frontend.alb[each.key].id
    }
  })
}


resource "kubectl_manifest" "gateway" {
  for_each   = var.albs
  depends_on = [kubectl_manifest.alb_resource]

  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = each.value.gateway_name
      namespace = var.namespace
      annotations = {
        "alb.networking.azure.io/alb-id" = azurerm_application_load_balancer.alb[each.key].id
      }
    }
    spec = {
      gatewayClassName = "azure-alb-external"
      listeners = [{
        name     = "http"
        port     = 80
        protocol = "HTTP"
        allowedRoutes = { namespaces = { from = "All" } }
      }]
    }
  })
}

resource "kubectl_manifest" "alb_routes" {
  for_each = {
    for pair in flatten([
      for alb_key, alb_val in var.albs : [
        for app_key, app_val in alb_val.apps : {
          alb_key = alb_key
          app_key = app_key
          app_val = app_val
          gateway = alb_val.gateway_name
        }
      ]
    ]) : "${lower(replace(pair.alb_key, "_", "-"))}-${lower(replace(pair.app_key, "_", "-"))}" => pair
  }

  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = lower(replace("${each.key}-route", "_", "-"))
      namespace = var.namespace
    }
    spec = {
      parentRefs = [{
        name      = each.value.gateway
        namespace = var.namespace
      }]
      hostnames = [each.value.app_val.hostname]
      rules = [{
        matches = [{ path = { type = "PathPrefix", value = "/" } }]
        backendRefs = [{
          name      = each.value.app_val.svc_name
          namespace = each.value.app_val.namespace
          port      = each.value.app_val.svc_port
        }]
      }]
    }
  })
}