output "postgres_server_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = azurerm_postgresql_server.postgres.fqdn
}

output "postgres_database_name" {
  description = "Name of the PostgreSQL database"
  value       = azurerm_postgresql_database.postgres_db.name
}

output "redis_hostname" {
  description = "Hostname of the Redis cache"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_ssl_port" {
  description = "SSL port of the Redis cache"
  value       = azurerm_redis_cache.redis.ssl_port
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.kv.id
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "postgres_connection_string_secret_id" {
  description = "ID of the PostgreSQL connection string secret"
  value       = azurerm_key_vault_secret.postgres_connection_string.id
}

output "redis_connection_string_secret_id" {
  description = "ID of the Redis connection string secret"
  value       = azurerm_key_vault_secret.redis_connection_string.id
} 