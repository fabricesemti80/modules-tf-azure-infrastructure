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
| [azurerm_availability_set.avset](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/availability_set) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_sets"></a> [availability\_sets](#input\_availability\_sets) | Map of availability sets to create | <pre>map(object({<br/>    name                         = string<br/>    platform_fault_domain_count  = optional(number, 2)<br/>    platform_update_domain_count = optional(number, 5)<br/>    managed                      = optional(bool, true)<br/>    tags                         = optional(map(string), {})<br/>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region where resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Base tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_set_ids"></a> [availability\_set\_ids](#output\_availability\_set\_ids) | Map of availability set names to their IDs |
| <a name="output_availability_sets"></a> [availability\_sets](#output\_availability\_sets) | Map of all availability set resources |
<!-- END_TF_DOCS -->