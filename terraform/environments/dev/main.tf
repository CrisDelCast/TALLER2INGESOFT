terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatecrisd01"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

module "rg" {
  source   = "../../modules/resource-group"
  name     = var.resource_group_name
  location = var.location
}

module "acr" {
  source              = "../../modules/acr"
  name                = "ecommerceacr"
  resource_group_name = module.rg.name
  location            = module.rg.location
}

module "aks" {
  source              = "../../modules/aks"
  name                = "ecommerceaks"
  location            = module.rg.location
  resource_group_name = module.rg.name
  dns_prefix          = "ecommercea-ecommerce-rg-4b6956"
}

module "postgresql" {
  source              = "../../modules/postgresql"
  server_name         = "postgres-server-crisd03"
  location            = var.db_location
  resource_group_name = module.rg.name
  db_name             = "user_db"
  admin_login         = var.db_admin_login
  admin_password      = var.db_admin_password
}

output "postgres_server_fqdn" {
  value = module.postgresql.fqdn
  description = "The fully qualified domain name of the PostgreSQL server."
}
