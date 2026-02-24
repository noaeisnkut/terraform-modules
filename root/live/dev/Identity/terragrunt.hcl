include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/Identity?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

dependency "vnet" {
  config_path = "../vnet"
}

inputs = {
  env                 = "dev"
  namespace           = "dev"
  resource_group_name = "rg-flask-app"
  location            = "East US"

  aks_oidc_issuer_url = dependency.aks.outputs.oidc_issuer_url
  key_vault_id        = dependency.aks.outputs.key_vault_id
  storage_account_id  = dependency.vnet.outputs.storage_account_id
}