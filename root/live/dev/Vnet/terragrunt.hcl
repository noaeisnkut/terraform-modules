include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/Vnet?ref=main"
}

inputs = {
  vnet_name           = "vnet-dev"
  location            = "East US"
  resource_group_name = "rg-flask-app-dev"
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = "dev"
    Project     = "flask-app"
  }

  subnets = {
    aks_subnet = {}
    alb_subnet = {
      delegation = {
        name = "alb-delegation"
        service_delegation = {
          name    = "Microsoft.ServiceNetworking/trafficControllers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }
    db_subnet = {
      delegation = {
        name = "postgres-delegation"
        service_delegation = {
          name    = "Microsoft.DBforPostgreSQL/flexibleServers"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }
  }
}