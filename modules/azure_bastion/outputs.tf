output "bastion_host_id" {
  description = "The ID of the Bastion Host"
  value       = azurerm_bastion_host.bastion.id
}

output "bastion_host_public_ip" {
  description = "The Public IP address of the Bastion Host"
  value       = azurerm_public_ip.bastion_pip.ip_address
}
