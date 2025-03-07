variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region where resources will be created"
}

variable "tags" {
  type        = map(string)
  description = "Base tags to apply to all resources"
  default     = {}
}

variable "availability_sets" {
  type = map(object({
    name                         = string
    platform_fault_domain_count  = optional(number, 2)
    platform_update_domain_count = optional(number, 5)
    managed                      = optional(bool, true)
    tags                         = optional(map(string), {})
  }))
  description = "Map of availability sets to create"
}
