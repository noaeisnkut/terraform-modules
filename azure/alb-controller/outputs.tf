output "identity_client_id" {
  description = "The Client ID of the ALB Controller Managed Identity"
  value       = azurerm_user_assigned_identity.alb_controller.client_id
}

output "albs" {
  value = {
    for k, v in var.albs : k => {
      alb_name = v.alb_name
      alb_ip   = azurerm_public_ip.alb[k].ip_address
    }
  }
}