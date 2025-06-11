# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "appinsights-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
  tags                = var.tags
}

# Grafana Workspace
resource "azurerm_dashboard_grafana" "grafana" {
  name                = "grafana-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Grafana Data Source - Azure Monitor
resource "azurerm_dashboard_grafana_data_source" "azure_monitor" {
  name                = "Azure Monitor"
  grafana_workspace_id = azurerm_dashboard_grafana.grafana.id
  type                = "grafana-azure-monitor-datasource"
  json_data_encoded   = jsonencode({
    subscriptionId = var.subscription_id
    cloudName      = "azuremonitor"
    azureLogAnalyticsSameAs = true
  })
}

# Grafana Data Source - Log Analytics
resource "azurerm_dashboard_grafana_data_source" "log_analytics" {
  name                = "Log Analytics"
  grafana_workspace_id = azurerm_dashboard_grafana.grafana.id
  type                = "grafana-azure-log-analytics-datasource"
  json_data_encoded   = jsonencode({
    subscriptionId = var.subscription_id
    logAnalyticsDefaultWorkspace = azurerm_log_analytics_workspace.law.workspace_id
  })
}

# Action Group para alertas
resource "azurerm_monitor_action_group" "action_group" {
  name                = "ag-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = "ag-${var.environment}"

  email_receiver {
    name                    = "sendtoadmin"
    email_address          = var.alert_email
    use_common_alert_schema = true
  }
}

# Alertas de CPU
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "cpu-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Alerta cuando el uso de CPU es alto"
  severity            = 1

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

# Alertas de Memoria
resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = "memory-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Alerta cuando el uso de memoria es alto"
  severity            = 1

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_memory_working_set_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

# Alertas de Disponibilidad
resource "azurerm_monitor_metric_alert" "availability_alert" {
  name                = "availability-alert-${var.environment}"
  resource_group_name = var.resource_group_name
  scopes              = [var.aks_cluster_id]
  description         = "Alerta cuando la disponibilidad es baja"
  severity            = 1

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_ready"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1
  }

  action {
    action_group_id = azurerm_monitor_action_group.action_group.id
  }
}

# Dashboard de Kubernetes
resource "azurerm_portal_dashboard" "k8s_dashboard" {
  name                = "k8s-dashboard-${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dashboard_properties = jsonencode({
    "lenses" = {
      "0" = {
        "order" = 0,
        "parts" = {
          "0" = {
            "position" = {
              "x" = 0,
              "y" = 0,
              "colSpan" = 6,
              "rowSpan" = 4
            },
            "metadata" = {
              "inputs" = [],
              "type" = "Extension/HubsExtension/PartType/MarkdownPart",
              "settings" = {
                "content" = {
                  "settings" = {
                    "content" = "# Kubernetes Dashboard\n\nEste dashboard muestra las métricas principales del cluster AKS.",
                    "title" = "Kubernetes Overview",
                    "subtitle" = ""
                  }
                }
              }
            }
          }
        }
      }
    }
  })
} 