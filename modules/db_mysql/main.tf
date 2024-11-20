# MySQL Flexible Server
resource "azurerm_mysql_flexible_server" "mysql_server" {
  name                = var.mysql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = var.mysql_version
  backup_retention_days = var.backup_retention_days
  administrator_login = var.admin_username
  administrator_password = var.admin_password
  sku_name               = "GP_Standard_D2ds_v4"
  zone  = 1

  tags = var.tags
}

# Private Endpoint
resource "azurerm_private_endpoint" "mysql_private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "mysql-private-connection"
    private_connection_resource_id = azurerm_mysql_flexible_server.mysql_server.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  tags = var.tags
}

# Private DNS Zone for MySQL
resource "azurerm_private_dns_zone" "mysql_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

# Virtual Network Link to DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "mysql_dns_vnet_link" {
  name                   = "mysql-dns-vnet-link"
  resource_group_name    = var.resource_group_name
  private_dns_zone_name  = azurerm_private_dns_zone.mysql_dns_zone.name
  virtual_network_id     = var.virtual_network_id
  tags = var.tags
}

# A Record for MySQL Private Endpoint
resource "azurerm_private_dns_a_record" "mysql_a_record" {
  name                = var.mysql_server_name
  zone_name           = azurerm_private_dns_zone.mysql_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.mysql_private_endpoint.private_service_connection.0.private_ip_address]
}
