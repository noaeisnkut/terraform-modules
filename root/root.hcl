remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = "rg-second-clothes-project"
    storage_account_name = "stsecondclothesproj"      
    container_name       = "tfstate"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  azure_region  = "eastus"
  project_name  = "second-clothes-app"
}
