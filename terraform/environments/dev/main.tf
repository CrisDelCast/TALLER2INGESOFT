terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatecrisd01"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  environment = "dev"
  location    = "eastus"
  tags = {
    environment = local.environment
    project     = "ecommerce-microservice"
  }
}

module "resource_group" {
  source      = "../../modules/resource-group"
  name        = "ecommerce-rg"
  location    = local.location
  tags        = local.tags
}

module "container_registry" {
  source              = "../../modules/acr"
  name                = "ecommerceacr"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.tags
}

module "kubernetes_cluster" {
  source                = "../../modules/aks"
  name                  = "ecommerceaks"
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  tags                  = local.tags
  dns_prefix            = "aks-dev"
  acr_id                = module.container_registry.id
}

module "postgresql_server" {
  source                 = "../../modules/postgresql"
  name                   = "postgres-server-crisd03"
  resource_group_name    = module.resource_group.name
  location               = "centralus"
  tags                   = local.tags
  administrator_login    = "psqladmin"
  administrator_password = "Password1234!"
}

output "postgres_server_fqdn" {
  value = module.postgresql_server.fqdn
}
