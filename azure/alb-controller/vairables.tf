variable "name" {
  description = "Base name for ALB resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for ALB"
  type        = string
}

variable "location" {
  description = "Azure location for ALB"
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for ALB controller and CRDs"
  type        = string
}

variable "service_account_name" {
  description = "Kubernetes service account name for the ALB controller"
  type        = string
}

variable "controller_version" {
  description = "ALB controller Helm chart version"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL for federated identity"
  type        = string
}

variable "albs" {
  description = "Map of ALBs to create"
  type = map(object({
    alb_name     = string
    gateway_name = string
    subnet_id    = string
    apps = map(object({
      hostname  = string
      svc_name  = string
      namespace = string
      svc_port  = number
    }))
  }))
}