resource "azurerm_availability_set" "avset" {
  for_each            = var.availability_sets
  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name

  platform_fault_domain_count  = lookup(each.value, "platform_fault_domain_count", 2)
  platform_update_domain_count = lookup(each.value, "platform_update_domain_count", 5)
  managed                      = lookup(each.value, "managed", true)

  tags = merge(var.tags, lookup(each.value, "tags", {}))
  lifecycle {
    ignore_changes = [
      tags["CreationTimeUTC"]
    ]
  }
}
