# Terraform Module for Azure Redis Cache

# Azure Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name

  tags = var.tags
}

# Private DNS Zone for Redis
resource "azurerm_private_dns_zone" "redis_dns" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}

# Virtual Network Link for DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = "${var.name}-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis_dns.name
  virtual_network_id    = var.virtual_network_id
}

# Private Endpoint
resource "azurerm_private_endpoint" "redis_endpoint" {
  name                = "${var.name}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${var.name}-privatelink"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    subresource_names              = ["redisCache"]
    is_manual_connection           = false
  }
}

# Private DNS Zone A Record
resource "azurerm_private_dns_a_record" "redis_a_record" {
  name                = azurerm_redis_cache.redis.hostname
  zone_name           = azurerm_private_dns_zone.redis_dns.name
  resource_group_name = var.resource_group_name
  ttl                 = 300

  records = [azurerm_private_endpoint.redis_endpoint.private_service_connection.0.private_ip_address]

}
