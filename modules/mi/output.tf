output "managed_instance" {
  value = azurerm_mssql_managed_instance.managedinstance
}

output "principal_id" {
  value       = azurerm_mssql_managed_instance.managedinstance.identity.0.principal_id
  description = "The Principal ID for the Service Principal associated with the Identity of this MI."
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

