# NSG enforces a "Deny All" policy allowing only permitted traffic
resource "azurerm_network_security_group" "nsg_vault" {
  name                = "nsg-${var.project_name}-prod"
  location            = azurerm_resource_group.rg_vault.location
  resource_group_name = azurerm_resource_group.rg_vault.name

  # Security Rule: Deny All Inbound
  # Priority 4096 is the lowest priority (last rule processed)
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
    Security    = "Strict"
    ManagedBy   = "Terraform"
  }
}

# Centralized secret management to avoid storing credentials in code
resource "azurerm_key_vault" "vault_secrets" {
  name                        = "kv-${replace(var.project_name, "-", "")}-001"
  location                    = azurerm_resource_group.rg_vault.location
  resource_group_name         = azurerm_resource_group.rg_vault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  tags = {
    Environment = var.environment
    Security    = "KeyVault"
  }
}

# Data source to retrieve current Azure Client configuration
data "azurerm_client_config" "current" {}