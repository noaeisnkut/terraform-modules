variable "name" {
  type        = string
  description = "Name of the subnet"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the existing Resource Group"
}

variable "vnet_name" {
  type        = string
  description = "The name of the existing Virtual Network"
}

variable "address_prefix" {
  type        = string
  default     = "10.0.1.0/28"
  description = "The CIDR block for the subnet"
}