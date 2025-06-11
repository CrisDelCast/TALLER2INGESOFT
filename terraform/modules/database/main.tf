# PostgreSQL Server
resource "azurerm_postgresql_server" "postgres" {
  name                = "psql-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.postgres_sku_name

  storage_mb                   = var.postgres_storage_mb
  backup_retention_days        = var.postgres_backup_retention_days
  geo_redundant_backup_enabled = var.postgres_geo_redundant_backup
  auto_grow_enabled           = true

  administrator_login          = var.postgres_admin_username
  administrator_login_password = var.postgres_admin_password
  version                     = var.postgres_version
  ssl_enforcement_enabled     = true

  tags = var.tags
}

# PostgreSQL Database
resource "azurerm_postgresql_database" "postgres_db" {
  name                = var.postgres_database_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation          = "English_United States.1252"
}

# PostgreSQL Firewall Rule
resource "azurerm_postgresql_firewall_rule" "postgres_fw" {
  name                = "allow-aks-subnet"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres.name
  start_ip_address    = var.aks_subnet_start_ip
  end_ip_address      = var.aks_subnet_end_ip
}

# Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = "redis-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.redis_capacity
  family              = var.redis_family
  sku_name            = var.redis_sku_name
  enable_non_ssl_port = false
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_reserved = 50
    maxmemory_delta    = 50
    maxmemory_policy   = "volatile-lru"
  }

  tags = var.tags
}

# Redis Firewall Rule
resource "azurerm_redis_firewall_rule" "redis_fw" {
  name                = "allow-aks-subnet"
  redis_cache_name    = azurerm_redis_cache.redis.name
  resource_group_name = var.resource_group_name
  start_ip            = var.aks_subnet_start_ip
  end_ip              = var.aks_subnet_end_ip
}

# Key Vault para almacenar secretos
resource "azurerm_key_vault" "kv" {
  name                = "kv-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = true

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]
  }

  tags = var.tags
}

# Secretos en Key Vault
resource "azurerm_key_vault_secret" "postgres_connection_string" {
  name         = "postgres-connection-string"
  value        = "Server=${azurerm_postgresql_server.postgres.fqdn};Database=${azurerm_postgresql_database.postgres_db.name};Port=5432;User Id=${var.postgres_admin_username}@${azurerm_postgresql_server.postgres.name};Password=${var.postgres_admin_password};Ssl Mode=Require;"
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "redis-connection-string"
  value        = azurerm_redis_cache.redis.primary_connection_string
  key_vault_id = azurerm_key_vault.kv.id
} 