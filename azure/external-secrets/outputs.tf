output "vault_ids" {
  description = "Map of vault names to their IDs."
  value       = { for k, v in azurerm_key_vault.this : k => v.id }
}

output "secret_ids" {
  description = "Map of flattened secret keys to their resource IDs."
  value       = { for k, v in azurerm_key_vault_secret.this : k => v.id }
}