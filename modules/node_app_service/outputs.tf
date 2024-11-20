
output "node_app_url" {
  description = "The private endpoint URL of the Drupal app"
  value       = azurerm_app_service.node_app.default_site_hostname
}

output "private_endpoint_ip" {
  description = "The private IP address of the App Service Private Endpoint"
  value       = azurerm_private_endpoint.node_private_endpoint.private_service_connection.0.private_ip_address
}

output "node_app_service_id" {
  description = "The ID of the App Service"
  value       = azurerm_app_service.node_app.id
}