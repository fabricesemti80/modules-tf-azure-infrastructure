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

  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password

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
