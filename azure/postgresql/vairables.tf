variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "server_name"         { type = string }
variable "vnet_id"             { type = string }
variable "db_subnet_id"        { type = string }
variable "db_name"             { type = string }

variable "admin_username" {
  type    = string
  default = "psqladmin"
}

variable "sku_name" {
  type    = string
  default = "B_Standard_B1ms"
}

variable "postgresql_version" {
  type    = string
  default = "14"
}

variable "storage_mb" {
  type    = number
  default = 32768
}

variable "backup_retention_days" {
  type    = number
  default = 7
}
variable "key_vault_id" {
  description = "The ID of the Key Vault where the secret will be stored"
  type        = string
}
variable "secret_name" {
  type        = string
  description = "The name of the secret in Key Vault for the DB password."
}
