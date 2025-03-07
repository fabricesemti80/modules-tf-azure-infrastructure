############ automation account  + runbook #############
resource "azurerm_automation_runbook" "vm-start-stop" {
  name                    = "${var.product}-vm-status-change-${var.env}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  log_verbose             = var.env == "prod" ? "false" : "true"
  log_progress            = "false"
  description             = "This is a powershell runbook used to stop and start ${var.product} VMs"
  runbook_type            = "PowerShell72"
  content                 = file("${path.module}/vm-start-stop.ps1")

  tags = var.tags
}

################# automation schedule #################
resource "azurerm_automation_schedule" "vm-start-stop" {
  for_each = { for schedule in var.schedules : schedule.name => schedule }

  name                    = "${var.product}-${each.value.name}-${replace(each.value.run_time, ":", "-")}"
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  frequency               = each.value.frequency
  week_days               = each.value.frequency == "Week" ? each.value.week_days : null
  month_days              = each.value.frequency == "Month" ? each.value.month_days : null
  dynamic "monthly_occurrence" {
    for_each = each.value.frequency == "Month" && each.value.month_days == null ? [1] : []

    # [
    #   for mo in each.value : mo.monthly_occurrence
    #   if each.value.frequency == "Month" && each.value.month_days == null
    # ]
    content {
      day        = each.value.monthly_occurrence.day
      occurrence = each.value.monthly_occurrence.occurrence
    }
  }

  interval    = each.value.interval
  timezone    = var.timezone
  start_time  = "${formatdate("YYYY-MM-DD", timeadd(timestamp(), "24h"))}T${each.value.run_time}Z"
  description = "Schedule to ${each.value.start_vm == true ? "start" : "stop"} vm at ${each.value.run_time}"

  depends_on = [
    azurerm_automation_runbook.vm-start-stop
  ]
}

resource "azurerm_automation_job_schedule" "vm-start-stop" {
  for_each = { for schedule in var.schedules : schedule.name => schedule }

  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account_name
  schedule_name           = "${var.product}-${each.value.name}-${replace(each.value.run_time, ":", "-")}"
  runbook_name            = azurerm_automation_runbook.vm-start-stop.name

  parameters = {
    subscription_name = var.target_subscription_name != null ? var.target_subscription_name : var.subscription_name
    vmlist            = join(",", var.vm_names)
    resourcegroup     = var.target_resource_group_name != null ? var.target_resource_group_name : var.resource_group_name
    start_vm          = each.value.start_vm
  }

  depends_on = [
    azurerm_automation_schedule.vm-start-stop
  ]
}
