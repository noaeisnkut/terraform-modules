include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/alb-controller?ref=main"
}

dependency "aks" {
  config_path = "../aks"

  mock_outputs = {
    oidc_issuer_url = "https://mock-url.com"
  }
}

dependency "vnet" {
  config_path = "../vnet"

  mock_outputs = {
    alb_subnet_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/alb-subnet"
  }
}

inputs = {
  name                = "dev-alb-controller"
  location            = "East US"
  resource_group_name = "rg-flask-app-dev"
  oidc_issuer_url     = dependency.aks.outputs.oidc_issuer_url

  albs = {
    alb1 = {
      alb_name     = "alb-infra"
      gateway_name = "external-gateway"
      subnet_id    = dependency.vnet.outputs.alb_subnet_id
      apps = {
        argocd = {
          namespace = "argocd"
          svc_name  = "argocd-server"
          svc_port  = 80
          hostname  = "argocd.flask-app.com"
        }
        flask = {
          namespace = "flask-app"
          svc_name  = "istio-ingressgateway-external"
          svc_port  = 80
          hostname  = "app.flask-app.com"
        }
      }
    }

    # Example for future ALBs:
    # alb2 = {
    #   alb_name     = "alb-infra2"
    #   gateway_name = "external-gateway2"
    #   subnet_id    = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/alb-subnet2"
    #   apps = {
    #     myapp = {
    #       namespace = "myapp-ns"
    #       svc_name  = "myapp-svc"
    #       svc_port  = 8080
    #       hostname  = "app2.flask-app.com"
    #     }
    #   }
    # }
  }
}