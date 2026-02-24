include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/postgressql?ref=main"
}

dependency "vnet" {
  config_path = "../vnet"
}

dependency "aks" {
  config_path = "../aks"
}

inputs = {
  resource_group_name = "rg-flask-app"
  location            = "East US"
  server_name         = "flask-db-prod"
  db_name             = "second_hand_shop"
  
  # Network from VNET
  vnet_id      = dependency.vnet.outputs.vnet_id
  db_subnet_id = dependency.vnet.outputs.db_subnet_id
  key_vault_id = dependency.aks.outputs.key_vault_id
  admin_username = "psqladmin"
}