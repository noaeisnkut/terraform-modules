output "argocd_fqdn" {
  value = "${azurerm_dns_a_record.argocd.name}.${var.zone_name}"
}

output "flask_fqdn" {
  value = "${azurerm_dns_a_record.flask.name}.${var.zone_name}"
}