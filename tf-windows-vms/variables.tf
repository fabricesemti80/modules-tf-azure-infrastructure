##? Configuration for Windows Virtual Machines

# Define the configuration for Windows Virtual Machines including VM name, size, and subnet ID.
variable "windows_vms_config" {
  description = <<EOT
  A map of Windows Virtual Machines configurations where each key is a unique identifier and the value contains the VM's specifications.
  Each VM configuration includes details such as the VM name, size, subnet ID, source image reference, optional data disks configuration, and optional daily shutdown time in UTC 24hr format (e.g., '2000' for 8:00 PM).

  Example usage:
  windows_vms_config = {
    "vm1" = {
      name           = "example-vm1"
      login_username = "azureuser"
      login_password = "Password123!"
      source_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2022-Datacenter"
        version   = "latest"
      }
      data_disks = []
    }
  }
  EOT

  type = map(object({
    name           = string                           # The name of the virtual machine
    login_username = optional(string, "azureuser")    # The username for logging into the VM
    login_password = string                           # The password for logging into the VM
    size           = optional(string, "Standard_B2s") # The size of the virtual machine
    subnet_id      = optional(string, "")             # The subnet ID where the VM will be deployed
    source_image_reference = object({
      publisher = string # The publisher of the source image
      offer     = string # The offer of the source image
      sku       = string # The SKU of the source image
      version   = string # The version of the source image
    })
    static_ip                    = optional(string)                        # For static IP allocation (not used if private_ip_allocation_method is set to Dynamic)
    patch_assessment_mode        = optional(string, "AutomaticByPlatform") # The patch assessment mode for the VM
    availability_set_id          = optional(string, null)                  # The availability set ID for the VM
    os_disk_storage_account_type = optional(string, "Standard_LRS")        # The storage account type for the OS disk
    os_disk_caching              = optional(string, "ReadWrite")           # The caching mode for the OS disk
    daily_shutdown_time          = optional(string)                        # The daily shutdown time in UTC 24hr format (e.g., '2000' for 8:00 PM). Set to null to disable auto-shutdown
    data_disks = optional(list(object({
      name                 = string                           # The name of the data disk
      size_gb              = number                           # The size of the data disk in GB
      storage_account_type = optional(string, "Standard_LRS") # The storage account type for the data disk
      caching              = optional(string, "ReadWrite")    # The caching mode for the data disk
      lun                  = number                           # The logical unit number for the data disk
    })), [])
  }))
}

##? General Azure Configuration

# Resource Group Name for placing all compute resources like VMs
variable "resource_group_name" {
  description = <<EOT
  The name of the resource group where compute resources (such as virtual machines) will be placed.
  Resource group names:
  - Must be unique within your Azure subscription
  - Can be 1-90 characters long
  - Can only include alphanumeric, underscore, parentheses, hyphen, period
  - Cannot end in a period
  EOT
  type        = string
}

# Azure Region where resources will be deployed (e.g., 'East US', 'West Europe')
variable "azure_region" {
  description = <<EOT
  The Azure region where the resources will be deployed.
  Use the official Azure region names such as:
  - "eastus"
  - "westeurope"
  - "southcentralus"
  EOT
  type        = string
}

# # Prefix used for creating unique names for Azure resources (e.g., 'bcmg-az-vm1')
# variable "resource_name_prefix" {
#   description = <<EOT
#   A prefix string that will be added to the names of Azure resources to help create unique names.
#   Example: 'bcmg-az-vm1'
#   EOT
#   type        = string
#   default     = "bcmg-az"
# }

# Tags that will be applied to the resources for better management
variable "tags" {
  description = <<EOT
  A map of tags to be applied to resources for easier management and organization.
  Tags are key-value pairs that help with:
  - Resource organization
  - Cost allocation
  - Automation
  - Access control

  Example:
  resource_tags = {
    Environment = "Production"
    Department  = "IT"
    Project     = "Infrastructure"
    Owner       = "DevOps Team"
  }
  EOT
  type        = map(string)
}

##? Administrative Configuration

# Private IP address allocation method for the network interfaces (can be 'Static' or 'Dynamic')
variable "private_ip_allocation_method" {
  description = <<EOT
  The method used to allocate private IP addresses for network interfaces.
  Can be 'Static' (manual IP) or 'Dynamic' (automatic IP).
  EOT
  type        = string
  default     = "Dynamic"
}

##? Security & Secret Management

# ID for the Azure Key Vault used to store secrets such as RDP passwords
variable "key_vault_id" {
  description = <<EOT
  The ID for the Azure Key Vault used to store secrets such as RDP passwords.
  EOT
  type        = string
  default     = ""
}

# The time of day when the virtual machines should be shut down daily in UTC 24hr format (e.g., '2000' for 8:00 PM). Set to null to disable auto-shutdown.
variable "vm_daily_shutdown_time" {
  description = <<EOT
  The time of day when the virtual machines should be shut down daily in UTC 24hr format (e.g., '2000' for 8:00 PM).
  Set to null to disable auto-shutdown.
  EOT
  type        = string
  default     = null
}

# Specifies the type of on-premise license (BYOL) to be used
# Ensure you have eligible Windows Server licenses with Software Assurance before enabling
# The license_type can be either "Windows_Server" or "None"
# This change won't require a VM restart
# Remember to validate your organization's licensing compliance before enabling
variable "windows_license_type" {
  description = <<EOT
  Specifies the type of on-premise license (BYOL) to be used.
  Ensure you have eligible Windows Server licenses with Software Assurance before enabling.
  The license_type can be either "Windows_Server" or "None".
  This change won't require a VM restart.
  Remember to validate your organization's licensing compliance before enabling.
  EOT
  type        = string
  default     = "None"
}

# System Managed Identity configuration for Windows VMs
variable "enable_system_managed_identity" {
  description = <<EOT
  Determines whether to enable system-assigned managed identity for the Windows virtual machines.
  When enabled, the VM will have a system-assigned identity in Azure Active Directory.
  This identity can be used to authenticate to Azure services without storing credentials in code.
  EOT
  type        = bool
  default     = true
}
