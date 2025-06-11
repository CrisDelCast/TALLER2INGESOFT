output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.id
}

output "log_analytics_workspace_key" {
  description = "Primary shared key for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.law.primary_shared_key
  sensitive   = true
}

output "application_insights_id" {
  description = "ID of the Application Insights instance"
  value       = azurerm_application_insights.appinsights.id
}

output "application_insights_instrumentation_key" {
  description = "Instrumentation key for Application Insights"
  value       = azurerm_application_insights.appinsights.instrumentation_key
  sensitive   = true
}

output "grafana_workspace_id" {
  description = "ID of the Grafana workspace"
  value       = azurerm_dashboard_grafana.grafana.id
}

output "grafana_endpoint" {
  description = "Endpoint of the Grafana workspace"
  value       = azurerm_dashboard_grafana.grafana.endpoint
}

output "action_group_id" {
  description = "ID of the action group"
  value       = azurerm_monitor_action_group.action_group.id
}

output "dashboard_id" {
  description = "ID of the Kubernetes dashboard"
  value       = azurerm_portal_dashboard.k8s_dashboard.id
} 