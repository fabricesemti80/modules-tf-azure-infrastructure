## Networking Setup

# Network Interface for Windows Virtual Machines
resource "azurerm_network_interface" "windows_nic" {
  for_each            = var.windows_vms_config
  name                = "${each.value.name}-nic"
  location            = var.azure_region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${each.value.name}-ipconfig"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = each.value.static_ip != null ? "Static" : var.private_ip_allocation_method
    private_ip_address            = each.value.static_ip
  }

  tags = merge(var.tags, {
    CreationTimeUTC = timestamp()
  })
  lifecycle {
    ignore_changes        = [tags["CreationTimeUTC"]]
    create_before_destroy = false
  }
}


## Virtual Machine Setup

# Virtual Machine for Windows Deployment
resource "azurerm_windows_virtual_machine" "windows_vm" {
  for_each                          = var.windows_vms_config
  name                              = each.value.name
  computer_name                     = each.key
  location                          = var.azure_region
  resource_group_name               = var.resource_group_name
  size                              = each.value.size
  admin_username                    = each.value.login_username
  admin_password                    = each.value.login_password
  network_interface_ids             = [azurerm_network_interface.windows_nic[each.key].id]
  patch_assessment_mode             = each.value.patch_assessment_mode
  vm_agent_platform_updates_enabled = true
  provision_vm_agent                = true

  availability_set_id = each.value.availability_set_id
  license_type        = var.windows_license_type

  # Enable system-assigned managed identity if specified
  identity {
    type = var.enable_system_managed_identity ? "SystemAssigned" : null
  }

  os_disk {
    name                 = "${each.value.name}-osdisk"
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  # vtpm_enabled = true #TODO: Enable when we have a plan to support it

  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags["CreationTimeUTC"],
      identity,
      vm_agent_platform_updates_enabled
    ]
  }

  depends_on = [
    azurerm_network_interface.windows_nic
  ]
}

# Data Disks for Windows Virtual Machines
resource "azurerm_managed_disk" "windows_data_disk" {
  for_each = {
    for idx in flatten([
      for vm_key, vm in var.windows_vms_config : [
        for disk in vm.data_disks : {
          vm_key     = vm_key
          disk_name  = disk.name
          disk_size  = disk.size_gb
          disk_type  = disk.storage_account_type
          disk_cache = disk.caching
          disk_lun   = disk.lun
        }
      ]
    ]) : "${idx.vm_key}-${idx.disk_name}" => idx
  }

  name                 = each.value.disk_name
  location             = var.azure_region
  resource_group_name  = var.resource_group_name
  storage_account_type = each.value.disk_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size

  tags = var.tags
  lifecycle {
    ignore_changes        = [tags["CreationTimeUTC"]]
    create_before_destroy = false
  }

}

# Attach Data Disks to Windows Virtual Machines
resource "azurerm_virtual_machine_data_disk_attachment" "windows_disk_attachment" {
  for_each = {
    for idx in flatten([
      for vm_key, vm in var.windows_vms_config : [
        for disk in vm.data_disks : {
          vm_key     = vm_key
          disk_name  = disk.name
          disk_cache = disk.caching
          disk_lun   = disk.lun
        }
      ]
    ]) : "${idx.vm_key}-${idx.disk_name}" => idx
  }

  managed_disk_id    = azurerm_managed_disk.windows_data_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.windows_vm[each.value.vm_key].id
  lun                = each.value.disk_lun
  caching            = each.value.disk_cache

  depends_on = [
    azurerm_managed_disk.windows_data_disk
  ]
}

## VM Auto-shutdown Schedules

# Schedule for Auto-shutdown of Windows Virtual Machines
resource "azurerm_dev_test_global_vm_shutdown_schedule" "windows_shutdown" {
  for_each = {
    for k, v in var.windows_vms_config : k => v
    if v.daily_shutdown_time != null
  }
  virtual_machine_id    = azurerm_windows_virtual_machine.windows_vm[each.key].id
  location              = var.azure_region
  enabled               = true
  daily_recurrence_time = each.value.daily_shutdown_time
  timezone              = "UTC"

  notification_settings {
    enabled = false
  }

  tags = var.tags
  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }

  depends_on = [
    azurerm_windows_virtual_machine.windows_vm
  ]
}
