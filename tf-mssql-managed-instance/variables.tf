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
  type = map(object({
    license_type       = string
    sku_name           = string
    storage_size_in_gb = number
    vcores             = number
    subnet_id          = string

    # Local - SA - authentication
    administrator_login          = string
    administrator_login_password = string

    # Managed Identity configuration (AzureADmin pre-requisite)
    identity_type = optional(string, "SystemAssigned")
    identity_ids  = optional(list(string))

    # (Optional) Azure AD Admin configuration
    azure_ad_admin = optional(object({
      login_username                      = string
      object_id                           = string
      principal_type                      = string
      azuread_authentication_only_enabled = optional(bool, false)
      tenant_id                           = optional(string, null)
    }), null)

    databases = map(string)

  }))
}
