data "azurerm_client_config" "current" {}

# 1. Create Multiple Vaults
resource "azurerm_key_vault" "this" {
  for_each            = var.key_vaults
  name                = each.key
  location            = each.value.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  purge_protection_enabled = false

  tags = var.tags
}

# 2. Access Policy (Required to actually set the secrets)
resource "azurerm_key_vault_access_policy" "deployer" {
  for_each     = azurerm_key_vault.this
  key_vault_id = each.value.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "List", "Set", "Delete", "Purge"]
}

# 3. Flatten Secrets
locals {
  vault_secrets = flatten([
    for vault_key, vault_val in var.key_vaults : [
      for secret_key, secret_val in vault_val.secrets : {
        vault_key    = vault_key
        secret_name  = secret_key
        secret_value = secret_val
      }
    ]
  ])
}

# 4. Create Secrets
resource "azurerm_key_vault_secret" "this" {
  for_each     = { for s in local.vault_secrets : "${s.vault_key}-${s.secret_name}" => s }

  name         = each.value.secret_name
  value        = each.value.secret_value
  key_vault_id = azurerm_key_vault.this[each.value.vault_key].id

  depends_on = [azurerm_key_vault_access_policy.deployer]

  lifecycle {
    ignore_changes = [tags, value, expiration_date] # FIX: added value to ignore changes if manually updated
  }
}