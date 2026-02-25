include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/vnet?ref=main"
}

inputs = {
  resource_group_name = "rg-flask-app-dev"
  location            = "East US"
  vnet_name           = "vnet-flask-app-dev"
  address_space       = "10.0.0.0/16"

  # AKS subnet
  aks_subnet_name               = "aks-subnet"
  aks_subnet_prefix             = "10.0.1.0/24"
  aks_subnet_service_endpoints  = ["Microsoft.Storage", "Microsoft.Sql"]

  # ALB subnet
  alb_subnet_name               = "alb-subnet"
  alb_subnet_prefix             = "10.0.2.0/24"

  # DB subnet
  db_subnet_name                = "db-subnet"
  db_subnet_prefix              = "10.0.3.0/24"

  # Tags
  tags = {
    managed_by = "terraform"
  }
}