include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/alb-controller?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

dependency "vnet" {
  config_path = "../vnet"
}

dependency "istio" {
  config_path = "../istio"
  mock_outputs = {
    istio_namespace         = "istio-system"
    istio_ingress_service_name = "istio-ingressgateway"
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
        istio_bridge = {
          namespace = dependency.istio.outputs.istio_namespace
          svc_name  = dependency.istio.outputs.istio_ingress_service_name
          svc_port  = 80
          hostname  = "my-fav-second-hand-shop.com"
        }
      }
    }
  }
}