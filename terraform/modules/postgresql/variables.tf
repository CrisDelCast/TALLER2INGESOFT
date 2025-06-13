variable "server_name" {
  description = "The name of the PostgreSQL server."
  type        = string
}

variable "location" {
  description = "The Azure region for the PostgreSQL server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the PostgreSQL server."
  type        = string
}

variable "db_name" {
  description = "The name of the database to create."
  type        = string
}

variable "admin_login" {
  description = "The admin login for the PostgreSQL server."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the PostgreSQL server."
  type        = string
  sensitive   = true
}
