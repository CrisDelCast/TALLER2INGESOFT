output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "kube_config_raw" {
  description = "Raw Kubernetes config"
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive   = true
}

output "cluster_identity" {
  description = "Identity of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.identity
}

output "user_assigned_identity_id" {
  description = "ID of the user assigned identity"
  value       = azurerm_user_assigned_identity.aks_identity.id
}

output "node_resource_group" {
  description = "Resource group where the nodes are deployed"
  value       = azurerm_kubernetes_cluster.aks.node_resource_group
} 