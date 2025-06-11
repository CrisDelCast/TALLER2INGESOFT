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

# PostgreSQL variables
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

# Redis variables
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

# Network variables
variable "aks_subnet_start_ip" {
  description = "Start IP address for AKS subnet"
  type        = string
}

variable "aks_subnet_end_ip" {
  description = "End IP address for AKS subnet"
  type        = string
}

# Key Vault variables
variable "tenant_id" {
  description = "Azure AD tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user/service principal"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 