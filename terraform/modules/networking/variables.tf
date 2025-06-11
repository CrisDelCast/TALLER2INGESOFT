variable "environment" {
  description = "Environment (dev/stage/prod)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
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