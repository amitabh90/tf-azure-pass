
resource "azurerm_public_ip" "vpn_gateway_ip" {
  name                = var.vpn_gateway_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_virtual_network_gateway" "vpn_gateway" {
  name                = var.vpn_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = false
  sku                 = "VpnGw1"  # Modify this based on requirements
  ip_configuration {
    name                          = "vpnGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }
}

resource "azurerm_local_network_gateway" "local_gateway" {
  name                = var.local_network_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = var.onprem_public_ip
  address_space       = var.onprem_address_space
}

resource "azurerm_virtual_network_gateway_connection" "vpn_connection" {
  name                                = var.vpn_connection_name
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  virtual_network_gateway_id         = azurerm_virtual_network_gateway.vpn_gateway.id
  local_network_gateway_id           = azurerm_local_network_gateway.local_gateway.id
  shared_key                          = var.shared_key
  routing_weight                      = 10
  enable_bgp                          = false
  type = "IPsec"
}
