resource "azurerm_dns_a_record" "this" {
  for_each = var.records_map

  name                = each.key
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = [each.value]
}
resource "azurerm_dns_zone" "flask_app" {
  name                = var.zone_name
  resource_group_name = var.resource_group_name
}