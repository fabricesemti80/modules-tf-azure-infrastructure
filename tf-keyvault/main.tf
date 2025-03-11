##! NOTE: secrets in the keyvault only visible/accessible from the Azure portal behind a listed
##! IP address!

data "azurerm_client_config" "current" {}

## ? Key Vault Resource Creation
resource "azurerm_key_vault" "kv" {

  ##? Basic Key Vault Configuration
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
  location            = var.azure_region
  tenant_id           = data.azurerm_client_config.current.tenant_id

  ##? Key Vault Security Settings
  sku_name                  = var.key_vault_sku
  purge_protection_enabled  = var.enable_purge_protection
  enable_rbac_authorization = var.enable_rbac_authorization

  ##? Network Access Controls (Optional)
  network_acls {
    default_action             = var.network_default_action
    bypass                     = var.network_bypass
    ip_rules                   = var.allowed_ip_addresses
    virtual_network_subnet_ids = var.allowed_subnet_ids
  }

  ##? Soft Delete and Retention Configuration
  soft_delete_retention_days = var.soft_delete_retention_days

  ##? Tagging
  tags = local.tags
  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }
}

# Private Endpoint - only created when subnet_id is provided
resource "azurerm_private_endpoint" "kv_endpoint" {
  for_each            = var.private_endpoint.enabled ? toset(["enabled"]) : toset([])
  name                = var.private_endpoint.name
  location            = var.azure_region
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint.subnet_id

  private_service_connection {
    name                           = var.private_endpoint.service_connection_name
    private_connection_resource_id = azurerm_key_vault.kv.id
    is_manual_connection           = var.manual_private_connection
    subresource_names              = var.private_subresources
  }
  ##? Tagging
  tags = local.tags
  lifecycle {
    ignore_changes = [tags["CreationTimeUTC"]]
  }
}
