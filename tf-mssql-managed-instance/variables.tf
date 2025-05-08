variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

# Add this new variable
variable "enable_directory_readers_role" {
  description = "Whether to grant Directory Readers role to the managed identity of the SQL Managed Instance"
  type        = bool
  default     = false
}

variable "managed_instances" {
  description = "Map of SQL Managed Instances to create"
  type = map(object({
    license_type                 = string
    sku_name                     = string
    storage_size_in_gb           = number
    vcores                       = number
    subnet_id                    = string
    administrator_login          = string
    administrator_login_password = string
    identity_type                = string
    identity_ids                 = list(string)
    azure_ad_admin = optional(object({
      login_username                      = string
      object_id                           = string
      tenant_id                           = string
      azuread_authentication_only_enabled = bool
    }))
    databases = optional(map(object({
      name                      = string
      short_term_retention_days = optional(number, 7)
      long_term_retention_policy = optional(object({
        weekly_retention  = optional(string, "PT0S")
        monthly_retention = optional(string, "PT0S")
        yearly_retention  = optional(string, "PT0S")
        week_of_year      = optional(number, 0)
      }), null)
    })), {})

    # Add private endpoint configuration as an optional attribute
    private_endpoint = optional(object({
      name                            = optional(string)
      subnet_id                       = string
      is_manual_connection            = optional(bool, false)
      private_service_connection_name = optional(string)
      private_dns_zone_ids            = optional(list(string), [])
      subresource_names               = optional(list(string), ["managedInstance"])
      custom_network_interface_name   = optional(string)
      ip_configuration = optional(list(object({
        name               = string
        private_ip_address = string
        subresource_name   = string
        member_name        = optional(string)
      })), [])
      tags = optional(map(string), {})
    }))
  }))
}

