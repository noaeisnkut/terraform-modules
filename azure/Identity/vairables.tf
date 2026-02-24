variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "env"                 { type = string }
variable "namespace"           { type = string }
variable "key_vault_id"        { type = string }
variable "aks_oidc_issuer_url" {
  description = "The OIDC issuer URL for the AKS cluster"
  type        = string
}
variable "storage_account_id" {
  description = "The Resource ID of the Azure Storage Account"
  type        = string
}