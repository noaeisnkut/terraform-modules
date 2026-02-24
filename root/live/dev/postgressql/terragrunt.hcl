include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/postgressql?ref=main"
}

dependency "vnet" {
  config_path = "../vnet"
}

dependency "external-secrets" {
  config_path = "../external-secrets"
}

inputs = {
  resource_group_name = "rg-flask-app"
  location            = "East US"
  server_name         = "flask-db-prod"
  db_name             = "second_hand_shop"
  admin_username      = "psqladmin"

  # Key Vault where DB password will be stored
  key_vault_id = dependency.external-secrets.outputs.key_vault_id
  secret_name  = "flask-app-db-password"

  # Network
  vnet_id      = dependency.vnet.outputs.vnet_id
  db_subnet_id = dependency.vnet.outputs.subnets["db_subnet"]

  # Optional PostgreSQL settings (can override defaults)
  postgresql_version   = "14"
  sku_name             = "B_Standard_B1ms"
  storage_mb           = 32768
  backup_retention_days = 7
}