resource "azurerm_dns_a_record" "argocd" {
  name                = var.argocd_record_name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = [var.alb_public_ip]
}
resource "azurerm_dns_a_record" "flask" {
  name                = var.flask_record_name
  zone_name           = var.zone_name
  resource_group_name = var.resource_group_name
  ttl                 = var.ttl
  records             = [var.alb_public_ip]
}