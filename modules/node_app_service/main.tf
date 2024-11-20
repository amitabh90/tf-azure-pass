resource "azurerm_app_service_plan" "node_app_srv" {
  name                = var.node_app_service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "Linux"  # Required for Linux App Services
  reserved            = true  # Required for Linux-based App Services

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }

  tags = var.tags
}

resource "azurerm_app_service" "node_app" {
  name                = var.node_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.node_app_srv.id

  site_config {
    linux_fx_version = "NODE|20-lts"  # Set Node.js 20 LTS version for the app
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"  # Optional: Disable App Service Storage
    "NODE_ENV"                           = var.node_env  # Environment variable (e.g., production, staging)
  }

  tags = var.tags
}

resource "azurerm_private_endpoint" "node_private_endpoint" {
  name                = var.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "node-private-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_app_service.node_app.id
    subresource_names              = ["sites"]
  }

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "node_a_record" {
  name                = var.node_app_name
  zone_name           = var.dns_zone_name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.node_private_endpoint.private_service_connection.0.private_ip_address]
}

