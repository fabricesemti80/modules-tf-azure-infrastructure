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
| [azurerm_consumption_budget_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group) | resource |
| [azurerm_consumption_budget_subscription.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_subscription) | resource |
| [azurerm_cost_anomaly_alert.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cost_anomaly_alert) | resource |
| [azurerm_cost_management_scheduled_action.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cost_management_scheduled_action) | resource |
| [azurerm_subscription_cost_management_view.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_cost_management_view) | resource |
| [azurerm_resource_group.default](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The application name (i.e. `apex`, `portal`) | `string` | `""` | no |
| <a name="input_azurerm_cost_anomaly_alert"></a> [azurerm\_cost\_anomaly\_alert](#input\_azurerm\_cost\_anomaly\_alert) | n/a | <pre>object({<br/>    name            = string<br/>    display_name    = string<br/>    email_subject   = string<br/>    email_addresses = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_cost_management_scheduled_action"></a> [cost\_management\_scheduled\_action](#input\_cost\_management\_scheduled\_action) | Map of Cost Management Scheduled Actions. | <pre>map(object({<br/>    name                 = string<br/>    display_name         = string<br/>    view_identifier      = string<br/>    email_address_sender = string<br/>    email_subject        = string<br/>    email_addresses      = list(string)<br/>    message              = optional(string)<br/>    frequency            = string<br/>    start_date           = string<br/>    end_date             = string<br/>    day_of_month         = optional(number)<br/>    days_of_week         = optional(list(string))<br/>    hour_of_day          = optional(number)<br/>    weeks_of_month       = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` | `string` | `"-"` | no |
| <a name="input_desc_prefix"></a> [desc\_prefix](#input\_desc\_prefix) | The prefix to add to any descriptions attached to resources | `string` | `"Grvc:"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The isolated environment the module is associated with (e.g. Shared Services `shared`, Application `app`) | `string` | `""` | no |
| <a name="input_environment_prefix"></a> [environment\_prefix](#input\_environment\_prefix) | Concatenation of `namespace` and `environment` | `string` | `""` | no |
| <a name="input_module_prefix"></a> [module\_prefix](#input\_module\_prefix) | Concatenation of `namespace`, `environment`, `stage` and `name` | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the module | `string` | `"conbudg"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization abbreviation, client name, etc. (e.g. Gravicore 'grv', HashiCorp 'hc') | `string` | `""` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | The repository where the code referencing the module is stored | `string` | `""` | no |
| <a name="input_resource_group_consumption"></a> [resource\_group\_consumption](#input\_resource\_group\_consumption) | Map of Resource Group Consumption Budgets. | <pre>map(object({<br/>    name                = string<br/>    resource_group_id   = optional(string)<br/>    resource_group_name = optional(string)<br/>    amount              = number<br/>    time_grain          = optional(string)<br/>    time_period = object({<br/>      start_date = string<br/>      end_date   = optional(string)<br/>    })<br/>    filter = optional(object({<br/>      dimension = optional(list(object({<br/>        name     = string<br/>        operator = optional(string, "In")<br/>        values   = list(string)<br/>      })))<br/>      tag = optional(list(object({<br/>        name     = string<br/>        operator = optional(string, "In")<br/>        values   = list(string)<br/>      })))<br/>    }))<br/>    notifications = list(object({<br/>      enabled        = optional(bool, true)<br/>      threshold      = number<br/>      operator       = string<br/>      threshold_type = optional(string, "Actual")<br/>      contact_emails = optional(list(string))<br/>      contact_groups = optional(list(string))<br/>      contact_roles  = optional(list(string))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the Azure resource group | `string` | `""` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | The development stage (i.e. `dev`, `stg`, `prd`) | `string` | `""` | no |
| <a name="input_stage_prefix"></a> [stage\_prefix](#input\_stage\_prefix) | Concatenation of `namespace`, `environment` and `stage` | `string` | `""` | no |
| <a name="input_subscription_consumption_budget"></a> [subscription\_consumption\_budget](#input\_subscription\_consumption\_budget) | Map of Consumption Budgets for Subscriptions. | <pre>map(object({<br/>    name            = string<br/>    subscription_id = optional(string)<br/>    amount          = number<br/>    time_grain      = optional(string, "Monthly")<br/>    time_period = object({<br/>      start_date = string<br/>      end_date   = optional(string)<br/>    })<br/>    filter = optional(object({<br/>      dimension = optional(list(object({<br/>        name     = string<br/>        operator = optional(string, "In")<br/>        values   = list(string)<br/>      })))<br/>      tag = optional(list(object({<br/>        name     = string<br/>        operator = optional(string, "In")<br/>        values   = list(string)<br/>      })))<br/>    }))<br/>    notifications = list(object({<br/>      enabled        = optional(bool, true)<br/>      threshold      = number<br/>      operator       = string<br/>      threshold_type = optional(string, "Actual")<br/>      contact_emails = optional(list(string))<br/>      contact_groups = optional(list(string))<br/>      contact_roles  = optional(list(string))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_subscription_cost_management_view"></a> [subscription\_cost\_management\_view](#input\_subscription\_cost\_management\_view) | Map of Subscription Cost Management Views. | <pre>map(object({<br/>    name            = string<br/>    display_name    = string<br/>    chart_type      = string<br/>    accumulated     = bool<br/>    subscription_id = optional(string)<br/>    report_type     = string<br/>    timeframe       = string<br/><br/>    dataset = optional(object({<br/>      granularity = string<br/>      aggregation = list(object({<br/>        name        = string<br/>        column_name = string<br/>      }))<br/>      grouping = optional(list(object({<br/>        name = string<br/>        type = string<br/>      })))<br/>      sorting = optional(list(object({<br/>        direction = string<br/>        name      = string<br/>      })))<br/>    }))<br/><br/>    kpi = optional(list(object({<br/>      type = string<br/>    })))<br/><br/>    pivot = optional(list(object({<br/>      name = string<br/>      type = string<br/>    })))<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional map of tags (e.g. business\_unit, cost\_center) | `map(string)` | `{}` | no |
| <a name="input_terraform_module"></a> [terraform\_module](#input\_terraform\_module) | The owner and name of the Terraform module | `string` | `"gravicore/terraform-gravicore-modules/azure/alert"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cost_anomaly_alert_id"></a> [cost\_anomaly\_alert\_id](#output\_cost\_anomaly\_alert\_id) | The ID of the Cost Anomaly Alert. |
| <a name="output_cost_management_scheduled_action_id"></a> [cost\_management\_scheduled\_action\_id](#output\_cost\_management\_scheduled\_action\_id) | The ID of the Cost Management Scheduled Action. |
| <a name="output_resource_group_consumption_budget_id"></a> [resource\_group\_consumption\_budget\_id](#output\_resource\_group\_consumption\_budget\_id) | The ID of the Resource Group Consumption Budgets. |
| <a name="output_subscription_consumption_budget_id"></a> [subscription\_consumption\_budget\_id](#output\_subscription\_consumption\_budget\_id) | The ID of the Subscription Consumption Budgets. |
| <a name="output_subscription_cost_management_view_id"></a> [subscription\_cost\_management\_view\_id](#output\_subscription\_cost\_management\_view\_id) | The ID of the Subscription Cost Management View. |
<!-- END_TF_DOCS -->