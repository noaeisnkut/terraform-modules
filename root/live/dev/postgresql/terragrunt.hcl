include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/postgresql?ref=main"
}

dependency "vnet" {
  config_path = "../Vnet"
} 

dependency "external-secrets" {
  config_path = "../external-secrets"
}

inputs = {
  resource_group_name = "rg-flask-app-shared"
  location            = "East US"

  server_name    = "flask-db"
  db_name        = "second_hand_shop"
  admin_username = "psqladmin"
  key_vault_id   = dependency.external-secrets.outputs.vault_ids["flask-app-kv"]
  secret_name    = "flask-app-kv-flask-app-secret"

  vnet_id      = dependency.vnet.outputs.vnet_id
  db_subnet_id = dependency.vnet.outputs.subnet_ids["db_subnet"]


  postgresql_version    = "14"
  sku_name              = "B_Standard_B1ms"
  storage_mb            = 32768
  backup_retention_days = 7
}