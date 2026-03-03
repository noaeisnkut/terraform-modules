variable "resource_group_name" {
  type        = string
  description = "The Resource Group of the AKS cluster."
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

variable "private_subnet_id" {
  type        = string
  description = "Subnet ID for the internal Istio gateway (used only if creating a LoadBalancer/ALB)"
  default     = null
}

variable "external_gateway_service_type" {
  type    = string
  default = "ClusterIP"
  description = "Service type for the Istio external gateway. Use ClusterIP if an external ALB is handling traffic."
}

variable "gateway_max_replicas" {
  type    = number
  default = 5
}

variable "gateway_cpu_target" {
  type    = number
  default = 80
}
variable "cluster_endpoint" {
  type        = string
  description = "The API endpoint of the AKS cluster"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "Base64-encoded CA certificate for the AKS cluster"
}

variable "client_certificate" {
  type        = string
  description = "Base64-encoded client certificate for the AKS cluster"
}

variable "client_key" {
  type        = string
  description = "Base64-encoded client key for the AKS cluster"
}