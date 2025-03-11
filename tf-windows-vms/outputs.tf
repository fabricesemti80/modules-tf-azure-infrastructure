# Output for created Network Interfaces
output "windows_network_interfaces" {
  description = "Details of the created network interfaces for the Windows virtual machines."
  value = {
    for k, v in azurerm_network_interface.windows_nic : k => {
      name                = v.name
      private_ip_address  = v.private_ip_address
      resource_group_name = v.resource_group_name
      location            = v.location
      tags                = v.tags
    }
  }
}

# Output for created Windows Virtual Machines
output "windows_virtual_machines" {
  description = "Details of the created Windows virtual machines, including name, size, private IP."
  value = {
    for k, v in azurerm_windows_virtual_machine.windows_vm : k => {
      name                = v.name
      size                = v.size
      private_ip_address  = azurerm_network_interface.windows_nic[k].private_ip_address
      resource_group_name = v.resource_group_name
      os_disk_name        = v.os_disk[0].name
      tags                = v.tags
      id                  = v.id
    }
  }
}

# Output for VM Shutdown Schedule
output "vm_shutdown_schedules" {
  description = "Details of the VM auto-shutdown schedules for VMs where shutdown is enabled."
  value = {
    for k, v in azurerm_dev_test_global_vm_shutdown_schedule.windows_shutdown : k => {
      virtual_machine_id    = v.virtual_machine_id
      enabled               = v.enabled
      daily_recurrence_time = v.daily_recurrence_time
      timezone              = v.timezone
      notification_enabled  = v.notification_settings[0].enabled
    }
  }
}


# Output for Key Vault ID
output "key_vault_id" {
  description = "The ID of the Azure Key Vault where RDP password is stored."
  value       = var.key_vault_id
}

# # Output for Random Password (for reference or debugging)
# output "vm_password" {
#   description = "The generated RDP password (for debugging or testing purposes)."
#   value       = random_password.vm_password.result
#   sensitive   = true
# }

# Add this to your existing outputs
output "windows_data_disks" {
  description = "Details of the data disks attached to Windows virtual machines."
  value = {
    for k, v in azurerm_managed_disk.windows_data_disk : k => {
      name                 = v.name
      size_gb              = v.disk_size_gb
      storage_account_type = v.storage_account_type
      resource_group_name  = v.resource_group_name
    }
  }
}
