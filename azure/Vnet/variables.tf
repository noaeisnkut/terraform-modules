variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where VNet is deployed"
}

variable "address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Address space for the VNet"
}

variable "aks_subnet_name" {
  type        = string
  default     = "aks-subnet"
  description = "Subnet name for AKS cluster"
}

variable "aks_subnet_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Subnet prefix for AKS cluster"
}

variable "aks_subnet_service_endpoints" {
  type        = list(string)
  default     = ["Microsoft.Storage", "Microsoft.Sql"]
  description = "Service endpoints to enable on the AKS subnet"
}

variable "app_subnet_name" {
  type        = string
  default     = "app-subnet"
  description = "Subnet name for application resources"
}

variable "app_subnet_prefix" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Subnet prefix for application resources"
}

variable "tags" {
  type    = map(string)
  default = {
    managed_by = "terraform"
  }
}