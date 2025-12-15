# Configuration for Virtual Networks and their associated subnets.
# This variable allows you to define multiple virtual networks, each with its own subnets.
variable "virtual_networks" {
  description = <<EOT
  A map of virtual networks configurations where each key is a unique identifier and the value contains the network's specifications.
  Each virtual network can have multiple subnets with various configurations including private endpoints, service endpoints, and delegations.
  
  Example usage:
  virtual_networks = {
    "primary_vnet" = {
      name = "primary-vnet"
      address_space = ["10.0.0.0/16"]
      subnets = {
        "subnet1" = {
          name = "app-subnet"
          address_prefixes = ["10.0.1.0/24"]
        }
      }
    }
  }
  EOT

  type = map(object({
    name          = string       # The name of the virtual network
    address_space = list(string) # List of address spaces in CIDR notation (e.g., ["10.0.0.0/16"])
    tags          = optional(map(string))
    subnets = map(object({
      name             = string       # Name of the subnets created by this module
      address_prefixes = list(string) # List of address ranges for the subnets in CIDR notation

      # Optional subnet configurations with default values
      private_endpoint_network_policies             = optional(string, "Enabled") # Controls private endpoint network policies
      private_link_service_network_policies_enabled = optional(bool, true)        # Enables/disables private link service network policies
      default_outbound_access_enabled               = optional(bool, false)       # Controls default outbound access for the subnet
      service_endpoints                             = optional(list(string), [])  # List of Azure service endpoints to enable

      # Optional subnet delegation configuration
      delegation = optional(object({
        name = string # Name of the delegation
        service_delegation = object({
          name    = string       # Azure service to delegate to (e.g., "Microsoft.Web/serverFarms")
          actions = list(string) # Actions permitted for the delegated service
        })
      }), null)
    }))
  }))
}

# Specifies the Azure region where all resources will be deployed.
# Use the official Azure region names (e.g., "eastus", "westeurope").
variable "location" {
  description = <<EOT
  The Azure region where all resources will be created.
  Use the official Azure region names such as:
  - "eastus"
  - "westeurope"
  - "southcentralus"
  
  Leave empty to use the default region configured in your Azure provider.
  EOT
  type        = string
  default     = ""
}

# Defines the resource group name where all resources will be created.
# Resource group names must be unique within your Azure subscription.
variable "resource_group_name" {
  description = <<EOT
  The name of the resource group where all resources will be created.
  Resource group names:
  - Must be unique within your Azure subscription
  - Can be 1-90 characters long
  - Can only include alphanumeric, underscore, parentheses, hyphen, period
  - Cannot end in a period
  
  Leave empty to use an existing resource group specified in your Azure provider.
  EOT
  type        = string
  default     = ""
}

# # Defines the tags to be applied to all resources created by this module.
# # Tags are key-value pairs that help organize and categorize Azure resources.
# variable "tags" {
#   description = <<EOT
#   A map of tags to be applied to all resources created by this module.
#   Tags are key-value pairs that help with:
#   - Resource organization
#   - Cost allocation
#   - Automation
#   - Access control

#   Example:
#   tags = {
#     Environment = "Production"
#     Department  = "IT"
#     Project     = "Infrastructure"
#     Owner       = "DevOps Team"
#   }
#   EOT
#   type        = map(string)
# }
