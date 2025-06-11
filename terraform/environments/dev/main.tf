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

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
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

# Kubernetes
module "kubernetes" {
  source = "../../modules/kubernetes"

  environment        = var.environment
  location           = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id          = module.networking.aks_subnet_id
  vnet_id            = module.networking.vnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  
  kubernetes_version = var.kubernetes_version
  node_count         = var.node_count
  vm_size            = var.vm_size
  enable_auto_scaling = var.enable_auto_scaling
  min_count          = var.min_count
  max_count          = var.max_count
  
  service_cidr       = var.service_cidr
  dns_service_ip     = var.dns_service_ip
  docker_bridge_cidr = var.docker_bridge_cidr
  
  tags = var.tags
}

# Database
module "database" {
  source = "../../modules/database"

  environment        = var.environment
  location           = var.location
  resource_group_name = azurerm_resource_group.rg.name

  # PostgreSQL configuration
  postgres_sku_name            = var.postgres_sku_name
  postgres_storage_mb          = var.postgres_storage_mb
  postgres_backup_retention_days = var.postgres_backup_retention_days
  postgres_geo_redundant_backup = var.postgres_geo_redundant_backup
  postgres_admin_username      = var.postgres_admin_username
  postgres_admin_password      = var.postgres_admin_password
  postgres_version            = var.postgres_version
  postgres_database_name      = var.postgres_database_name

  # Redis configuration
  redis_capacity = var.redis_capacity
  redis_family   = var.redis_family
  redis_sku_name = var.redis_sku_name

  # Network configuration
  aks_subnet_start_ip = var.aks_subnet_start_ip
  aks_subnet_end_ip   = var.aks_subnet_end_ip

  # Key Vault configuration
  tenant_id = var.tenant_id
  object_id = var.object_id

  tags = var.tags
} 