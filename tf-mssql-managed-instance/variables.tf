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
      # You can keep using a simple string if you don't need backup configs
      # or use an object for more advanced configurations
      name                      = string
      short_term_retention_days = optional(number, 7) # by default we keep 7 days
      long_term_retention_policy = optional(object({
        weekly_retention  = optional(string, "PT0S")
        monthly_retention = optional(string, "PT0S")
        yearly_retention  = optional(string, "PT0S")
        week_of_year      = optional(number, 0)
      }), null)
    })), {}) # Default to empty map if not provided
  }))
}
