output "mysql_server_name" {
  description = "Name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql_server.name
}

output "mysql_fqdn" {
  description = "Fully Qualified Domain Name of the MySQL Flexible Server"
  value       = azurerm_mysql_flexible_server.mysql_server.fqdn
}
