variable "name" {
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

variable "administrator_login" {
  description = "The admin login for the PostgreSQL server."
  type        = string
}

variable "administrator_password" {
  description = "The admin password for the PostgreSQL server."
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
