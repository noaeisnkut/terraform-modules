output "identity_client_id" {
  description = "The Client ID of the Managed Identity for the Flask App"
  value       = azurerm_user_assigned_identity.flask_app.client_id
}

output "identity_resource_id" {
  value = azurerm_user_assigned_identity.flask_app.id
}