resource "azurerm_user_assigned_identity" "flask_app" {
  name                = "id-flask-app-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_federated_identity_credential" "flask_federated" {
  name                = "fed-flask-app"
  resource_group_name = var.resource_group_name
  audience            = "api://AzureADTokenExchange" # STRING fixed
  issuer              = var.aks_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.flask_app.id
  subject             = "system:serviceaccount:${var.namespace}:${var.sa_name}"
}

resource "kubernetes_service_account" "flask_app_sa" {
  metadata {
    name      = var.sa_name
    namespace = var.namespace
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.flask_app.client_id
    }
  }
}

resource "azurerm_key_vault_access_policy" "flask_vault_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.flask_app.principal_id
  secret_permissions = ["Get", "List"]
}

resource "azurerm_role_assignment" "storage_access" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.flask_app.principal_id
}