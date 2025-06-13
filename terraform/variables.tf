variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default     = "ecommerce-rg"
}

variable "location" {
  type        = string
  description = "The Azure region for the main resources."
  default     = "East US"
}

variable "db_location" {
  type        = string
  description = "The Azure region for the database resources."
  default     = "Central US"
} 