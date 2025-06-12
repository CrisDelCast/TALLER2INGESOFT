output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_name" {
  description = "Nombre de la Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_name" {
  description = "Nombre de la Subnet"
  value       = azurerm_subnet.subnet.name
}

output "nsg_name" {
  description = "Nombre del Network Security Group"
  value       = azurerm_network_security_group.nsg.name
} 