# NSG enforces a default-deny policy on both directions,
# with narrow, explicit allow rules for required traffic only.
resource "azurerm_network_security_group" "nsg_vault" {
  name                = "nsg-${var.project_name}-prod"
  location            = azurerm_resource_group.rg_vault.location
  resource_group_name = azurerm_resource_group.rg_vault.name

  # --- INBOUND ---

  # Explicit allow: HTTPS only, from anywhere (adjust source for real workloads)
  security_rule {
    name                       = "AllowHttpsInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Deny All Inbound (lowest priority = evaluated last, catches everything else)
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

  # --- OUTBOUND ---
  # Azure allows all outbound by default unless explicitly restricted.
  # A "hardened" posture must lock this down too, not just inbound.

  # Explicit allow: HTTPS out (for Azure API calls, package registries, etc.)
  security_rule {
    name                       = "AllowHttpsOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Deny All Outbound (catches everything not explicitly allowed above)
  security_rule {
    name                       = "DenyAllOutbound"
    priority                   = 4096
    direction                  = "Outbound"
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

  # Changed from false -> true: without this, anyone with delete
  # permission can permanently destroy the vault and its secrets
  # before the soft-delete window expires. Non-negotiable for anything
  # claiming to be "hardened" or handling regulated (FinTech) data.
  purge_protection_enabled = true

  sku_name = "standard"

  # RBAC-based access control (modern approach, preferred over
  # legacy access_policy blocks). Requires enable_rbac_authorization.
  enable_rbac_authorization = true

  tags = {
    Environment = var.environment
    Security    = "KeyVault"
  }
}

# Grant the deploying identity (e.g., CI service principal, or you
# during manual apply) permission to manage secrets. Without this,
# the Key Vault exists but nothing -- including you -- can read or
# write secrets to it.
resource "azurerm_role_assignment" "kv_secrets_officer" {
  scope                = azurerm_key_vault.vault_secrets.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Data source to retrieve current Azure Client configuration
data "azurerm_client_config" "current" {}
