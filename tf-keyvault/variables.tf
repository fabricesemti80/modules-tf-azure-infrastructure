#------------------------------------------------------------------------------
# Core Configuration
#------------------------------------------------------------------------------

variable "key_vault_name" {
  type        = string
  description = <<EOT
  Name of the Azure Key Vault. Must be:
  - Globally unique across all of Azure
  - 3-24 characters long
  - Alphanumeric and hyphens only
  - Start with a letter
  - End with a letter or number
  EOT
}

variable "resource_group_name" {
  type        = string
  description = <<EOT
  Name of the resource group where the Key Vault will be deployed.
  The resource group must exist before deploying the Key Vault.
  EOT
}

variable "azure_region" {
  type        = string
  description = <<EOT
  Azure region where the Key Vault will be created.
  Use the official Azure region names such as:
  - "eastus"
  - "westeurope"
  - "southcentralus"
  EOT
}

#------------------------------------------------------------------------------
# Security Configuration
#------------------------------------------------------------------------------

variable "key_vault_sku" {
  type        = string
  default     = "standard"
  description = <<EOT
  SKU of the Key Vault. Options:
  - "standard": Suitable for most scenarios
  - "premium": Required for hardware security module (HSM) backing
  
  Choose premium if you need HSM-backed keys or higher performance.
  EOT
  validation {
    condition     = contains(["standard", "premium"], var.key_vault_sku)
    error_message = "Key Vault SKU must be either 'standard' or 'premium'."
  }
}

variable "enable_purge_protection" {
  type        = bool
  default     = true
  description = <<EOT
  Enable purge protection for the Key Vault.
  WARNING: Once enabled, this setting cannot be disabled.
  Recommended to set to true for production environments.
  EOT
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = true
  description = <<EOT
  Enable RBAC authorization for the Key Vault.
  - true: Use Azure RBAC for access control (recommended)
  - false: Use Key Vault access policies
  
  RBAC provides more granular control and better audit capabilities.
  EOT
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 90
  description = <<EOT
  Number of days to retain deleted vaults and vault objects.
  - Minimum: 7 days
  - Maximum: 90 days
  
  Recommended to use 90 days for production environments.
  Note: This setting cannot be changed after creation.
  EOT
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90 days."
  }
}

#------------------------------------------------------------------------------
# Network Security Configuration
#------------------------------------------------------------------------------

variable "network_default_action" {
  type        = string
  default     = "Deny"
  description = <<EOT
  Default network action for Key Vault access:
  - "Deny": Block all traffic except explicitly allowed (recommended)
  - "Allow": Allow all traffic except explicitly denied
  
  Best practice is to use "Deny" and explicitly allow needed access.
  EOT
  validation {
    condition     = contains(["Deny", "Allow"], var.network_default_action)
    error_message = "Network default action must be 'Deny' or 'Allow'."
  }
}

variable "network_bypass" {
  type        = string
  default     = "AzureServices"
  description = <<EOT
  Network bypass settings for Key Vault:
  - "AzureServices": Allow trusted Azure services to access Key Vault
  - "None": No bypass allowed
  
  Usually kept as "AzureServices" to allow Azure backup and other services.
  EOT
  validation {
    condition     = contains(["AzureServices", "None"], var.network_bypass)
    error_message = "Network bypass must be either 'AzureServices' or 'None'."
  }
}

variable "allowed_ip_addresses" {
  type        = list(string)
  default     = []
  description = <<EOT
  List of IP addresses or CIDR ranges allowed to access the Key Vault.
  Example: ["123.123.123.123/32", "10.0.0.0/24"]
  
  Leave empty to deny all IP-based access.
  EOT
}

variable "allowed_subnet_ids" {
  type        = list(string)
  default     = []
  description = <<EOT
  List of subnet IDs allowed to access the Key Vault.
  Format: Full resource IDs of subnets
  Example: ["/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnet}/subnets/{subnet}"]
  EOT
}

#------------------------------------------------------------------------------
# Private Endpoint Configuration
#------------------------------------------------------------------------------

variable "private_endpoint" {
  type = object({
    name                    = string
    enabled                 = bool
    subnet_id               = string
    service_connection_name = string
  })
  default = {
    name                    = "pep1"
    enabled                 = false
    subnet_id               = null
    service_connection_name = "sc1"
  }
  description = <<EOT
  Configuration for Key Vault Private Link endpoint:
  - enabled: Whether to create a private endpoint
  - subnet_id: The subnet ID where the private endpoint should be created
  
  Required when network_default_action is "Deny" and private access is needed.
  EOT
}

variable "manual_private_connection" {
  type        = bool
  default     = false
  description = <<EOT
  Controls if private endpoint connections require manual approval.
  - true: Connections must be manually approved
  - false: Connections are automatically approved
  EOT
}

variable "private_subresources" {
  type        = list(string)
  default     = ["vault"]
  description = <<EOT
  List of Key Vault sub-resources to expose through the private endpoint.
  Currently, only "vault" is supported for Key Vault.
  EOT
}

#------------------------------------------------------------------------------
# Resource Tagging
#------------------------------------------------------------------------------

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<EOT
  Map of tags to apply to the Key Vault and related resources.
  Example:
  {
    Environment = "Production"
    Owner       = "Security Team"
    CostCenter  = "12345"
  }
  EOT
}
