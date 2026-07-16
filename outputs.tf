output "resource_group_name" {
  description = "The name of the deployed Resource Group"
  value       = azurerm_resource_group.rg_vault.name
}

output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.vnet_vault.id
}