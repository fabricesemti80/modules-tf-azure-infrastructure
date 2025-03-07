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
| [azurerm_bastion_host.bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host) | resource |
| [azurerm_public_ip.bastion_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_features"></a> [bastion\_features](#input\_bastion\_features) | Configuration object for Bastion host session features. | <pre>object({<br/>    copy_paste_enabled     = bool<br/>    file_copy_enabled      = bool<br/>    shareable_link_enabled = bool<br/>    tunneling_enabled      = bool<br/>  })</pre> | <pre>{<br/>  "copy_paste_enabled": true,<br/>  "file_copy_enabled": true,<br/>  "shareable_link_enabled": true,<br/>  "tunneling_enabled": true<br/>}</pre> | no |
| <a name="input_bastion_host_name"></a> [bastion\_host\_name](#input\_bastion\_host\_name) | Unique name for the Azure Bastion host, enabling secure RDP/SSH access to virtual machines. | `string` | n/a | yes |
| <a name="input_bastion_scale"></a> [bastion\_scale](#input\_bastion\_scale) | Number of scale units for the Bastion host. Impacts concurrent session capacity. | `number` | n/a | yes |
| <a name="input_bastion_sku"></a> [bastion\_sku](#input\_bastion\_sku) | Pricing tier for the Bastion host. Defaults to 'Standard'. | `string` | `"Standard"` | no |
| <a name="input_bastion_subnet_id"></a> [bastion\_subnet\_id](#input\_bastion\_subnet\_id) | The fully qualified resource ID of the subnet where the Bastion host will be deployed. | `string` | n/a | yes |
| <a name="input_bastion_subnet_prefix"></a> [bastion\_subnet\_prefix](#input\_bastion\_subnet\_prefix) | The network prefix (CIDR) of the Bastion subnet for security rule configuration. | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the Bastion host and associated resources will be deployed. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where Bastion resources will be deployed. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to apply to all resources created by this module. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_configuration"></a> [bastion\_configuration](#output\_bastion\_configuration) | Consolidated Bastion host configuration details |
| <a name="output_bastion_host_id"></a> [bastion\_host\_id](#output\_bastion\_host\_id) | The resource ID of the Azure Bastion host |
| <a name="output_bastion_host_name"></a> [bastion\_host\_name](#output\_bastion\_host\_name) | The name of the Azure Bastion host |
| <a name="output_bastion_public_ip_address"></a> [bastion\_public\_ip\_address](#output\_bastion\_public\_ip\_address) | The public IP address of the Bastion host |
| <a name="output_bastion_public_ip_id"></a> [bastion\_public\_ip\_id](#output\_bastion\_public\_ip\_id) | The resource ID of the Bastion host's public IP address |
| <a name="output_bastion_subnet_id"></a> [bastion\_subnet\_id](#output\_bastion\_subnet\_id) | The ID of the subnet where the Bastion host is deployed |
| <a name="output_module_metadata"></a> [module\_metadata](#output\_module\_metadata) | Metadata about the Bastion host module deployment |
<!-- END_TF_DOCS -->