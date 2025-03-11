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
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_private_endpoint.kv_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_ip_addresses"></a> [allowed\_ip\_addresses](#input\_allowed\_ip\_addresses) | List of IP addresses or CIDR ranges allowed to access the Key Vault.<br/>  Example: ["123.123.123.123/32", "10.0.0.0/24"]<br/><br/>  Leave empty to deny all IP-based access. | `list(string)` | `[]` | no |
| <a name="input_allowed_subnet_ids"></a> [allowed\_subnet\_ids](#input\_allowed\_subnet\_ids) | List of subnet IDs allowed to access the Key Vault.<br/>  Format: Full resource IDs of subnets<br/>  Example: ["/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnet}/subnets/{subnet}"] | `list(string)` | `[]` | no |
| <a name="input_azure_region"></a> [azure\_region](#input\_azure\_region) | Azure region where the Key Vault will be created.<br/>  Use the official Azure region names such as:<br/>  - "eastus"<br/>  - "westeurope"<br/>  - "southcentralus" | `string` | n/a | yes |
| <a name="input_enable_purge_protection"></a> [enable\_purge\_protection](#input\_enable\_purge\_protection) | Enable purge protection for the Key Vault.<br/>  WARNING: Once enabled, this setting cannot be disabled.<br/>  Recommended to set to true for production environments. | `bool` | `true` | no |
| <a name="input_enable_rbac_authorization"></a> [enable\_rbac\_authorization](#input\_enable\_rbac\_authorization) | Enable RBAC authorization for the Key Vault.<br/>  - true: Use Azure RBAC for access control (recommended)<br/>  - false: Use Key Vault access policies<br/><br/>  RBAC provides more granular control and better audit capabilities. | `bool` | `true` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of the Azure Key Vault. Must be:<br/>  - Globally unique across all of Azure<br/>  - 3-24 characters long<br/>  - Alphanumeric and hyphens only<br/>  - Start with a letter<br/>  - End with a letter or number | `string` | n/a | yes |
| <a name="input_key_vault_sku"></a> [key\_vault\_sku](#input\_key\_vault\_sku) | SKU of the Key Vault. Options:<br/>  - "standard": Suitable for most scenarios<br/>  - "premium": Required for hardware security module (HSM) backing<br/><br/>  Choose premium if you need HSM-backed keys or higher performance. | `string` | `"standard"` | no |
| <a name="input_manual_private_connection"></a> [manual\_private\_connection](#input\_manual\_private\_connection) | Controls if private endpoint connections require manual approval.<br/>  - true: Connections must be manually approved<br/>  - false: Connections are automatically approved | `bool` | `false` | no |
| <a name="input_network_bypass"></a> [network\_bypass](#input\_network\_bypass) | Network bypass settings for Key Vault:<br/>  - "AzureServices": Allow trusted Azure services to access Key Vault<br/>  - "None": No bypass allowed<br/><br/>  Usually kept as "AzureServices" to allow Azure backup and other services. | `string` | `"AzureServices"` | no |
| <a name="input_network_default_action"></a> [network\_default\_action](#input\_network\_default\_action) | Default network action for Key Vault access:<br/>  - "Deny": Block all traffic except explicitly allowed (recommended)<br/>  - "Allow": Allow all traffic except explicitly denied<br/><br/>  Best practice is to use "Deny" and explicitly allow needed access. | `string` | `"Deny"` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Configuration for Key Vault Private Link endpoint:<br/>  - enabled: Whether to create a private endpoint<br/>  - subnet\_id: The subnet ID where the private endpoint should be created<br/><br/>  Required when network\_default\_action is "Deny" and private access is needed. | <pre>object({<br/>    name                    = string<br/>    enabled                 = bool<br/>    subnet_id               = string<br/>    service_connection_name = string<br/>  })</pre> | <pre>{<br/>  "enabled": false,<br/>  "name": "pep1",<br/>  "service_connection_name": "sc1",<br/>  "subnet_id": null<br/>}</pre> | no |
| <a name="input_private_subresources"></a> [private\_subresources](#input\_private\_subresources) | List of Key Vault sub-resources to expose through the private endpoint.<br/>  Currently, only "vault" is supported for Key Vault. | `list(string)` | <pre>[<br/>  "vault"<br/>]</pre> | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the Key Vault will be deployed.<br/>  The resource group must exist before deploying the Key Vault. | `string` | n/a | yes |
| <a name="input_soft_delete_retention_days"></a> [soft\_delete\_retention\_days](#input\_soft\_delete\_retention\_days) | Number of days to retain deleted vaults and vault objects.<br/>  - Minimum: 7 days<br/>  - Maximum: 90 days<br/><br/>  Recommended to use 90 days for production environments.<br/>  Note: This setting cannot be changed after creation. | `number` | `90` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to the Key Vault and related resources.<br/>  Example:<br/>  {<br/>    Environment = "Production"<br/>    Owner       = "Security Team"<br/>    CostCenter  = "12345"<br/>  } | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kv_enable_rbac_authorization"></a> [kv\_enable\_rbac\_authorization](#output\_kv\_enable\_rbac\_authorization) | Whether RBAC authorization is enabled on the Key Vault. |
| <a name="output_kv_id"></a> [kv\_id](#output\_kv\_id) | The ID of the created Key Vault. |
| <a name="output_kv_location"></a> [kv\_location](#output\_kv\_location) | The location where the Key Vault is created. |
| <a name="output_kv_name"></a> [kv\_name](#output\_kv\_name) | The name of the Key Vault. |
| <a name="output_kv_resource_group_name"></a> [kv\_resource\_group\_name](#output\_kv\_resource\_group\_name) | The resource group in which the Key Vault is located. |
| <a name="output_kv_sku"></a> [kv\_sku](#output\_kv\_sku) | The SKU of the Key Vault. |
| <a name="output_kv_soft_delete_retention_days"></a> [kv\_soft\_delete\_retention\_days](#output\_kv\_soft\_delete\_retention\_days) | The number of days that the Key Vault soft delete retention is configured for. |
| <a name="output_kv_tenant_id"></a> [kv\_tenant\_id](#output\_kv\_tenant\_id) | The tenant ID used by the Key Vault. |
| <a name="output_private_endpoint_id"></a> [private\_endpoint\_id](#output\_private\_endpoint\_id) | The ID of the Private Endpoint, if created |
| <a name="output_private_endpoint_ip_addresses"></a> [private\_endpoint\_ip\_addresses](#output\_private\_endpoint\_ip\_addresses) | The IP addresses of the Private Endpoint, if created |
<!-- END_TF_DOCS -->