variable "vnet_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "dns_servers" {
  type        = list(string)
  default     = []
}

variable "tags" {
  type        = map(string)
  default     = { managed_by = "terraform" }
}

variable "subnets" {
  type = map(object({
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
  description = "Map of subnets to be created with automatic IP calculation"
}