resource "azurerm_app_service_plan" "drupal_app_srv" {
  name                = var.drupal_app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"  # Required for Linux App Services
  reserved            = true  # Required for Linux App Services

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }

  tags = var.tags

}

resource "azurerm_app_service" "drupal_app" {
  name                = var.drupal_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.drupal_app_srv.id

  site_config {
    linux_fx_version = var.php_version  # Set PHP version for the Drupal app
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"  # Disable app service storage if using external DB (like MySQL)
    "DATABASE_URL"                         = var.database_url  # Set environment variable for Drupal DB connection
    "DRUPAL_ENV"                           = var.drupal_env  # Custom environment variable for Drupal
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "drupal_private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "drupal-private-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_app_service.drupal_app.id
    subresource_names              = ["sites"]
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "drupal_dns_zone" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "drupal_dns_vnet_link" {
  name                  = "drupal-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.drupal_dns_zone.name
  virtual_network_id    = var.virtual_network_id
}

resource "azurerm_private_dns_a_record" "drupal_a_record" {
  name                = var.drupal_app_name
  zone_name           = azurerm_private_dns_zone.drupal_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.drupal_private_endpoint.private_service_connection.0.private_ip_address]
}
