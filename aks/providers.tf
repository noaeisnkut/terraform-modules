terraform {
  required_version = ">= 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.60.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}