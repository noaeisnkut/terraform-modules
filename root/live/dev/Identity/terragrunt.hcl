include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/identity?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

dependency "vnet" {
  config_path = "../vnet"
}

dependency "external-secrets" {
  config_path = "../external-secrets"
}

inputs = {
  # Environment and naming
  env                 = "dev"
  namespace           = "default"                 # Kubernetes namespace for SA
  sa_name             = "flask-app-sa"           # Service Account name
  resource_group_name = "rg-flask-app-dev"       # Matches your AKS RG
  location            = "East US"

  # Azure resource IDs
  storage_account_id  = dependency.vnet.outputs.storage_account_id # or pass storage account ID
  key_vault_id        = dependency.external-secrets.outputs.key_vault_ids["flask-app-kv"]

  # AKS OIDC
  aks_oidc_issuer_url = dependency.aks.outputs.oidc_issuer_url

  # Kubernetes provider info (optional if you want Terraform to create SA inside the cluster)
  kube_host                  = dependency.aks.outputs.kube_host
  kube_client_certificate    = dependency.aks.outputs.kube_client_certificate
  kube_client_key            = dependency.aks.outputs.kube_client_key
  kube_cluster_ca_certificate = dependency.aks.outputs.kube_cluster_ca_certificate
}