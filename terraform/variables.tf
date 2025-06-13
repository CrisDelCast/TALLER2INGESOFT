variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default     = "ecommerce-rg"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
  default     = "East US"
} 