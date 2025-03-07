##?  Output for the Azure Key Vault name
output "kv_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.kv.name
}

##?  Output for the Key Vault ID
output "kv_id" {
  description = "The ID of the created Key Vault."
  value       = azurerm_key_vault.kv.id
}

##?  Output for the Key Vault resource group name
output "kv_resource_group_name" {
  description = "The resource group in which the Key Vault is located."
  value       = azurerm_key_vault.kv.resource_group_name
}

##?  Output for the Key Vault location
output "kv_location" {
  description = "The location where the Key Vault is created."
  value       = azurerm_key_vault.kv.location
}

##?  Output for the Key Vault tenant ID
output "kv_tenant_id" {
  description = "The tenant ID used by the Key Vault."
  value       = azurerm_key_vault.kv.tenant_id
}

##?  Output for the Key Vault SKU
output "kv_sku" {
  description = "The SKU of the Key Vault."
  value       = azurerm_key_vault.kv.sku_name
}

##?  Output for the Key Vault soft delete retention days
output "kv_soft_delete_retention_days" {
  description = "The number of days that the Key Vault soft delete retention is configured for."
  value       = azurerm_key_vault.kv.soft_delete_retention_days
}

##?  Output for the Key Vault RBAC Authorization status
output "kv_enable_rbac_authorization" {
  description = "Whether RBAC authorization is enabled on the Key Vault."
  value       = azurerm_key_vault.kv.enable_rbac_authorization
}

##? Private endpoint outputs
output "private_endpoint_id" {
  description = "The ID of the Private Endpoint, if created"
  value       = try(values(azurerm_private_endpoint.kv_endpoint)[0].id, null)
}

output "private_endpoint_ip_addresses" {
  description = "The IP addresses of the Private Endpoint, if created"
  value       = try(values(azurerm_private_endpoint.kv_endpoint)[0].private_service_connection[0].private_ip_address, null)
}

