resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "ecommerceacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "ecommerceaks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "ecommercea-ecommerce-rg-4b6956"
  kubernetes_version  = "1.31"
  node_resource_group = "MC_ecommerce-rg_ecommerceaks_eastus"

  default_node_pool {
    name                = "nodepool1"
    node_count          = 2
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 128
    max_pods            = 250
    os_sku              = "Ubuntu"
    enable_auto_scaling = false
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_plugin_mode = "overlay"
    dns_service_ip = "10.0.0.10"
    service_cidr   = "10.0.0.0/16"
    pod_cidr       = "10.244.0.0/16"
  }

  lifecycle {
    ignore_changes = [
      linux_profile,
      default_node_pool,
      tags,
      api_server_authorized_ip_ranges,
      image_cleaner_enabled,
      image_cleaner_interval_hours,
    ]
  }
}

resource "azurerm_postgresql_flexible_server" "postgres_server" {
  name                   = "postgres-server-crisd03" # Needs to be globally unique
  resource_group_name  = azurerm_resource_group.rg.name
  location               = var.db_location
  version                = "12"
  delegated_subnet_id    = null
  private_dns_zone_id    = null
  administrator_login    = "psqladmin"
  administrator_password = "Password1234!" # Temporary password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
}

resource "azurerm_postgresql_flexible_server_database" "user_database" {
  name      = "user_db"
  server_id = azurerm_postgresql_flexible_server.postgres_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all-ips"
  server_id        = azurerm_postgresql_flexible_server.postgres_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

output "postgres_server_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres_server.fqdn
  description = "The fully qualified domain name of the PostgreSQL server."
} 