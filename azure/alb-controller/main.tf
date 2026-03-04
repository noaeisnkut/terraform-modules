# -------------------------------
# 1. Identity for ALB
# -------------------------------
resource "azurerm_user_assigned_identity" "alb_controller" {
  name                = "${var.name}-identity"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "alb_controller" {
  name                = "${var.name}-federated"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.alb_controller.id
  subject             = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
}

resource "azurerm_role_assignment" "alb_identity_network" {
  for_each             = var.albs
  scope                = each.value.subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}

# -------------------------------
# 2. Public IP for ALB
# -------------------------------
resource "azurerm_public_ip" "alb" {
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# -------------------------------
# 3. Helm ALB Controller
# -------------------------------
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

  set {
    name  = "albController.installGatewayApiCRDs"
    value = "true"
  }

  depends_on = [azurerm_federated_identity_credential.alb_controller]
}

# -------------------------------
# 4. ApplicationLoadBalancer resource
# -------------------------------
resource "kubectl_manifest" "alb_resource" {
  for_each   = var.albs
  depends_on = [helm_release.alb_controller]

  yaml_body = yamlencode({
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = each.value.alb_name
      namespace = var.namespace
    }
    spec = {
      associations = [each.value.subnet_id]
    }
  })
}

# -------------------------------
# 5. Gateway resource (Gateway API)
# -------------------------------
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
        "alb.networking.azure.io/alb-id" = each.value.alb_name
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

# -------------------------------
# 6. HTTPRoute resources for each app (Gateway API)
# -------------------------------
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
  apiVersion = "gateway.networking.k8s.io/v1beta1"
  kind       = "HTTPRoute"
  metadata = {
    name      = lower(replace("${each.key}-route", "_", "-"))
    namespace = var.namespace
  }
  spec = {
    parentRefs = [
      {
        name      = lower(replace(each.value.gateway, "_", "-"))
        namespace = var.namespace
      }
    ]
    hostnames = [each.value.app_val.hostname]  # <-- add this line
    rules = [
      {
        matches = [
          {
            path = {
              type  = "PathPrefix"
              value = "/"
            }
          }
        ]
        backendRefs = [
          {
            name      = each.value.app_val.svc_name
            namespace = each.value.app_val.namespace
            port      = each.value.app_val.svc_port
            weight    = 100
          }
        ]
      }
    ]
  }
})
}