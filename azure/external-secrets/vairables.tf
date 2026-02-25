variable "resource_group_name" {
  type        = string
  description = "Resource group where vaults will be created."
}

variable "location" {
  type        = string
  description = "Azure location for Key Vaults."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to all vaults and secrets."
  default = {
    managed_by = "terraform"
    module     = "external-secrets"
  }
}

variable "key_vaults" {
  type = map(object({
    location = string
    secrets  = map(string)
  }))
  default = {}
}