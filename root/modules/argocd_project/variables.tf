variable "project_name" {
  type        = string
  description = "Name of the ArgoCD project"
}

variable "project_yaml" {
  type        = string
  description = "Path to the AppProject YAML file"
}

variable "apps" {
  type = map(object({
    name                 : string
    repo_url             : string
    target_revision      : string
    path                 : string
    helm_value_files     : list(string)
    destination_namespace: string
    destination_server   : string
  }))
  description = "Applications to create under the project"
}
