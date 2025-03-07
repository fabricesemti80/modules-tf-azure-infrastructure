# ------------------------------------------------------
# GENERAL CONFIGURATION VARIABLES
# ------------------------------------------------------

variable "location" {
  type        = string
  description = "Azure region where the Automation Runbook resources will be deployed (e.g., uksouth, ukwest, eastus)"
  default     = "uksouth"
}

variable "env" {
  type        = string
  description = "Environment identifier used for resource naming and tagging (e.g., dev, test, prod, uat)"
}

variable "product" {
  type        = string
  description = "Product or project identifier used for resource naming and tagging conventions"
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to be applied to all resources created by this module for resource management and organization"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the Automation Account and related resources will be deployed"
}

# ------------------------------------------------------
# AUTOMATION ACCOUNT CONFIGURATION
# ------------------------------------------------------

variable "automation_account_name" {
  type        = string
  description = "Name of the Azure Automation Account to be created or used for the start/stop runbooks"
}

variable "timezone" {
  type        = string
  description = "IANA time zone format (e.g., 'Europe/London', 'America/New_York') used for scheduling runbook executions"
  default     = "Europe/London"
}

# ------------------------------------------------------
# TARGET RESOURCES CONFIGURATION
# ------------------------------------------------------

variable "vm_names" {
  type        = list(string)
  description = "List of virtual machine names that will be managed by the start/stop runbook automation"
  default     = []
}

variable "subscription_name" {
  type        = string
  description = "Default Azure subscription name containing the target VMs for the automation runbook"
  default     = "Subscription name to target"
}

variable "target_subscription_name" {
  type        = string
  description = "Optional override for the subscription name containing the target VMs. If provided, this will be used instead of subscription_name"
  default     = null
}

variable "target_resource_group_name" {
  type        = string
  description = "Optional target resource group name containing VMs to be managed. If provided, overrides the default resource group specified in resource_group_name"
  default     = null
}

# ------------------------------------------------------
# SCHEDULE CONFIGURATION
# ------------------------------------------------------

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
  description = "Configuration for VM start/stop schedules. Each schedule defines when and how VMs should be managed including frequency (OneTime, Day, Hour, Week, Month), time of execution, and whether to start or stop VMs."
  default     = []

  validation { # Check no interval for OneTime
    condition = alltrue(flatten([
      for s in var.schedules : can(s.interval) == false
      if s.frequency == "OneTime"
    ]))
    error_message = "Cannot provide an interval when using 'OneTime' frequency"
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
    error_message = "'run_time' must be in the format 'HH:MM:SS' (e.g., '08:00:00')."
  }

  validation { # Check valid week days
    condition = alltrue(flatten([
      for s in var.schedules : [
        for d in s.week_days : contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], d)
      ]
      if s.frequency == "Week" && s.week_days != null
    ]))
    error_message = "For 'Week' frequency, 'week_days' must contain valid day names: 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'."
  }

  validation { # Check month numbers are in range
    condition = alltrue(flatten([
      for s in var.schedules : [
        for d in s.month_days : (d >= -1 && d <= 31)
      ]
      if s.frequency == "Month" && s.month_days != null
    ]))
    error_message = "For 'Month' frequency with 'month_days', values must be between 1-31 or -1 (for last day of the month)."
  }

  validation { # Check for valid monthly_occurrence.day
    condition = alltrue([
      for s in var.schedules :
      contains(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], s.monthly_occurrence.day)
      if s.frequency == "Month" && s.monthly_occurrence != null
    ])
    error_message = "For 'Month' frequency with 'monthly_occurrence', 'day' must be a valid weekday name."
  }

  validation { # Check for valid monthly_occurrence.occurrence
    condition = alltrue([
      for s in var.schedules :
      s.monthly_occurrence.occurrence >= -1 && s.monthly_occurrence.occurrence <= 5
      if s.frequency == "Month" && s.monthly_occurrence != null
    ])
    error_message = "For 'Month' frequency with 'monthly_occurrence', 'occurrence' must be between 1-5 or -1 (for last occurrence)."
  }
}
