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
}

# Resource Group para el estado de Terraform
resource "azurerm_resource_group" "rg" {
  name     = "terraform-state-rg"
  location = "eastus"
}

# Storage Account para el estado de Terraform
resource "azurerm_storage_account" "sa" {
  name                     = "tfstate${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Container para el estado de Terraform
resource "azurerm_storage_container" "sc" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

# String aleatorio para el nombre de la storage account
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
} 