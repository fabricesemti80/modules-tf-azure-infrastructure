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
    license_type                  = string
    sku_name                     = string
    storage_size_in_gb           = number
    vcores                       = number
    subnet_id                    = string
    administrator_login          = string
    administrator_login_password = string
    databases                    = map(string)
  }))
}
