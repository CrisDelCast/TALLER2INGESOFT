terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatecrisd01"
    container_name       = "tfstate"
    key                  = "ecommerce.tfstate"
  }
} 