resource "random_pet" "rg-name" {
  prefix = "stg"
}
resource "random_id" "front_door_endpoint_name" {
  byte_length = 8
}

locals {
  front_door_profile_name      = "SiteStageFrontDoor"
  front_door_endpoint_name     = "afd-${lower(random_id.front_door_endpoint_name.hex)}"
  front_door_origin_group_name = "SiteOriginGroup"
  front_door_origin_name       = "SiteAppServiceOrigin"
  front_door_route_name        = "Route"
}

resource "azurerm_cdn_frontdoor_profile" "site_front_door" {
  name                = local.front_door_profile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.front_door_sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "site_endpoint" {
  name                     = local.front_door_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.site_front_door.id
}

resource "azurerm_cdn_frontdoor_origin_group" "site_origin_group" {
  name                     = local.front_door_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.site_front_door.id
  session_affinity_enabled = true

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Https"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "site_app_service_origin" {
  name                          = local.front_door_origin_name
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.site_origin_group.id

  enabled                        = true
  host_name                      = var.app_service_hostname
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.app_service_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
  private_link {
    private_link_target_id = var.app_service_id
    location = var.location
    target_type = "sites"
  }

}

resource "azurerm_cdn_frontdoor_route" "site_route" {
  name                          = local.front_door_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.site_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.site_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.site_app_service_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

# Create Private Endpoint
resource "azurerm_private_endpoint" "frontdoor_private_endpoint" {
  name                = "frontdoor-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id  # The subnet where the Private Endpoint will be created

  private_service_connection {
    name                           = "frontdoor-priv-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cdn_frontdoor_profile.site_front_door.id
    subresource_names              = ["frontdoor"]
  }
}

# Create Private DNS Zone for Front Door
resource "azurerm_private_dns_zone" "frontdoor_dns_zone" {
  name                = "privatelink.azurefd.net"
  resource_group_name = var.resource_group_name
}

# Link the DNS zone to the VNet
resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = "frontdoor-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.frontdoor_dns_zone.name
   virtual_network_id    = var.virtual_network_id # The ID of the virtual network where the private endpoint resides
}

# DNS A Record for Front Door (resolves to private IP)
resource "azurerm_private_dns_a_record" "frontdoor_a_record" {
  name                = var.name
  zone_name           = azurerm_private_dns_zone.frontdoor_dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 60
  records             = [azurerm_private_endpoint.frontdoor_private_endpoint.private_service_connection.0.private_ip_address]
}

