variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "location" {
  type        = string
  description = "Azure region where VNet will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the VNet is deployed"
}

variable "address_space" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Address space for the VNet"
}

variable "tags" {
  type        = map(string)
  default     = { managed_by = "terraform" }
  description = "Tags to assign to the VNet"
}

# AKS subnet
variable "aks_subnet_name" {
  type        = string
  default     = "aks-subnet"
  description = "Subnet name for AKS cluster"
}

variable "aks_subnet_prefix" {
  type        = string
  default     = "10.0.1.0/24"
  description = "Address prefix for the AKS subnet"
}

# ALB subnet
variable "alb_subnet_name" {
  type        = string
  default     = "alb-subnet"
  description = "Subnet name for ALB / application gateway"
}

variable "alb_subnet_prefix" {
  type        = string
  default     = "10.0.2.0/24"
  description = "Address prefix for the ALB subnet"
}

# DB subnet
variable "db_subnet_name" {
  type        = string
  default     = "db-subnet"
  description = "Subnet name for private database"
}

variable "db_subnet_prefix" {
  type        = string
  default     = "10.0.3.0/24"
  description = "Address prefix for the database subnet"
}