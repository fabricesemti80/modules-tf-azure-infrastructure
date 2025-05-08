locals {
  # Process databases to handle both string and object types, and handle empty databases
  databases = merge([
    for instance_key, instance in var.managed_instances : {
      for db_key, db in instance.databases : "${instance_key}-${db_key}" => {
        name                       = try(db.name, db) # If db is a string, use it as name; otherwise use db.name
        instance_key               = instance_key
        short_term_retention_days  = try(db.short_term_retention_days)
        long_term_retention_policy = try(db.long_term_retention_policy)
      }
    } if length(coalesce(instance.databases, {})) > 0 # Only process if databases exist and are not empty
  ]...)

  # Process private endpoints
  private_endpoints = {
    for instance_key, instance in var.managed_instances :
    instance_key => {
      name                            = coalesce(instance.private_endpoint.name, "pe-${instance_key}")
      resource_id                     = azurerm_mssql_managed_instance.managed_instances[instance_key].id
      subnet_id                       = instance.private_endpoint.subnet_id
      is_manual_connection            = instance.private_endpoint.is_manual_connection
      private_service_connection_name = coalesce(instance.private_endpoint.private_service_connection_name, "pe-connection-${instance_key}")
      private_dns_zone_ids            = instance.private_endpoint.private_dns_zone_ids
      subresource_names               = instance.private_endpoint.subresource_names
      custom_network_interface_name   = instance.private_endpoint.custom_network_interface_name
      ip_configuration                = instance.private_endpoint.ip_configuration
      tags                            = merge(var.tags, instance.private_endpoint.tags)
    }
    if instance.private_endpoint != null
  }
}
