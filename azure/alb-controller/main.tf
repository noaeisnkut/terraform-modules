###########################
# Azure Identity
###########################
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
  scope                = var.alb_subnet_id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_controller.principal_id
}
###########################
# Create Namespaces for Apps
###########################
resource "kubernetes_namespace_v1" "apps" {
  for_each = var.apps

  metadata {
    name = each.value.namespace
  }
}
###########################
# ALB Controller Helm
###########################
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

###########################
# ALB Resource
###########################
resource "kubernetes_manifest" "alb_resource" {
  for_each = var.albs
  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = each.value.alb_name
      namespace = var.namespace
    }
    spec = {
      associations = [{ subnetId = each.value.subnet_id }]
    }
  }
}

###########################
# Gateway
###########################
resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = var.gateway_name
      namespace = var.namespace
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
###########################
# HTTPRoute for Apps (Dynamic)
###########################
resource "kubernetes_manifest" "http_routes" {
  for_each = var.apps

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "${each.key}-route"
      namespace = each.value.namespace
    }
    spec = {
      parentRefs = [{
        name      = var.gateway_name
        namespace = var.namespace
      }]
      hostnames = [each.value.hostname]
      rules = [{
        matches = [{ path = { type = "PathPrefix", value = "/" } }]
        backendRefs = [{
          name = each.value.svc_name
          port = each.value.svc_port
        }]
      }]
    }
  }

  depends_on = [
    kubernetes_manifest.gateway,
    kubernetes_namespace_v1.apps
  ]
}