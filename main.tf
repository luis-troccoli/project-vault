# Azure provider config
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      # Ensures Terraform can still purge in dev/test cycles even with
      # purge protection enabled at the resource level (see security.tf)
      purge_soft_delete_on_destroy = true
    }
  }
  # NOTE: skip_provider_registration should only be true when the
  # executing identity lacks Owner/Contributor at the subscription level
  # (common in CI service principals with scoped permissions).
  # It does NOT mean this can run without credentials -- a valid
  # azurerm auth (OIDC, SP, or CLI login) is still required for plan/apply.
  skip_provider_registration = true
}

# Resource Group
resource "azurerm_resource_group" "rg_vault" {
  name     = "rg-fintech-${replace(lower(var.project_name), "-", "")}-${lower(var.environment)}"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Virtual Network
resource "azurerm_virtual_network" "vnet_vault" {
  name                = "vnet-${lower(var.project_name)}-001"
  location            = azurerm_resource_group.rg_vault.location
  resource_group_name = azurerm_resource_group.rg_vault.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet with NSG association
resource "azurerm_subnet" "subnet_vault" {
  name                 = "snet-vault-001"
  resource_group_name  = azurerm_resource_group.rg_vault.name
  virtual_network_name = azurerm_virtual_network.vnet_vault.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Link the NSG to the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_link" {
  subnet_id                 = azurerm_subnet.subnet_vault.id
  network_security_group_id = azurerm_network_security_group.nsg_vault.id
}
