<<<<<<< HEAD
# Automation Runbook for Application secret recycling

This module is to setup a Azure Automation Runbook to start or stop VMs within an existing AUtomation Account.

Runbooks will be scheduled to begin the day after the pipeline is run. 

## Example

Below is the standard example setup

```terraform
# =================================================================
# ==========    vm shutdown/start runbook module    ===============
# =================================================================
#  vm shutdown/start runbook module
module "vm_automation" {
  source = "git::https://github.com/fabricesemti80/module-tf-automation-runbook-start-stop-vm"

  product                 = "xyz"
  env                     = "sbox"
  location                = "uksouth"
  automation_account_name = "xyz-sbox-aa"
  subscription_name       = "xyz-sbox-sub"
  schedules       = [
                      {
                        name        = "vm-on"
                        frequency   = "Day"
                        interval    = 1
                        run_time    = "06:00:00"
                        start_vm    = true
                      },
                      {
                        name        = "vm-off"
                        frequency   = "Day"
                        interval    = 1
                        run_time    = formatdate("HH:mm:ss", timestamp())
                        start_vm    = false
                      }
                     ]
  resource_group_name     = "xyz-sbox-rg"
  vm_names                = ["xyz-sbox-vm1", "xyz-sbox-vm2"]
  tags                    = var.common_tags
}


```

Below is an example of a mon-friday schedule

```terraform
# =================================================================
# ==========    vm shutdown/start runbook module    ===============
# =================================================================
#  vm shutdown/start runbook module
module "vm_automation" {
  source = "git::https://github.com/fabricesemti80/module-tf-automation-runbook-start-stop-vm"

  product                 = "xyz"
  env                     = "sbox"
  location                = "uksouth"
  automation_account_name = "xyz-sbox-aa"
  subscription_name       = "xyz-sbox-sub"
  schedules       = [
                      {
                        name        = "vm-on"
                        frequency   = "Week"
                        interval    = 1
                        run_time    = "06:00:00"
                        start_vm    = true
                        week_days   = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
                      },
                      {
                        name        = "vm-off"
                        frequency   = "Week"
                        interval    = 1
                        run_time    = formatdate("HH:mm:ss", timestamp())
                        start_vm    = false
                        week_days   = ["Monday","Tuesday","Wednesday","Thursday","Friday"]
                      }
                     ]
  resource_group_name     = "xyz-sbox-rg"
  vm_names                = ["xyz-sbox-vm1", "xyz-sbox-vm2"]
  tags                    = var.common_tags
}


```

## Requirements   

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
=======
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
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | automation account name | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of Runbook | `string` | `"uksouth"` | no |
| <a name="input_product"></a> [product](#input\_product) | n/a | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | # Azure Automation | <pre>list(object({<br/>    name       = string<br/>    frequency  = string<br/>    interval   = number<br/>    run_time   = string<br/>    start_vm   = bool<br/>    week_days  = optional(list(string))<br/>    month_days = optional(list(number))<br/>    monthly_occurrence = optional(object({<br/>      day        = optional(string)<br/>      occurrence = optional(number)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | n/a | `string` | `"Subscription name to target"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Runbook Tags | `map(string)` | n/a | yes |
| <a name="input_target_resource_group_name"></a> [target\_resource\_group\_name](#input\_target\_resource\_group\_name) | Optional target resource group name to override the default resource group name. | `string` | `null` | no |
| <a name="input_target_subscription_name"></a> [target\_subscription\_name](#input\_target\_subscription\_name) | Optional target subscription name to override the default subscription name. | `string` | `null` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | n/a | `string` | `"Europe/London"` | no |
| <a name="input_vm_names"></a> [vm\_names](#input\_vm\_names) | n/a | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
>>>>>>> 24fbaad12b58427ceb25c45beea51d908f34fe5c
