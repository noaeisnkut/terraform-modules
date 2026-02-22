variable "environment" {
  type        = string
  description = "The deployment environment (e.g., prod, dev, staging)"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the existing Resource Group"
}

variable "cluster_name" {
  type        = string
  description = "The name of the AKS cluster"
}

variable "aks_oidc_issuer_url" {
  type        = string
  description = "The OIDC issuer URL from the AKS cluster (required for Workload Identity)"
}

variable "workload_sa_name" {
  type        = string
  default     = "flask-app-sa"
  description = "The name of the Kubernetes Service Account"
}

variable "workload_sa_namespace" {
  type        = string
  default     = "default"
  description = "The Kubernetes namespace where the Service Account lives"
}