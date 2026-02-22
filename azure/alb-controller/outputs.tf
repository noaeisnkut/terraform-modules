output "identity_client_id" {
  value = azurerm_user_assigned_identity.alb_controller.client_id
}

output "identity_principal_id" {
  value = azurerm_user_assigned_identity.alb_controller.principal_id
}

output "helm_release_status" {
  value = helm_release.alb_controller.status
}