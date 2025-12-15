##? Virtual Networks - Define and create Azure Virtual Networks
resource "azurerm_virtual_network" "vnets" {

  for_each = var.virtual_networks

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = each.value.address_space
  tags                = each.value.tags

  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }

}
##? Subnets - Dynamically created based on virtual networks and subnets
resource "azurerm_subnet" "subnets" {

  for_each = {
    for subnet in flatten([
      for vnet_key, vnet in var.virtual_networks : [
        for subnet_key, subnet in vnet.subnets : {
          key                                           = "${vnet_key}-${subnet_key}"
          name                                          = subnet.name
          vnet_key                                      = vnet_key
          address_prefixes                              = subnet.address_prefixes
          private_endpoint_network_policies             = subnet.private_endpoint_network_policies
          private_link_service_network_policies_enabled = subnet.private_link_service_network_policies_enabled
          default_outbound_access_enabled               = subnet.default_outbound_access_enabled
          service_endpoints                             = subnet.service_endpoints
          delegation                                    = lookup(subnet, "delegation", null)
        }
      ]
    ]) : subnet.key => subnet

  }

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.vnets[each.value.vnet_key].name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, "Enabled")
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, true)
  default_outbound_access_enabled               = try(each.value.default_outbound_access_enabled, false)
  service_endpoints                             = try(each.value.service_endpoints, [])

  dynamic "delegation" {
    for_each = try(each.value.delegation != null ? [each.value.delegation] : [], [])
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }

  lifecycle {
    create_before_destroy = false
  }

  depends_on = [azurerm_virtual_network.vnets]

}
