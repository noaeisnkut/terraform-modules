data "azurerm_subscription" "current" {}
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

# 1. Create the ALB Resources (The "Hardware")
resource "kubernetes_manifest" "alb_resource" {
  for_each = var.albs
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


resource "kubernetes_manifest" "gateway" {
  for_each = var.albs # Loop here too!
  
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = each.value.gateway_name # Use the name from the map
      namespace = var.namespace
      annotations = {
        # CRITICAL: This links the Gateway to a specific ALB resource
        "alb.networking.azure.io/alb-id" = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ServiceNetworking/trafficControllers/${each.value.alb_name}"
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
  depends_on = [kubernetes_manifest.alb_resource]
}

