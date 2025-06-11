variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "storage_account_suffix" {
  description = "Suffix for the storage account name"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_prefix" {
  description = "Address prefix for AKS subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "app_gateway_subnet_prefix" {
  description = "Address prefix for Application Gateway subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# Kubernetes variables
variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.26.3"
}

variable "node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "Size of the VM for the nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "enable_auto_scaling" {
  description = "Enable auto scaling for the default node pool"
  type        = bool
  default     = true
}

variable "min_count" {
  description = "Minimum number of nodes for auto scaling"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum number of nodes for auto scaling"
  type        = number
  default     = 3
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "CIDR for Docker bridge"
  type        = string
  default     = "172.17.0.1/16"
}

# Database variables
variable "postgres_sku_name" {
  description = "SKU name for PostgreSQL server"
  type        = string
  default     = "GP_Gen5_2"
}

variable "postgres_storage_mb" {
  description = "Storage size in MB for PostgreSQL server"
  type        = number
  default     = 51200
}

variable "postgres_backup_retention_days" {
  description = "Backup retention days for PostgreSQL server"
  type        = number
  default     = 7
}

variable "postgres_geo_redundant_backup" {
  description = "Enable geo-redundant backups for PostgreSQL server"
  type        = bool
  default     = false
}

variable "postgres_admin_username" {
  description = "Administrator username for PostgreSQL server"
  type        = string
  default     = "psqladmin"
}

variable "postgres_admin_password" {
  description = "Administrator password for PostgreSQL server"
  type        = string
  sensitive   = true
}

variable "postgres_version" {
  description = "PostgreSQL server version"
  type        = string
  default     = "11"
}

variable "postgres_database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "ecommerce"
}

variable "redis_capacity" {
  description = "Capacity of Redis cache"
  type        = number
  default     = 1
}

variable "redis_family" {
  description = "Family of Redis cache"
  type        = string
  default     = "C"
}

variable "redis_sku_name" {
  description = "SKU name for Redis cache"
  type        = string
  default     = "Standard"
}

variable "aks_subnet_start_ip" {
  description = "Start IP address for AKS subnet"
  type        = string
  default     = "10.0.1.0"
}

variable "aks_subnet_end_ip" {
  description = "End IP address for AKS subnet"
  type        = string
  default     = "10.0.1.255"
}

variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user/service principal"
  type        = string
}

# Monitoring variables
variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "ecommerce"
  }
} 