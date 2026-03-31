include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/alb-controller?ref=main"
}

dependency "aks" {
  config_path = "../aks"
}

dependency "vnet" {
  config_path = "../Vnet"
}

dependency "istio" {
  config_path = "../istio"
}

dependency "argocd" {
  config_path = "../argocd"
}

inputs = {
  name                = "dev-alb-controller"
  cluster_endpoint       = dependency.aks.outputs.kube_host
  cluster_ca_certificate = dependency.aks.outputs.kube_cluster_ca_certificate
  client_certificate     = dependency.aks.outputs.kube_client_certificate
  client_key             = dependency.aks.outputs.kube_client_key
  

  location            = "East US"
  resource_group_name = "rg-flask-app-dev"
  subscription_id     = "8630b178-3a02-4f25-b248-508aada24bcc"
  oidc_issuer_url     = dependency.aks.outputs.oidc_issuer_url

  namespace            = "kube-system" 
  service_account_name = "alb-controller-sa"
  controller_version   = "1.2.3" 


  albs = {
    alb1 = {
      alb_name     = "alb-dev"
      gateway_name = "external-gateway"
      subnet_id    = dependency.vnet.outputs.subnet_ids["alb_subnet"]

      apps = {
        argocd = {
          namespace = dependency.argocd.outputs.argocd.namespace
          svc_name  = dependency.argocd.outputs.argocd.svc_name
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