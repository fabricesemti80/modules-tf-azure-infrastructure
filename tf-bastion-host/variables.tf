# Bastion Host Configuration Variables

# ## ? Core Identification Variables

variable "bastion_host_name" {
  type        = string
  description = "Unique name for the Azure Bastion host, enabling secure RDP/SSH access to virtual machines."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where Bastion resources will be deployed."
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "The resource group name must be specified."
  }
}

variable "location" {
  type        = string
  description = "Azure region where the Bastion host and associated resources will be deployed."
  validation {
    condition     = length(var.location) > 0
    error_message = "The deployment location must be specified."
  }
}

## ? Network Configuration Variables
variable "bastion_subnet_id" {
  type        = string
  description = "The fully qualified resource ID of the subnet where the Bastion host will be deployed."
  validation {
    condition     = length(var.bastion_subnet_id) > 0
    error_message = "A valid Bastion subnet ID must be provided."
  }
}

variable "bastion_subnet_prefix" {
  type        = string
  description = "The network prefix (CIDR) of the Bastion subnet for security rule configuration."
  validation {
    condition     = length(var.bastion_subnet_prefix) > 0
    error_message = "A valid Bastion subnet prefix must be specified."
  }
}

## ? Bastion Host Feature Configuration
variable "bastion_sku" {
  type        = string
  default     = "Standard"
  description = "Pricing tier for the Bastion host. Defaults to 'Standard'."
  validation {
    condition     = contains(["Standard", "Basic"], var.bastion_sku)
    error_message = "Bastion SKU must be either 'Standard' or 'Basic'."
  }
}

variable "bastion_scale" {
  type        = number
  description = "Number of scale units for the Bastion host. Impacts concurrent session capacity."
  validation {
    condition     = var.bastion_scale > 0 && var.bastion_scale <= 50
    error_message = "Bastion scale units must be between 1 and 50."
  }
}

## ? Bastion Session Feature Toggles
variable "bastion_features" {
  type = object({
    copy_paste_enabled     = bool
    file_copy_enabled      = bool
    shareable_link_enabled = bool
    tunneling_enabled      = bool
  })
  default = {
    copy_paste_enabled     = true
    file_copy_enabled      = true
    shareable_link_enabled = true
    tunneling_enabled      = true
  }
  description = "Configuration object for Bastion host session features."
}

## ? Tagging Variables
variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources created by this module."
  default     = {}
}
