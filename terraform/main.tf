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