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
| [azurerm_mssql_managed_database.databases](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_managed_database) | resource |
| [azurerm_mssql_managed_instance.managed_instances](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_managed_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_managed_instances"></a> [managed\_instances](#input\_managed\_instances) | n/a | <pre>map(object({<br/>    license_type                  = string<br/>    sku_name                     = string<br/>    storage_size_in_gb           = number<br/>    vcores                       = number<br/>    subnet_id                    = string<br/>    administrator_login          = string<br/>    administrator_login_password = string<br/>    databases                    = map(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_managed_database_ids"></a> [managed\_database\_ids](#output\_managed\_database\_ids) | Map of Managed Database IDs |
| <a name="output_managed_database_names"></a> [managed\_database\_names](#output\_managed\_database\_names) | Map of Managed Database names |
| <a name="output_managed_instance_connection_strings"></a> [managed\_instance\_connection\_strings](#output\_managed\_instance\_connection\_strings) | Map of Managed Instance connection strings |
| <a name="output_managed_instance_fqdns"></a> [managed\_instance\_fqdns](#output\_managed\_instance\_fqdns) | Map of Managed Instance fully qualified domain names |
| <a name="output_managed_instance_names"></a> [managed\_instance\_names](#output\_managed\_instance\_names) | Map of Managed Instance names |
<!-- END_TF_DOCS -->