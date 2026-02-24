output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}