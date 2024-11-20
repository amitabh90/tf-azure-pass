output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  description = "The location of the Virtual Network"
  value       = azurerm_virtual_network.vnet.location
}

#subnet outputs
output "subnet_ids" {
  description = "The IDs of the Subnets"
  value       = azurerm_subnet.subnet[*].id
}

output "subnet_names" {
  description = "The names of the Subnets"
  value       = azurerm_subnet.subnet[*].name
}