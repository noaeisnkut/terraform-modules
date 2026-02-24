locals {
  vault_id = var.key_vault_id != null ? var.key_vault_id : azurerm_key_vault.this[0].id
}
