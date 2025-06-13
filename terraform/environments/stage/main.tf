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
    key                  = "stage.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  environment = "stage"
  location    = "Central US"
  tags = {
    environment = local.environment
    project     = "ecommerce-microservice"
  }
}

data "azurerm_client_config" "current" {}

module "resource_group" {
  source      = "../../modules/resource-group"
  name        = "rg-ecommerce-${local.environment}"
  location    = local.location
  tags        = local.tags
}

module "container_registry" {
  source              = "../../modules/acr"
  name                = "acrisd${local.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.tags
}

module "kubernetes_cluster" {
  source                = "../../modules/aks"
  name                  = "aks-cluster-${local.environment}"
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  tags                  = local.tags
  dns_prefix            = "aks-${local.environment}"
  acr_id = module.container_registry.id
}

module "postgresql_server" {
  source              = "../../modules/postgresql"
  name                = "psql-server-${local.environment}"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  tags                = local.tags
  administrator_login    = "psqladmin"
  administrator_password = "Password1234!"
}

output "postgres_server_fqdn" {
  value = module.postgresql_server.fqdn
  description = "The fully qualified domain name of the PostgreSQL server."
}
