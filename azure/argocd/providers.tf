terraform {
  required_version = ">= 1.10" 

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.60.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "2.1.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
    }
  }
}

provider "azurerm" {
  features {}
}
provider "kubernetes" {
  host                   = dependency.aks.outputs.kube_host
  client_certificate     = base64decode(dependency.aks.outputs.kube_client_certificate)
  client_key             = base64decode(dependency.aks.outputs.kube_client_key)
  cluster_ca_certificate = base64decode(dependency.aks.outputs.kube_cluster_ca_certificate)
}