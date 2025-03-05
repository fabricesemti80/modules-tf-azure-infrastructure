variable "location" {
  type        = string
  description = "Azure region where the Automation Runbook resources will be deployed"
  default     = "uksouth"
}

variable "env" {
  type        = string
  description = "Environment name (e.g., dev, test, prod) for resource naming and tagging"
}

variable "product" {
  type        = string
  description = "Product or project name for resource naming and tagging"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources created by this module"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the Automation Account will be deployed"
}

variable "target_resource_group_name" {
  type        = string
  description = "Optional target resource group name containing VMs to be managed (overrides the default resource group)"
  default     = null
}

variable "automation_account_name" {
  type        = string
  description = "Name of the Azure Automation Account to be created or used"
}

variable "timezone" {
  type        = string
  description = "Timezone to use for scheduling runbooks (IANA time zone format)"
  default     = "Europe/London"
}

variable "vm_names" {
  type        = list(string)
  description = "List of virtual machine names to be targeted by the start/stop runbook"
  default     = []
}

variable "subscription_name" {
  type        = string
  description = "Name of the Azure subscription containing the target VMs"
  default     = "Subscription name to target"
}

variable "target_subscription_name" {
  type        = string
  description = "Optional override for the subscription name containing the target VMs"
  default     = null
}

variable "schedules" {
  type = list(object({
    name       = string
    frequency  = string
    interval   = number
    run_time   = string
    start_vm   = bool
    week_days  = optional(list(string))
    month_days = optional(list(number))
    monthly_occurrence = optional(object({
      day        = optional(string)
      occurrence = optional(number)
    }))
  }))
  description = "List of schedule configurations for starting or stopping VMs. Each schedule defines when and how VMs should be started or stopped."
  default     = []

  validation { # Check no interval for OneTime
    condition = alltrue(flatten([
      for s in var.schedules : can(s.interval) == false
      if s.frequency == "OneTime"
    ]))
    error_message = "Cannot provide an interval when using 'oneTime'"
  }

  validation { # Check for valid frequency
    condition = alltrue([
      for s in var.schedules : contains(["OneTime", "Day", "Hour", "Week", "Month"], s.frequency)
    ])
    error_message = "'frequency' must be one of the following: 'OneTime', 'Day', 'Hour', 'Week', or 'Month'."
  }

  validation { #Check for valid time format
    condition = alltrue([
      for s in var.schedules : can(regex("^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]$", s.run_time))
    ])
    error_message = "'run_time' must be be in the format 'HH:MM:SS'."
  }

  validation { # Check valid week days
    condition = alltrue(flatten([
      for s in var.schedules : [
        for d in s.week_days : contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], d)
      ]
      if s.frequency == "Week" && s.week_days != null
    ]))
    error_message = "Must provide a valid 'week_days' option when using a frequency of 'Week', valid options are: 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'."
  }

  validation { # Check month numbers are in range
    condition = alltrue(flatten([
      for s in var.schedules : [
        for d in s.month_days : (d >= -1 && d <= 31)
      ]
      if s.frequency == "Month" && s.month_days != null
    ]))
    error_message = "You must provide a valid 'month_days' option when using a frequency of 'Month', valid options are: 1 - 31 or -1 (for last day of the month)."
  }

  validation { # Check for valid monthly_occurrence.day
    condition = alltrue([
      for s in var.schedules :
      contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], s.monthly_occurrence.day)
      if s.frequency == "Month" && s.monthly_occurrence != null
    ])
    error_message = "'monthly_occurrence.day' must be one of the following: 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'."
  }

  validation { # Check for valid monthly_occurrence.occurrence
    condition = alltrue([
      for s in var.schedules :
      s.monthly_occurrence.occurrence >= -1 && s.monthly_occurrence.occurrence <= 5
      if s.frequency == "Month" && s.monthly_occurrence != null
    ])
    error_message = "Occurrence of the week within the month must be between 1 and 5 or -1 for last week within the month."
  }
}
