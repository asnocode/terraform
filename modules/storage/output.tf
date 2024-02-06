output "storage_account" {
  value = azurerm_storage_account.storageaccount
}

output "id" {
  value       = azurerm_storage_account.storageaccount.id
  description = "The ID of the Storage Account."
}

output "primary_access_key" {
  value       = azurerm_storage_account.storageaccount.primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account."
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.storageaccount.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}

output "principal_id" {
  value       = azurerm_storage_account.storageaccount.identity.0.principal_id
  description = "The Principal ID for the Service Principal associated with the Identity of this Storage Account."
}

output "storage_container"{
    value = azurerm_storage_container.container
}

/*
output "container_name"{
    value = azurerm_storage_container.container.name
}
*/



