variable "resource_group_name" {
  description = "The name of the resource group in which to create the SQL Managed Instance"
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the SQL Managed Instance"
  type        = string
}

variable "managed_instances" {
  description = "Map of SQL Managed Instances to create"
  type = map(object({
    license_type       = string
    sku_name           = string
    storage_size_in_gb = number
    vcores             = number
    subnet_id          = string

    administrator_login          = string
    administrator_login_password = string

    # Identity configuration
    identity_type = optional(string)
    identity_ids  = optional(list(string))

    # Azure AD Admin configuration
    azure_ad_admin = optional(object({
      login_username                      = string
      object_id                           = string
      principal_type                      = optional(string)
      azuread_authentication_only_enabled = optional(bool, false)
      tenant_id                           = optional(string)
    }))

    # Databases to create in this instance
    databases = optional(list(string), [])
  }))
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

