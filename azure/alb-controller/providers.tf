terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.60.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.1.1"
    }
  }
}
provider "azurerm" {
  features {}
}
# Removed the 'alias = "aks"' to make this the default for all k8s resources
provider "kubernetes" {
  host                   = var.cluster_endpoint
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}

# This block tells Helm how to talk to your AKS cluster
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    client_certificate     = base64decode(var.client_certificate)
    client_key             = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}