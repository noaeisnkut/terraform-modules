resource "random_password" "db_password" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_private_dns_zone" "this" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  name                  = "${var.server_name}-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.resource_group_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgresql_version
  delegated_subnet_id    = var.db_subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.this.id
  administrator_login    = var.admin_username
  administrator_password = random_password.db_password.result

  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  backup_retention_days  = var.backup_retention_days

  lifecycle {
    ignore_changes        = [zone]
    create_before_destroy = true
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.this]
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.this.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = var.secret_name
  value        = random_password.admin_password.result
  key_vault_id = var.key_vault_id
}