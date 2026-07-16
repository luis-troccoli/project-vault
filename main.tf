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
  features {}
  # Allows pipeline to run without credentials
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