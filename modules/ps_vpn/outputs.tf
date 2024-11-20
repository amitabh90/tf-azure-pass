output "vpn_gateway_id" {
  value       = azurerm_virtual_network_gateway.vpn_gateway.id
  description = "The ID of the VPN gateway."
}

output "vpn_gateway_ip" {
  value       = azurerm_public_ip.vpn_gateway_ip.ip_address
  description = "The public IP address of the VPN gateway."
}

output "vpn_connection_id" {
  value       = azurerm_virtual_network_gateway_connection.vpn_connection.id
  description = "The ID of the VPN connection."
}

output "local_network_gateway_id" {
  value       = azurerm_local_network_gateway.local_gateway.id
  description = "The ID of the local network gateway."
}
