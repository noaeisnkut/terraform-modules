output "postgresql_server_id" {
  description = "The Resource ID of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.this.id
}

output "postgresql_server_fqdn" {
  description = "The Fully Qualified Domain Name of the PostgreSQL Flexible Server"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_name" {
  description = "The name of the default database created"
  value       = azurerm_postgresql_flexible_server_database.this.name
}

output "admin_username" {
  value = var.admin_username
}

output "admin_password" {
  value     = random_password.db_password.result
  sensitive = true
}