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

variable "private_subnet_name" {
  type    = string
  default = "snet-private"
}

variable "azure_gateway_name" {
  type        = string
  description = "The name of the Gateway resource created by the ALB controller."
  # Example: "external-gateway"
}

variable "azure_alb_namespace" {
  type        = string
  description = "The namespace where the Azure ALB Gateway resides."
  default     = "azure-alb-system"
}

variable "flask_app_hostname" {
  type        = string
  description = "The hostname for the Flask application to be routed through Istio."
  # Example: "app.flask-app.com"
}

variable "gateway_max_replicas" {
  type    = number
  default = 5
}

variable "gateway_cpu_target" {
  type    = number
  default = 80
}
