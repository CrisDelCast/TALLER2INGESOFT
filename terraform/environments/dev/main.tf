terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstate${var.storage_account_suffix}"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.environment}"
  location = var.location
}

# Networking
module "networking" {
  source = "../../modules/networking"

  environment        = var.environment
  resource_group_name = azurerm_resource_group.rg.name
  location           = var.location
  address_space      = var.address_space
  aks_subnet_prefix  = var.aks_subnet_prefix
  app_gateway_subnet_prefix = var.app_gateway_subnet_prefix
} 