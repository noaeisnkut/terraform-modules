output "vnet_id" {
  value       = azurerm_virtual_network.this.id
  description = "The ID of the Azure Virtual Network"
}

output "subnet_ids" {
  value       = { for k, s in azurerm_subnet.this : k => s.id }
  description = "Map of subnet IDs keyed by subnet name"
}