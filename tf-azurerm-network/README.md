<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_subnet.subnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The Azure region where all resources will be created.<br/>  Use the official Azure region names such as:<br/>  - "eastus"<br/>  - "westeurope"<br/>  - "southcentralus"<br/><br/>  Leave empty to use the default region configured in your Azure provider. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where all resources will be created.<br/>  Resource group names:<br/>  - Must be unique within your Azure subscription<br/>  - Can be 1-90 characters long<br/>  - Can only include alphanumeric, underscore, parentheses, hyphen, period<br/>  - Cannot end in a period<br/><br/>  Leave empty to use an existing resource group specified in your Azure provider. | `string` | `""` | no |
| <a name="input_virtual_networks"></a> [virtual\_networks](#input\_virtual\_networks) | A map of virtual networks configurations where each key is a unique identifier and the value contains the network's specifications.<br/>  Each virtual network can have multiple subnets with various configurations including private endpoints, service endpoints, and delegations.<br/><br/>  Example usage:<br/>  virtual\_networks = {<br/>    "primary\_vnet" = {<br/>      name = "primary-vnet"<br/>      address\_space = ["10.0.0.0/16"]<br/>      subnets = {<br/>        "subnet1" = {<br/>          name = "app-subnet"<br/>          address\_prefixes = ["10.0.1.0/24"]<br/>        }<br/>      }<br/>    }<br/>  } | <pre>map(object({<br/>    name          = string       # The name of the virtual network<br/>    address_space = list(string) # List of address spaces in CIDR notation (e.g., ["10.0.0.0/16"])<br/>    tags          = optional(map(string))<br/>    subnets = map(object({<br/>      name             = string       # Name of the subnets created by this module<br/>      address_prefixes = list(string) # List of address ranges for the subnets in CIDR notation<br/><br/>      # Optional subnet configurations with default values<br/>      private_endpoint_network_policies             = optional(string, "Enabled") # Controls private endpoint network policies<br/>      private_link_service_network_policies_enabled = optional(bool, true)        # Enables/disables private link service network policies<br/>      default_outbound_access_enabled               = optional(bool, false)       # Controls default outbound access for the subnet<br/>      service_endpoints                             = optional(list(string), [])  # List of Azure service endpoints to enable<br/><br/>      # Optional subnet delegation configuration<br/>      delegation = optional(object({<br/>        name = string # Name of the delegation<br/>        service_delegation = object({<br/>          name    = string       # Azure service to delegate to (e.g., "Microsoft.Web/serverFarms")<br/>          actions = list(string) # Actions permitted for the delegated service<br/>        })<br/>      }), null)<br/>    }))<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Details of all subnets |
| <a name="output_virtual_networks"></a> [virtual\_networks](#output\_virtual\_networks) | Details of all virtual networks |
<!-- END_TF_DOCS -->