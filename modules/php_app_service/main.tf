
# Create an App Service Plan (Linux-based)
resource "azurerm_app_service_plan" "php_app_srv" {
  name                = var.php_app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"
  reserved            = true  # Required for Linux App Services
  sku {
    tier = "Standard"
    size = "S1"
  }
}

# Create an App Service with PHP 8.2
resource "azurerm_web_app" "php_app_srv" {
  name                = var.php_web_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.php_app_srv.id

  site_config {
    linux_fx_version = "PHP|8.2"  # Specify PHP 8.2 runtime
  }

  https_only = true  # Enforce HTTPS
  tags       = var.tags
}

# Create a Private Endpoint for the App Service
resource "azurerm_private_endpoint" "php_app_srv" {
  name                = "${var.php_web_app_name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "php_app_srv-privatesc"
    private_connection_resource_id = azurerm_web_app.php_app_srv.id
    is_manual_connection           = false
    subresource_names              = ["site"]
  }
}

# DNS Configuration (Optional)
resource "azurerm_private_dns_zone" "php_app_srv" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "php_app_srv" {
  name                  = "php_app_srv-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.php_app_srv.name
  virtual_network_id    = var.virtual_network_id
}


