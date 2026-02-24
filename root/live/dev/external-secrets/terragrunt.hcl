include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/external-secrets?ref=main"
}

inputs = {
  key_vault_name      = "dev-flask-app-kv"
  resource_group_name = "rg-flask-app"
  location            = "East US"

  secrets = {
    "flask-app-secret" = jsonencode({
      DB_PASSWORD = "temporary-placeholder"
    })
  }
}