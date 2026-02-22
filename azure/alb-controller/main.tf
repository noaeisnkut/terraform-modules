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
  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      name      = var.alb_resource_name
      namespace = var.namespace
    }
    spec = {
      associations = [{ subnetId = var.alb_subnet_id }]
    }
  }
  depends_on = [helm_release.alb_controller]
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
# HTTPRoute for ArgoCD
###########################
resource "kubernetes_manifest" "http_route_argocd" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "argocd-route"
      namespace = var.argocd_namespace
    }
    spec = {
      parentRefs = [{
        name      = var.gateway_name
        namespace = var.namespace
      }]
      hostnames = [var.argocd_hostname]
      rules = [{
        matches = [{ path = { type = "PathPrefix", value = "/" } }]
        backendRefs = [{
          name = var.argocd_svc_name
          port = var.argocd_svc_port
        }]
      }]
    }
  }
  depends_on = [kubernetes_manifest.gateway]
}

###########################
# HTTPRoute for Flask via Istio
###########################
resource "kubernetes_manifest" "http_route_flask" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "flask-route"
      namespace = var.flask_namespace
    }
    spec = {
      parentRefs = [{
        name      = var.gateway_name
        namespace = var.namespace
      }]
      hostnames = [var.flask_hostname]
      rules = [{
        matches = [{ path = { type = "PathPrefix", value = "/" } }]
        backendRefs = [{
          name = var.istio_svc_name
          port = var.istio_svc_port
        }]
      }]
    }
  }
  depends_on = [kubernetes_manifest.gateway]
}