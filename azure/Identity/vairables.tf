variable "resource_group_name" {
  type        = string
  description = "The resource group where resources (identity, SA) will be deployed"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be deployed"
}

variable "env" {
  type        = string
  description = "Environment name, e.g., dev, staging, prod"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where the Service Account will be created"
}

variable "sa_name" {
  type        = string
  default     = "flask-app-sa"
  description = "Name of the Kubernetes Service Account"
}

variable "key_vault_id" {
  type        = string
  description = "Resource ID of the Key Vault to assign secret access"
}

variable "aks_oidc_issuer_url" {
  type        = string
  description = "OIDC issuer URL of the AKS cluster for workload identity federation"
}

variable "storage_account_id" {
  type        = string
  description = "Resource ID of the Azure Storage Account to assign blob permissions"
}

# Kubernetes provider info
variable "kube_host" {
  type        = string
  description = "Kubernetes API server host URL"
}

variable "kube_client_certificate" {
  type        = string
  description = "Base64-encoded client certificate for the Kubernetes API"
}

variable "kube_client_key" {
  type        = string
  description = "Base64-encoded client key for the Kubernetes API"
}

variable "kube_cluster_ca_certificate" {
  type        = string
  description = "Base64-encoded cluster CA certificate for the Kubernetes API"
}