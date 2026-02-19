variable "resource_group_name" {
  type        = string
  description = "The Resource Group of the AKS cluster."
}

variable "vnet_resource_group_name" {
  type        = string
  description = "The Resource Group where the VNet is located."
}

variable "vnet_name" {
  type        = string
  description = "The name of the Virtual Network."
}

variable "istio_release_version" {
  type    = string
  default = "1.24.0"
}

variable "istio_release_namespace" {
  type    = string
  default = "istio-system"
}

variable "istio_enable_external_gateway" {
  type    = bool
  default = true
}

variable "istio_enable_internal_gateway" {
  type    = bool
  default = false
}

variable "public_subnet_name" {
  type    = string
  default = "snet-public"
}

variable "private_subnet_name" {
  type    = string
  default = "snet-private"
}

variable "external_gateway_static_ip" {
  type    = string
  default = null
}

variable "gateway_max_replicas" {
  type    = number
  default = 5
}

variable "gateway_cpu_target" {
  type    = number
  default = 80
}