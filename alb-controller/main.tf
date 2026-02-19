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
  }
]


  depends_on = [azurerm_federated_identity_credential.alb_controller]
}