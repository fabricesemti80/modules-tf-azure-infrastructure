# output "managed_instance_ids" {
#   description = "Map of Managed Instance IDs"
#   value       = { for k, v in azurerm_mssql_managed_instance.managed_instances : k => v.id }
# }

output "managed_instance_names" {
  description = "Map of Managed Instance names"
  value       = { for k, v in azurerm_mssql_managed_instance.managed_instances : k => v.name }
}

output "managed_instance_fqdns" {
  description = "Map of Managed Instance fully qualified domain names"
  value       = { for k, v in azurerm_mssql_managed_instance.managed_instances : k => v.fqdn }
}

output "managed_instance_connection_strings" {
  description = "Map of Managed Instance connection strings"
  value       = { for k, v in azurerm_mssql_managed_instance.managed_instances : k => "Server=tcp:${v.fqdn},1433" }
  sensitive   = true
}

output "managed_database_ids" {
  description = "Map of Managed Database IDs"
  value       = { for k, v in azurerm_mssql_managed_database.databases : k => v.id }
}

output "managed_database_names" {
  description = "Map of Managed Database names"
  value       = { for k, v in azurerm_mssql_managed_database.databases : k => v.name }
}
