resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = "1.31"
  node_resource_group = "MC_${var.resource_group_name}_${var.name}_${var.location}"

  default_node_pool {
    name                = "nodepool1"
    node_count          = 2
    vm_size             = "Standard_B2s"
    os_disk_size_gb     = 128
    max_pods            = 250
    os_sku              = "Ubuntu"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_plugin_mode = "overlay"
  }

  lifecycle {
    ignore_changes = [
      linux_profile,
      default_node_pool,
      tags,
      image_cleaner_enabled,
      image_cleaner_interval_hours,
    ]
  }
}
