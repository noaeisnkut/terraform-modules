output "identity_client_id" {
  description = "The Client ID of the ALB Controller Managed Identity"
  value       = azurerm_user_assigned_identity.alb_controller.client_id
}

output "alb_public_ip" {
  description = "The public IP assigned to the ALB"
  value       = azurerm_public_ip.alb.ip_address
}