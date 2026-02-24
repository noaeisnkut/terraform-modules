include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/istio?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

dependency "alb" {
  config_path = "../alb-controller"
  mock_outputs = {
    azure_gateway_name  = "external-gateway"
    azure_alb_namespace = "azure-alb-system"
  }
}

inputs = {
  cluster_endpoint       = dependency.aks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.aks.outputs.cluster_ca_certificate
  client_certificate     = dependency.aks.outputs.client_certificate
  client_key             = dependency.aks.outputs.client_key

  azure_gateway_name      = "external-gateway"
  azure_alb_namespace     = "azure-alb-system"
  flask_app_hostname      = "my-fav-second-hand-shop.com"

  istio_release_version         = "1.24.0"
  istio_release_namespace       = "istio-system"
  istio_enable_external_gateway = true
  
  gateway_max_replicas = 3
  gateway_cpu_target   = 80
}