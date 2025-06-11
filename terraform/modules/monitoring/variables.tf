variable "environment" {
  description = "Environment name (dev/stage/prod)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "aks_cluster_id" {
  description = "ID of the AKS cluster"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 