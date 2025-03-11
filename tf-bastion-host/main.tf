## ? Terraform Configuration for Azure Bastion Host Infrastructure

## ? Public IP Resource for Bastion Host
## ? Creates a static public IP for the Azure Bastion Host
resource "azurerm_public_ip" "bastion_pip" {
  ##? Public IP configuration with static allocation and standard SKU
  name                = "${var.bastion_host_name}-pip-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.tags
  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }
}

## ? Azure Bastion Host Configuration
## ? Deploys the Bastion Host with specified network and feature configurations
resource "azurerm_bastion_host" "bastion_host" {

  ##? Bastion host naming and basic configuration
  name                = var.bastion_host_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ##? Bastion host SKU and scaling configuration
  sku         = var.bastion_sku
  scale_units = var.bastion_scale

  ##? Bastion host feature configuration using the new features object
  copy_paste_enabled     = var.bastion_features.copy_paste_enabled
  file_copy_enabled      = var.bastion_features.file_copy_enabled
  shareable_link_enabled = var.bastion_features.shareable_link_enabled
  tunneling_enabled      = var.bastion_features.tunneling_enabled

  ##? IP configuration for the Bastion host
  ip_configuration {
    name                 = "${var.bastion_host_name}-ipconfig"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }

  tags = local.tags
  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }
}
