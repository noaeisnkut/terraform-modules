include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/istio?ref=main"
}

dependency "aks" {
  config_path = "../aks"

  mock_outputs = {
    cluster_name           = "mock-cluster"
    cluster_endpoint       = "https://mock-aks.azure.com"
    cluster_ca_certificate = "bW9jay1jZXJ0"
    client_certificate     = "bW9jay1jZXJ0"
    client_key             = "bW9jay1rZXk="
    resource_group_name    = "rg-mock"
  }
}
dependency "vnet" {
  config_path = "../vnet"

  mock_outputs = {
    vnet_name                = "mock-vnet"
    vnet_resource_group_name = "rg-mock-vnet"
    private_subnet_name      = "snet-private"
  }
}

inputs = {
  cluster_endpoint       = dependency.aks.outputs.cluster_endpoint
  cluster_ca_certificate = dependency.aks.outputs.cluster_ca_certificate
  client_certificate     = dependency.aks.outputs.client_certificate
  client_key             = dependency.aks.outputs.client_key

  resource_group_name      = dependency.aks.outputs.resource_group_name
  vnet_name                = dependency.vnet.outputs.vnet_name
  vnet_resource_group_name = dependency.vnet.outputs.vnet_resource_group_name
  private_subnet_name      = "snet-istio" 


  istio_release_version         = "1.24.0"
  istio_release_namespace       = "istio-system"
  istio_enable_external_gateway = true
  istio_enable_internal_gateway = false
  
  gateway_max_replicas = 3
  gateway_cpu_target   = 80
}