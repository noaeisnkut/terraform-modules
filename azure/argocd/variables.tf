variable "argocd_version" {
  type        = string
  default     = "7.7.0"
  description = "The version of the ArgoCD Helm chart to install"
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
variable "argocd_config" {
  type = object({
    hostname = string
  })
}