include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://github.com/noaeisnkut/terraform-modules.git//azure/external-secrets?ref=main"
}

inputs = {
  resource_group_name = "rg-flask-app-shared"
  location            = "East US"     
  tags = {
    managed_by = "terragrunt"
    project    = "flask-app"
  }

  # Map of vaults
  key_vaults = {
    # Vault to actually create
    "flask-app-kv" = {
      location = "East US"
      secrets = {
        "flask-app-secret" = jsonencode({
          DB_PASSWORD = "temporary-placeholder"
        })
      }
    }

    # Example vault (commented out, won't be created)
    # "flask-app-kv2" = {
    #   location = "East US"
    #   secrets = {
    #     "flask-app-secret" = jsonencode({
    #       DB_PASSWORD = "temporary-placeholder-prod"
    #     })
    #     "another-secret" = "some-value"
    #   }
    # }
  }
}