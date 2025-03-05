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
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | Name of the Azure Automation Account to be created or used | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment name (e.g., dev, test, prod) for resource naming and tagging | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the Automation Runbook resources will be deployed | `string` | `"uksouth"` | no |
| <a name="input_product"></a> [product](#input\_product) | Product or project name for resource naming and tagging | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group where the Automation Account will be deployed | `string` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | List of schedule configurations for starting or stopping VMs. Each schedule defines when and how VMs should be started or stopped. | <pre>list(object({<br/>    name       = string<br/>    frequency  = string<br/>    interval   = number<br/>    run_time   = string<br/>    start_vm   = bool<br/>    week_days  = optional(list(string))<br/>    month_days = optional(list(number))<br/>    monthly_occurrence = optional(object({<br/>      day        = optional(string)<br/>      occurrence = optional(number)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | Name of the Azure subscription containing the target VMs | `string` | `"Subscription name to target"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to be applied to all resources created by this module | `map(string)` | n/a | yes |
| <a name="input_target_resource_group_name"></a> [target\_resource\_group\_name](#input\_target\_resource\_group\_name) | Optional target resource group name containing VMs to be managed (overrides the default resource group) | `string` | `null` | no |
| <a name="input_target_subscription_name"></a> [target\_subscription\_name](#input\_target\_subscription\_name) | Optional override for the subscription name containing the target VMs | `string` | `null` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | Timezone to use for scheduling runbooks (IANA time zone format) | `string` | `"Europe/London"` | no |
| <a name="input_vm_names"></a> [vm\_names](#input\_vm\_names) | List of virtual machine names to be targeted by the start/stop runbook | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->