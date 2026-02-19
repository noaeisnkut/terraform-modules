variable "name" {
  type        = string
  description = "Base name for the ALB controller resources"
  default     = "azure-alb-controller"
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "oidc_issuer_url" {
  type        = string
  description = "The OIDC Issuer URL from the AKS cluster (required for Workload Identity)"
}

variable "alb_subnet_id" {
  type        = string
  description = "The ID of the subnet where the Application Gateway for Containers will live"
}

variable "namespace" {
  type    = string
  default = "azure-alb-system"
}

variable "service_account_name" {
  type    = string
  default = "alb-controller-sa"
}

variable "controller_version" {
  type    = string
  default = "1.0.0"
}