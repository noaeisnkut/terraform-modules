variable "vnet_name" {
  type        = string
  description = "Name of the Azure Virtual Network"
}

variable "location" {
  type        = string
  description = "Azure region where the VNet will be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the VNet is deployed"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the VNet (CIDR list)"
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "Custom DNS servers for the VNet; empty = Azure default"
}

variable "tags" {
  type        = map(string)
  default     = { managed_by = "terraform" }
  description = "Tags to assign to the VNet and subnets"
}

variable "subnets" {
  type = map(object({
    address_prefixes          = list(string)
    private_endpoint_policies = optional(string, "Enabled")
    service_endpoints         = optional(list(string), [])
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
  description = "Map of subnets with their configurations"
}