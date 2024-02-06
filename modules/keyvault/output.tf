output "key_vault_resource_group" {
  value = azurerm_resource_group.resourcegroup_mgmnt
}

output "key_vault" {
  value = azurerm_key_vault.keyvault
}

output "key_vault_key" {
  value = azurerm_key_vault_key.keyvaultkey
}

output "key_vault_role_assignment" {
  value = azurerm_role_assignment.keyvaultroleassignment
}

output "key_vault_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.keyvault.id
}

output "key_vault_key_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault_key.keyvaultkey.id
}

