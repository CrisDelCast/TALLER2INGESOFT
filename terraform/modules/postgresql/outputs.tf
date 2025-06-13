output "fqdn" {
  description = "The fully qualified domain name of the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.postgres_server.fqdn
}
