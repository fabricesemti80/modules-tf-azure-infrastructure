variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "managed_instances" {
  type = map(object({
    license_type                 = string
    sku_name                     = string
    storage_size_in_gb           = number
    vcores                       = number
    subnet_id                    = string
    administrator_login          = string
    administrator_login_password = string
    databases                    = map(string)
    azure_ad_admin = optional(object({
      login_username                      = string
      object_id                           = string
      principal_type                      = string
      azuread_authentication_only_enabled = optional(bool, false)
      tenant_id                           = optional(string, null)
    }), null)
  }))
}
