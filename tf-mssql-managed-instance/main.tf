resource "azurerm_mssql_managed_instance" "managed_instances" {
  for_each = var.managed_instances

  name                = each.key
  resource_group_name = var.resource_group_name
  location            = var.location

  license_type       = each.value.license_type
  sku_name           = each.value.sku_name
  storage_size_in_gb = each.value.storage_size_in_gb
  vcores             = each.value.vcores
  subnet_id          = each.value.subnet_id

  # Local - SA - authentication
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password

  # Managed Identity configuration (AzureADmin pre-requisite)
  identity {
    type         = each.value.identity_type
    identity_ids = each.value.identity_ids
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }

  ##? Tagging
  tags = var.tags
  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }
}

resource "azurerm_mssql_managed_database" "databases" {
  for_each = local.databases

  name                = each.value.name
  managed_instance_id = azurerm_mssql_managed_instance.managed_instances[each.value.instance_key].id

  # Add backup configurations if available
  short_term_retention_days = try(each.value.short_term_retention_days, 7)

  # Add long-term retention policy if configured
  dynamic "long_term_retention_policy" {
    for_each = try(each.value.long_term_retention_policy != null ? [each.value.long_term_retention_policy] : [], [])

    content {
      weekly_retention  = long_term_retention_policy.value.weekly_retention
      monthly_retention = long_term_retention_policy.value.monthly_retention
      yearly_retention  = long_term_retention_policy.value.yearly_retention
      week_of_year      = long_term_retention_policy.value.week_of_year
    }
  }

  # Add lifecycle block to prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
}


# Get the Directory Readers role
resource "azuread_directory_role" "directory_readers" {
  count        = var.enable_directory_readers_role ? 1 : 0
  display_name = "Directory Readers"
}

# Assign Directory Readers role to SQL MI managed identities
resource "azuread_directory_role_assignment" "sql_mi_directory_readers" {
  for_each = {
    for key, instance in azurerm_mssql_managed_instance.managed_instances :
    key => instance if var.enable_directory_readers_role &&
    (instance.identity[0].type == "SystemAssigned" ||
    instance.identity[0].type == "SystemAssigned,UserAssigned")
  }

  role_id             = azuread_directory_role.directory_readers[0].template_id
  principal_object_id = each.value.identity[0].principal_id
}

# Set Azure AD Administrator for SQL Managed Instances
resource "azurerm_mssql_managed_instance_active_directory_administrator" "admin" {
  for_each = {
    for key, instance in var.managed_instances :
    key => instance if instance.azure_ad_admin != null
  }

  managed_instance_id         = azurerm_mssql_managed_instance.managed_instances[each.key].id
  login_username              = each.value.azure_ad_admin.login_username
  object_id                   = each.value.azure_ad_admin.object_id
  tenant_id                   = each.value.azure_ad_admin.tenant_id
  azuread_authentication_only = each.value.azure_ad_admin.azuread_authentication_only_enabled

  # This explicit dependency ensures the Directory Readers role is assigned before setting the AD admin
  depends_on = [
    azuread_directory_role_assignment.sql_mi_directory_readers
  ]
}

# Create private endpoints for SQL Managed Instances
resource "azurerm_private_endpoint" "sql_mi_private_endpoints" {
  for_each = local.private_endpoints

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.subnet_id

  custom_network_interface_name = each.value.custom_network_interface_name
  tags                          = each.value.tags

  lifecycle {
    ignore_changes = [
      tags["CreationTimeUTC"]
    ]
  }

  private_service_connection {
    name                           = each.value.private_service_connection_name
    private_connection_resource_id = each.value.resource_id
    is_manual_connection           = each.value.is_manual_connection
    subresource_names              = each.value.subresource_names
  }

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration
    content {
      name               = ip_configuration.value.name
      private_ip_address = ip_configuration.value.private_ip_address
      subresource_name   = ip_configuration.value.subresource_name
      member_name        = ip_configuration.value.member_name
    }
  }

  dynamic "private_dns_zone_group" {
    for_each = length(each.value.private_dns_zone_ids) > 0 ? [1] : []
    content {
      name                 = "${each.value.name}-dns-zone-group"
      private_dns_zone_ids = each.value.private_dns_zone_ids
    }
  }
}

