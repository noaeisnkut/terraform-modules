include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/istio?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

inputs = {
  cluster_endpoint       = dependency.aks.outputs.kube_host
  cluster_ca_certificate = dependency.aks.outputs.kube_cluster_ca_certificate
  client_certificate     = dependency.aks.outputs.kube_client_certificate
  client_key             = dependency.aks.outputs.kube_client_key
  resource_group_name   = "rg-flask-app-dev"
  azure_gateway_name    = "external-gateway"
  azure_alb_namespace   = "azure-alb-system"
  istio_release_version         = "1.24.0"
  istio_release_namespace       = "istio-system"
  istio_enable_external_gateway = true
  gateway_max_replicas = 3
  gateway_cpu_target   = 80

}