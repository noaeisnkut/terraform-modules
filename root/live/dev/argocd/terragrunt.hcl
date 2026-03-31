include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/argocd?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}
inputs = {
  cluster_endpoint       = dependency.aks.outputs.kube_host
  cluster_ca_certificate = dependency.aks.outputs.kube_cluster_ca_certificate
  client_certificate     = dependency.aks.outputs.kube_client_certificate
  client_key             = dependency.aks.outputs.kube_client_key
  argocd_config = {
    hostname = "argocd.flask-app.com"
  }
  argocd_version = "7.7.0"
}