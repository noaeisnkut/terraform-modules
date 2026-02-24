include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/external-secrets?ref=main"
}


dependency "postgresql" {
  config_path = "../postgresql"
}

dependency "aks" {
  config_path = "../aks"
}

inputs = {
  key_vault_id = dependency.aks.outputs.key_vault_id
  
  secrets = {
    "flask-app-secret" = jsonencode({
      DB_PASSWORD = dependency.postgresql.outputs.admin_password
    })
  }
}