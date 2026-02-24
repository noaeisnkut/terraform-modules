output "vault_id" {
  description = "The Key Vault ID used by this module."
  value       = local.vault_id
}

output "secret_ids" {
  description = "The Resource IDs of the created secrets."
  value       = { for k, v in azurerm_key_vault_secret.this : k => v.id }
}

output "secret_names" {
  description = "The names of the secrets created."
  value       = keys(azurerm_key_vault_secret.this)
}