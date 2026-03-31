include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/aks?ref=main"
}

dependency "vnet" {
  config_path = "../Vnet"
}

inputs = {
  environment               = "dev"
  location                  = "East US"
  resource_group_name       = "rg-flask-app-dev" 
  cluster_name              = "cluster-dev-flask-app"
  node_provisioning_mode    = "Auto"


  vnet_id      = dependency.vnet.outputs.vnet_id
  aks_subnet_id = dependency.vnet.outputs.subnet_ids["aks_subnet"]
}