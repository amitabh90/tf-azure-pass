output "redis_hostname" {
  description = "The hostname of the Redis Cache instance."
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_primary_key" {
  description = "The primary access key for the Redis Cache instance."
  value       = azurerm_redis_cache.redis.primary_access_key
}

output "private_endpoint_ip" {
  description = "The private IP address of the Redis Private Endpoint."
  value       = azurerm_private_endpoint.redis_endpoint.private_service_connection.0.private_ip_address
}
