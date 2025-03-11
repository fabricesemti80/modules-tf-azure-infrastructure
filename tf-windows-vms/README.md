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
| [azurerm_dev_test_global_vm_shutdown_schedule.windows_shutdown](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_managed_disk.windows_data_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.windows_nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.windows_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_windows_virtual_machine.windows_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_region"></a> [azure\_region](#input\_azure\_region) | The Azure region where the resources will be deployed.<br/>  Use the official Azure region names such as:<br/>  - "eastus"<br/>  - "westeurope"<br/>  - "southcentralus" | `string` | n/a | yes |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | The ID for the Azure Key Vault used to store secrets such as RDP passwords. | `string` | `""` | no |
| <a name="input_private_ip_allocation_method"></a> [private\_ip\_allocation\_method](#input\_private\_ip\_allocation\_method) | The method used to allocate private IP addresses for network interfaces.<br/>  Can be 'Static' (manual IP) or 'Dynamic' (automatic IP). | `string` | `"Dynamic"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where compute resources (such as virtual machines) will be placed.<br/>  Resource group names:<br/>  - Must be unique within your Azure subscription<br/>  - Can be 1-90 characters long<br/>  - Can only include alphanumeric, underscore, parentheses, hyphen, period<br/>  - Cannot end in a period | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to be applied to resources for easier management and organization.<br/>  Tags are key-value pairs that help with:<br/>  - Resource organization<br/>  - Cost allocation<br/>  - Automation<br/>  - Access control<br/><br/>  Example:<br/>  resource\_tags = {<br/>    Environment = "Production"<br/>    Department  = "IT"<br/>    Project     = "Infrastructure"<br/>    Owner       = "DevOps Team"<br/>  } | `map(string)` | n/a | yes |
| <a name="input_vm_daily_shutdown_time"></a> [vm\_daily\_shutdown\_time](#input\_vm\_daily\_shutdown\_time) | The time of day when the virtual machines should be shut down daily in UTC 24hr format (e.g., '2000' for 8:00 PM).<br/>  Set to null to disable auto-shutdown. | `string` | `null` | no |
| <a name="input_windows_license_type"></a> [windows\_license\_type](#input\_windows\_license\_type) | Specifies the type of on-premise license (BYOL) to be used.<br/>  Ensure you have eligible Windows Server licenses with Software Assurance before enabling.<br/>  The license\_type can be either "Windows\_Server" or "None".<br/>  This change won't require a VM restart.<br/>  Remember to validate your organization's licensing compliance before enabling. | `string` | `"None"` | no |
| <a name="input_windows_vms_config"></a> [windows\_vms\_config](#input\_windows\_vms\_config) | A map of Windows Virtual Machines configurations where each key is a unique identifier and the value contains the VM's specifications.<br/>  Each VM configuration includes details such as the VM name, size, subnet ID, source image reference, optional data disks configuration, and optional daily shutdown time in UTC 24hr format (e.g., '2000' for 8:00 PM).<br/><br/>  Example usage:<br/>  windows\_vms\_config = {<br/>    "vm1" = {<br/>      name           = "example-vm1"<br/>      login\_username = "azureuser"<br/>      login\_password = "Password123!"<br/>      source\_image\_reference = {<br/>        publisher = "MicrosoftWindowsServer"<br/>        offer     = "WindowsServer"<br/>        sku       = "2022-Datacenter"<br/>        version   = "latest"<br/>      }<br/>      data\_disks = []<br/>    }<br/>  } | <pre>map(object({<br/>    name           = string                           # The name of the virtual machine<br/>    login_username = optional(string, "azureuser")    # The username for logging into the VM<br/>    login_password = string                           # The password for logging into the VM<br/>    size           = optional(string, "Standard_B2s") # The size of the virtual machine<br/>    subnet_id      = optional(string, "")             # The subnet ID where the VM will be deployed<br/>    source_image_reference = object({<br/>      publisher = string # The publisher of the source image<br/>      offer     = string # The offer of the source image<br/>      sku       = string # The SKU of the source image<br/>      version   = string # The version of the source image<br/>    })<br/>    static_ip                    = optional(string)                        # For static IP allocation (not used if private_ip_allocation_method is set to Dynamic)<br/>    patch_assessment_mode        = optional(string, "AutomaticByPlatform") # The patch assessment mode for the VM<br/>    availability_set_id          = optional(string, null)                  # The availability set ID for the VM<br/>    os_disk_storage_account_type = optional(string, "Standard_LRS")        # The storage account type for the OS disk<br/>    os_disk_caching              = optional(string, "ReadWrite")           # The caching mode for the OS disk<br/>    daily_shutdown_time          = optional(string)                        # The daily shutdown time in UTC 24hr format (e.g., '2000' for 8:00 PM). Set to null to disable auto-shutdown<br/>    data_disks = optional(list(object({<br/>      name                 = string                           # The name of the data disk<br/>      size_gb              = number                           # The size of the data disk in GB<br/>      storage_account_type = optional(string, "Standard_LRS") # The storage account type for the data disk<br/>      caching              = optional(string, "ReadWrite")    # The caching mode for the data disk<br/>      lun                  = number                           # The logical unit number for the data disk<br/>    })), [])<br/>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the Azure Key Vault where RDP password is stored. |
| <a name="output_vm_shutdown_schedules"></a> [vm\_shutdown\_schedules](#output\_vm\_shutdown\_schedules) | Details of the VM auto-shutdown schedules for VMs where shutdown is enabled. |
| <a name="output_windows_data_disks"></a> [windows\_data\_disks](#output\_windows\_data\_disks) | Details of the data disks attached to Windows virtual machines. |
| <a name="output_windows_network_interfaces"></a> [windows\_network\_interfaces](#output\_windows\_network\_interfaces) | Details of the created network interfaces for the Windows virtual machines. |
| <a name="output_windows_virtual_machines"></a> [windows\_virtual\_machines](#output\_windows\_virtual\_machines) | Details of the created Windows virtual machines, including name, size, private IP. |
<!-- END_TF_DOCS -->