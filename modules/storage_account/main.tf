resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                 = var.location
  account_tier              = var.account_tier
  account_replication_type = var.account_replication_type
  tags = var.tags
}

# Create a private endpoint for the storage account
resource "azurerm_private_endpoint" "storage_account" {
  name                = "${var.storage_account_name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "storage_account-privatesc"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

# DNS configuration for Private Endpoint (Optional, if you want to manage DNS resolution manually)
resource "azurerm_private_dns_zone" "storage_account" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_account" {
  name                  = "site-storage-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.storage_account.name
  virtual_network_id    = var.virtual_network_id
}

