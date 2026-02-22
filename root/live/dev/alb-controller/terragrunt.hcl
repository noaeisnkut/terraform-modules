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
  oidc_issuer_url      = dependency.aks.outputs.oidc_issuer_url
  alb_subnet_id        = dependency.vnet.outputs.alb_subnet_id
  namespace            = "azure-alb-dev"
  service_account_name = "alb-controller-sa"
  controller_version   = "1.9.11"
  alb_resource_name    = "alb-infra"
  gateway_name         = "external-gateway"
  istio_namespace      = "istio-system"
  istio_svc_name       = "istio-ingressgateway-external"
  istio_svc_port       = 80
  route53_zone_id      = "Z0123456789ABCDEF"
  domain_name          = "app.yourdomain.com"
}