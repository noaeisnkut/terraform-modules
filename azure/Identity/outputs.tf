output "identity_client_id" {
  value = azurerm_user_assigned_identity.flask_app.client_id
}

output "identity_resource_id" {
  value = azurerm_user_assigned_identity.flask_app.id
}

output "service_account_name" {
  value = kubernetes_service_account_v1.flask_app_sa
}