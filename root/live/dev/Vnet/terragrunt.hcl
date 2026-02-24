include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/vnet?ref=main"
}

inputs = {
  name                = "dev-app-subnet"
  resource_group_name = "rg-flask-app-dev"
  vnet_name           = "vnet-flask-app-dev"
  address_prefix      = "10.0.0.0/16" 
  subnets = {
    aks_subnet = "10.0.1.0/24"
    alb_subnet = "10.0.2.0/24"
    db_subnet  = "10.0.3.0/24"
  }
}