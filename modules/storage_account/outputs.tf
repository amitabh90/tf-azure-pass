output "storage_account_id" {
  description = "The ID of the created storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "private_endpoint_id" {
  description = "The ID of the created private endpoint"
  value       = azurerm_private_endpoint.storage_account.id
}
