include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/identity?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

dependency "vnet" {
  config_path = "../Vnet"
}

dependency "external-secrets" {
  config_path = "../external-secrets"
}

inputs = {
  env                 = "dev"
  namespace           = "default"               
  sa_name             = "flask-app-sa"           
  resource_group_name = "rg-flask-app-dev"       
  location            = "East US"

  storage_account_id  = "/subscriptions/8630b178-3a02-4f25-b248-508aada24bcc/resourceGroups/rg-second-clothes-project/providers/Microsoft.Storage/storageAccounts/flaskapppic"
  key_vault_id        = dependency.external-secrets.outputs.key_vault_ids["flask-app-kv"]
  aks_oidc_issuer_url = dependency.aks.outputs.oidc_issuer_url
  kube_host                  = dependency.aks.outputs.kube_host
  kube_client_certificate    = dependency.aks.outputs.kube_client_certificate
  kube_client_key            = dependency.aks.outputs.kube_client_key
  kube_cluster_ca_certificate = dependency.aks.outputs.kube_cluster_ca_certificate
}