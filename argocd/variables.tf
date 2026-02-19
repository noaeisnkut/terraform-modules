variable "project_name" {
  type        = string
  description = "Name of the ArgoCD project"
}

variable "apps" {
  type = map(object({
    name                  : string
    repo_url              : string
    target_revision       : string
    path                  : string
    helm_value_files      : list(string)
    destination_namespace : string
    destination_server    : string
  }))
  description = "Manifest-based applications to deploy via ArgoCD"
}

variable "argocd_version" {
  type    = string
  default = "9.0.5"
}

variable "cluster_name" {}
variable "cluster_endpoint" {}
variable "cluster_certificate_authority_data" {}
variable "cluster_token" {}
variable "oidc_issuer_url" {}
