variable "zone_name" {
  type        = string
  description = "DNS zone name (e.g. example.com)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where DNS zone exists"
}

variable "records_map" {
  type        = map(string)
  description = "Map of subdomain => IP address, e.g. { argocd = 1.2.3.4, app = 1.2.3.4 }"
}

variable "ttl" {
  type        = number
  default     = 300
}
variable "location" {
  description = "Azure location for DNS"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL for federated identity"
  type        = string
  
}