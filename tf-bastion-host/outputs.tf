## ? Outputs for Bastion Host Module

## ? Bastion Host Resource Outputs
output "bastion_host_id" {
  description = "The resource ID of the Azure Bastion host"
  value       = azurerm_bastion_host.bastion_host.id
}

output "bastion_host_name" {
  description = "The name of the Azure Bastion host"
  value       = azurerm_bastion_host.bastion_host.name
}

## ? Public IP Outputs
output "bastion_public_ip_id" {
  description = "The resource ID of the Bastion host's public IP address"
  value       = azurerm_public_ip.bastion_pip.id
}

output "bastion_public_ip_address" {
  description = "The public IP address of the Bastion host"
  value       = azurerm_public_ip.bastion_pip.ip_address
}

# ## ? Network Security Group Outputs
# output "bastion_nsg_id" {
#   description = "The resource ID of the Network Security Group associated with the Bastion host"
#   value       = azurerm_network_security_group.bastion_subnet_nsg.id
# }

# output "bastion_nsg_name" {
#   description = "The name of the Network Security Group associated with the Bastion host"
#   value       = azurerm_network_security_group.bastion_subnet_nsg.name
# }

# ## ? Network Security Rules Outputs
# output "bastion_security_rules" {
#   description = "Details of the security rules created for the Bastion host"
#   value = {
#     for k, rule in azurerm_network_security_rule.rules : k => {
#       name                  = rule.name
#       priority              = rule.priority
#       destination_port      = rule.destination_port_range
#       source_address_prefix = rule.source_address_prefix
#     }
#   }
# }

## ? Configuration Outputs
output "bastion_configuration" {
  description = "Consolidated Bastion host configuration details"
  value = {
    sku                    = azurerm_bastion_host.bastion_host.sku
    scale_units            = azurerm_bastion_host.bastion_host.scale_units
    copy_paste_enabled     = azurerm_bastion_host.bastion_host.copy_paste_enabled
    file_copy_enabled      = azurerm_bastion_host.bastion_host.file_copy_enabled
    shareable_link_enabled = azurerm_bastion_host.bastion_host.shareable_link_enabled
    tunneling_enabled      = azurerm_bastion_host.bastion_host.tunneling_enabled
  }
}

## ? Subnet Association Output
output "bastion_subnet_id" {
  description = "The ID of the subnet where the Bastion host is deployed"
  value       = var.bastion_subnet_id
}

## ? Debugging and Diagnostic Outputs
output "module_metadata" {
  description = "Metadata about the Bastion host module deployment"
  value = {
    # prefix         = var.prefix
    resource_group = var.resource_group_name
    location       = var.location
  }
}
