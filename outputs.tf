output "resource_group_name" {
  description = "The name of the deployed Resource Group"
  value       = azurerm_resource_group.rg_vault.name
}

output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.vnet_vault.id
}

output "key_vault_uri" {
  description = "URI of the deployed Key Vault"
  value       = azurerm_key_vault.vault_secrets.vault_uri
}
