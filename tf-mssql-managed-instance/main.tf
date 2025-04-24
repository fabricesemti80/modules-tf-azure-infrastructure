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

