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
| [azurerm_automation_job_schedule.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | resource |
| [azurerm_automation_runbook.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_schedule.vm-start-stop](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | Name of the Azure Automation Account to be created or used for the start/stop runbooks | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment identifier used for resource naming and tagging (e.g., dev, test, prod, uat) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the Automation Runbook resources will be deployed (e.g., uksouth, ukwest, eastus) | `string` | `"uksouth"` | no |
| <a name="input_product"></a> [product](#input\_product) | Product or project identifier used for resource naming and tagging conventions | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the Automation Account and related resources will be deployed | `string` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | Configuration for VM start/stop schedules. Each schedule defines when and how VMs should be managed including frequency (OneTime, Day, Hour, Week, Month), time of execution, and whether to start or stop VMs. | <pre>list(object({<br/>    name       = string<br/>    frequency  = string<br/>    interval   = number<br/>    run_time   = string<br/>    start_vm   = bool<br/>    week_days  = optional(list(string))<br/>    month_days = optional(list(number))<br/>    monthly_occurrence = optional(object({<br/>      day        = optional(string)<br/>      occurrence = optional(number)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | Default Azure subscription name containing the target VMs for the automation runbook | `string` | `"Subscription name to target"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be applied to all resources created by this module for resource management and organization | `map(string)` | n/a | yes |
| <a name="input_target_resource_group_name"></a> [target\_resource\_group\_name](#input\_target\_resource\_group\_name) | Optional target resource group name containing VMs to be managed. If provided, overrides the default resource group specified in resource\_group\_name | `string` | `null` | no |
| <a name="input_target_subscription_name"></a> [target\_subscription\_name](#input\_target\_subscription\_name) | Optional override for the subscription name containing the target VMs. If provided, this will be used instead of subscription\_name | `string` | `null` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | IANA time zone format (e.g., 'Europe/London', 'America/New\_York') used for scheduling runbook executions | `string` | `"Europe/London"` | no |
| <a name="input_vm_names"></a> [vm\_names](#input\_vm\_names) | List of virtual machine names that will be managed by the start/stop runbook automation | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->