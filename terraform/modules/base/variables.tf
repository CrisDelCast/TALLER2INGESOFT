variable "environment" {
  description = "Nombre del ambiente (dev, stage, prod)"
  type        = string
}

variable "location" {
  description = "Región de Azure donde se desplegarán los recursos"
  type        = string
  default     = "eastus"
}

variable "address_space" {
  description = "Espacio de direcciones para la VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Prefijo de direcciones para la subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "tags" {
  description = "Tags para los recursos"
  type        = map(string)
  default     = {}
} 