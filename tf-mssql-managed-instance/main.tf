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

  # (Optional) Azure AD Admin configuration
  dynamic "azure_active_directory_administrator" {
    for_each = each.value.azure_ad_admin != null ? [each.value.azure_ad_admin] : []

    content {
      login_username                      = azure_active_directory_administrator.value.login_username
      object_id                           = azure_active_directory_administrator.value.object_id
      principal_type                      = azure_active_directory_administrator.value.principal_type
      azuread_authentication_only_enabled = azure_active_directory_administrator.value.azuread_authentication_only_enabled
      tenant_id                           = azure_active_directory_administrator.value.tenant_id
    }
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

# Add these new resources after the azurerm_mssql_managed_instance resource
# Add Directory Readers role assignment for the managed identity
resource "azuread_directory_role" "directory_readers" {
  count        = var.enable_directory_readers_role ? 1 : 0
  display_name = "Directory Readers"
}

resource "azuread_directory_role_assignment" "sql_mi_directory_readers" {
  for_each = {
    for key, instance in azurerm_mssql_managed_instance.managed_instances :
    key => instance if var.enable_directory_readers_role &&
    (instance.identity[0].type == "SystemAssigned" ||
    instance.identity[0].type == "SystemAssigned,UserAssigned")
  }

  role_id             = azuread_directory_role.directory_readers[0].id
  principal_object_id = each.value.identity[0].principal_id
}
