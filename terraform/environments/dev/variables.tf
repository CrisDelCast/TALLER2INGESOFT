variable "resource_group_name" {
  description = "The name of the resource group for the dev environment."
  type        = string
  default     = "ecommerce-rg"
}

variable "location" {
  description = "The Azure region for the dev environment."
  type        = string
  default     = "eastus"
}

variable "db_location" {
  description = "The Azure region for the PostgreSQL server in dev."
  type        = string
  default     = "centralus"
}

variable "db_admin_login" {
  description = "The admin login for the PostgreSQL server in dev."
  type        = string
  default     = "psqladmin"
}

variable "db_admin_password" {
  description = "The admin password for the PostgreSQL server in dev."
  type        = string
  sensitive   = true
  # La contraseña debe ser proporcionada en un archivo .tfvars o como variable de entorno
}
