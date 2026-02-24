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