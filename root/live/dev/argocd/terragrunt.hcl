include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/argocd?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

inputs = {
  cluster_endpoint       = dependency.aks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.aks.outputs.cluster_ca_certificate
  client_certificate     = dependency.aks.outputs.client_certificate
  client_key             = dependency.aks.outputs.client_key
  oidc_issuer_url        = dependency.aks.outputs.oidc_issuer_url
  argocd_version         = "7.7.0"
}