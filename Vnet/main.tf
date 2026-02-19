resource "azurerm_subnet" "small_app_subnet" {
  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.address_prefix]
  private_endpoint_network_policies = "Enabled"
}