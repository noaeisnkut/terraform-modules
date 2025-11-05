terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "kubernetes" {
  host = var.cluster_endpoint
  cluster_ca_certificate = can(base64decode(var.cluster_certificate_authority_data)) ? base64decode(var.cluster_certificate_authority_data) : var.cluster_certificate_authority_data
  token = var.cluster_token
}

provider "helm" {
  kubernetes = {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = can(base64decode(var.cluster_certificate_authority_data)) ? base64decode(var.cluster_certificate_authority_data) : var.cluster_certificate_authority_data
    token                  = var.cluster_token
    load_config_file       = false
  }
}
