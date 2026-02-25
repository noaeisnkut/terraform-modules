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

variable "node_pool_name" {
  type        = string
  description = "The name of the AKS node pool"
  default     = "systempool"
}

variable "node_vm_size" {
  type        = string
  description = "The VM size for the AKS nodes"
  default     = "Standard_DS2_v2"
}

variable "node_count" {
  type        = number
  description = "The number of nodes in the AKS node pool"
  default     = 1
}

variable "auto_scaling_enabled" {
  type        = bool
  description = "Enable or disable auto-scaling for the AKS node pool"
  default     = false
}

variable "min_count" {
  type    = number
  default = 1
}

variable "max_count" {
  type    = number
  default = 3
}