data "azurerm_client_config" "current" {}
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.secrets
  name         = each.key
  value        = each.value
  key_vault_id = local.vault_id

  lifecycle {
    ignore_changes = [
      tags,
      expiration_date
    ]
  }
}
