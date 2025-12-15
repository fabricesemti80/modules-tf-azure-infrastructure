output "virtual_networks" {
  value = {
    for vnet_key, vnet in azurerm_virtual_network.vnets :
    vnet_key => {
      name          = vnet.name
      address_space = vnet.address_space
      id            = vnet.id
    }
  }
  description = "Details of all virtual networks"
}

output "subnets" {
  value = {
    for subnet_key, subnet in azurerm_subnet.subnets :
    subnet_key => {
      name             = subnet.name
      address_prefixes = subnet.address_prefixes
      virtual_network  = subnet.virtual_network_name
      id               = subnet.id
    }
  }
  description = "Details of all subnets"
}
