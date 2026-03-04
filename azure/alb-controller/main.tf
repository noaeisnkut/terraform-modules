# 1. Identity for ALB
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

resource "azurerm_public_ip" "alb" {
  name                = "${var.name}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 2. Install ALB Helm chart
resource "helm_release" "alb_controller" {
  name             = "alb-controller"
  repository       = "oci://mcr.microsoft.com/application-lb/charts"
  chart            = "alb-controller"
  namespace        = var.namespace
  create_namespace = true
  version          = var.controller_version

  set = [
    {
      name  = "albController.podIdentity.clientID"
      value = azurerm_user_assigned_identity.alb_controller.client_id
    },
    {
      name  = "albController.installGatewayApiCRDs"
      value = "true"
    }
  ]
  depends_on = [azurerm_federated_identity_credential.alb_controller]
}

# 3. Install ALB CRDs explicitly via kubectl (null_resource)
resource "null_resource" "install_alb_crds" {
  depends_on = [helm_release.alb_controller]

  provisioner "local-exec" {
    command = <<EOT
      echo "Applying ALB CRDs..."
      kubectl apply -f https://raw.githubusercontent.com/Azure/application-load-balancer-controller/main/config/crds/applicationloadbalancer-crd.yaml
      kubectl apply -f https://raw.githubusercontent.com/Azure/application-load-balancer-controller/main/config/crds/applicationloadbalancerroute-crd.yaml
      kubectl apply -f https://raw.githubusercontent.com/Azure/application-load-balancer-controller/main/config/crds/gateway-crd.yaml
      echo "CRDs applied!"
    EOT
  }
}

# 4. ALB resources (after CRDs exist)
resource "kubernetes_manifest" "alb_resource" {
  for_each   = var.albs
  depends_on = [null_resource.install_alb_crds]

  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = each.value.alb_name
      namespace = var.namespace
      annotations = {
        "alb.networking.azure.io/public-ip-id" = azurerm_public_ip.alb.id
      }
    }
    spec = {
      associations = [{ subnetId = each.value.subnet_id }]
    }
  }
}

# 5. Gateway resources
resource "kubernetes_manifest" "gateway" {
  for_each   = var.albs
  depends_on = [kubernetes_manifest.alb_resource]

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = each.value.gateway_name
      namespace = var.namespace
      annotations = {
        "alb.networking.azure.io/alb-id" = kubernetes_manifest.alb_resource[each.key].metadata[0].name
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
  }
}

# 6. Routes for each app
resource "kubernetes_manifest" "alb_routes" {
  for_each   = { for alb_key, alb_val in var.albs : alb_key => alb_val.apps }
  depends_on = [kubernetes_manifest.gateway]

  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancerRoute"
    metadata = {
      name      = "${each.key}-route"
      namespace = var.namespace
    }
    spec = {
      gatewayRef = {
        name      = kubernetes_manifest.gateway[each.key].metadata[0].name
        namespace = var.namespace
      }
      backendRefs = [
        {
          name      = each.value.istio_bridge.svc_name
          namespace = each.value.istio_bridge.namespace
          port      = each.value.istio_bridge.svc_port
          weight    = 100
        }
      ]
      rules = [
        {
          host = each.value.istio_bridge.hostname
          path = "/*"
        }
      ]
    }
  }
}
