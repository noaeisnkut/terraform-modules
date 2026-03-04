variable "name" {
  type        = string
  description = "Base name for ALB controller resources"
  default     = "azure-alb-controller"
}
variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}
variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
}

variable "oidc_issuer_url" {
  type        = string
}

variable "alb_subnet_id" {
  type        = string
}

variable "namespace" {
  type        = string
  default     = "azure-alb-system"
}

variable "service_account_name" {
  type    = string
  default = "alb-controller-sa"
}

variable "controller_version" {
  type    = string
  default = "1.9.11"
}

variable "alb_resource_name" {
  type    = string
  default = "alb-infra"
}

variable "gateway_name" {
  type    = string
  default = "external-gateway"
}

variable "albs" {
  type = map(object({
    alb_name     = string
    gateway_name = string
    subnet_id    = string
    # This is the missing piece!
    apps = map(object({
      namespace = string
      svc_name  = string
      svc_port  = number
      hostname  = string
    }))
  }))
}
variable "cluster_endpoint" {
  type        = string
  description = "The host (URL) of the AKS API server"
}

variable "cluster_ca_certificate" {
  type        = string
  description = "The public CA certificate of the AKS cluster"
}

variable "client_certificate" {
  type        = string
  description = "The client certificate for authenticating to the AKS cluster"
}

variable "client_key" {
  type        = string
  sensitive   = true
  description = "The client key for authenticating to the AKS cluster"
}