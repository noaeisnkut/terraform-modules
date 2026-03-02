variable "location" {
  type        = string
  description = "Azure region where the AKS cluster will be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "Existing resource group name."
}

variable "cluster_name" {
  type        = string
  description = "The AKS cluster name."
}

variable "dns_prefix" {
  type        = string
  default     = null
  description = "DNS prefix. If null, generated from cluster name."
}

variable "enable_rbac" {
  type        = bool
  default     = false
  description = "Enable Role-Based Access Control"
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "Managed identity type"
}

variable "aks_subnet_id" {
  type        = string
  description = "Subnet ID for the default node pool"
}

variable "network_plugin" {
  type        = string
  default     = "azure"
  description = "Network plugin (azure, kubenet)"
}

variable "network_plugin_mode" {
  type        = string
  default     = "overlay"
  description = "Network plugin mode"
}

variable "network_data_plane" {
  type        = string
  default     = "cilium"
  description = "Network data plane"
}

variable "pod_cidr" {
  type        = string
  default     = null
  description = "Optional pod CIDR"
}

variable "service_cidr" {
  type        = string
  default     = "10.240.0.0/16"
  description = "Optional service CIDR"
}

variable "dns_service_ip" {
  type        = string
  default     = null
  description = "Optional DNS service IP"
}

variable "default_node_pool_name" {
  type        = string
  default     = "systempool"
  description = "Default node pool name"
}

variable "default_node_vm_size" {
  type        = string
  default     = "Standard_DC2s_v3"
  description = "VM size for default node pool"
}

variable "default_node_count" {
  type        = number
  default     = 1
  description = "Initial node count if autoscaling disabled"
}

variable "default_auto_scaling_enabled" {
  type        = bool
  default     = true
  description = "Enable autoscaling for default node pool"
}

variable "default_min_count" {
  type        = number
  default     = 1
  description = "Min count for default node pool"
}

variable "default_max_count" {
  type        = number
  default     = 2
  description = "Max count for default node pool"
}

variable "enable_node_public_ip" {
  type        = bool
  default     = false
  description = "Should nodes have public IP?"
}

variable "extra_node_pools_fixed" {
  type = map(object({
    vm_size    = string
    node_count = number
    subnet_id  = string
  }))
  default     = {}
  description = "Fixed node count node pools"
}

variable "extra_node_pools_autoscale" {
  type = map(object({
    vm_size   = string
    min_count = number
    max_count = number
    subnet_id = string
  }))
  default     = {}
  description = "Autoscale enabled node pools"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags applied to resources"
}