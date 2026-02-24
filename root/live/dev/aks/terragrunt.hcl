include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/aks?ref=main"
}

dependency "vnet" {
  config_path = "../vnet"
}

inputs = {
  environment               = "dev"
  location                  = "East US"
  resource_group_name       = "rg-app-flask-dev"
  cluster_name              = "cluster-dev-flask-app"
  node_provisioning_mode    = "Auto"
  workload_sa_name          = "flask-app-sa"
  workload_sa_namespace     = "default"
  workload_identity_enabled = true

  # VNET / Subnet
  vnet_id    = dependency.vnet.outputs.vnet_id
  subnet_id  = dependency.vnet.outputs.subnets["aks_subnet"]
}