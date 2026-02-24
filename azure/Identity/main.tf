# 1. THE IDENTITY: The "User" your app will act as
resource "azurerm_user_assigned_identity" "flask_app" {
  name                = "id-flask-app-${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# 2. THE TRUST (OIDC): Connects the AKS Service Account to the Identity
resource "azurerm_federated_identity_credential" "flask_federated" {
  name                = "fed-flask-app"
  resource_group_name = var.resource_group_name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.flask_app.id
  subject             = "system:serviceaccount:${var.namespace}:flask-app-sa"
}

# 3. VAULT PERMISSION: Allows SDK to pull DB secrets
resource "azurerm_key_vault_access_policy" "flask_vault_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.flask_app.principal_id

  secret_permissions = ["Get", "List"]
}

# 4. STORAGE PERMISSION: Allows SDK to upload images
resource "azurerm_role_assignment" "storage_access" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.flask_app.principal_id
}