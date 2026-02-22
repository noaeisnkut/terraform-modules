output "fqdn_map" {
  value = { for k, v in azurerm_dns_a_record.this : k => "${k}.${var.zone_name}" }
}