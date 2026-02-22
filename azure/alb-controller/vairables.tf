variable "name" {
  type        = string
  description = "Base name for ALB controller resources"
  default     = "azure-alb-controller"
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

variable "apps" {
  type = map(object({
    namespace = string
    svc_name  = string
    svc_port  = number
    hostname  = string
  }))
  description = "Apps to expose via ALB/Gateway API"
}
variable "albs" {
  type = map(object({
    alb_name    = string
    gateway_name = string
    subnet_id   = string
    apps        = map(object({
      namespace = string
      svc_name  = string
      svc_port  = number
      hostname  = string
    }))
  }))
}