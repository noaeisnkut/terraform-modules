include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/external-dns?ref=main"
}

dependency "alb" {
  config_path = "../alb-controller"
}

inputs = {
  zone_name           = "flask-app.com"
  resource_group_name = "rg-dns-dev"

  records_map = {
    argocd = dependency.alb.outputs.alb_public_ip
    app    = dependency.alb.outputs.alb_public_ip
  }

  ttl = 300
}