variable "key_vault_name" {
  type        = string
  description = "Optional. Name of the Key Vault to create. If not provided, an existing vault ID must be provided."
  default     = null
}

variable "key_vault_id" {
  type        = string
  description = "Optional. The Resource ID of an existing Key Vault. If not provided, a new vault is created."
  default     = null
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to create Key Vault in (required if creating vault)."
  default     = null
}

variable "location" {
  type        = string
  description = "Location of the Key Vault (required if creating vault)."
  default     = null
}

variable "secrets" {
  type        = map(string)
  description = "A map of secrets to create. Key is the secret name, Value is the secret value."
  default     = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the secrets."
  default     = {
    managed_by = "terraform"
    module     = "secret-manager"
  }
}
