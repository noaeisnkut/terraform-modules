include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/external-dns?ref=main"
}

dependency "alb" {
  config_path = "../alb-controller"
}

inputs = {
  zone_name           = "flask-app.com"
  resource_group_name = "rg-flask-app-dev" 
  location            = "East US"


  oidc_issuer_url     = dependency.aks.outputs.oidc_issuer_url
  subscription_id     = "8630b178-3a02-4f25-b248-508aada24bcc"
  tenant_id           = "69bcbb10-71ee-4e74-8a20-20683db9e653" 
}