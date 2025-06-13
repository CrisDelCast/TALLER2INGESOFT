resource "azurerm_postgresql_flexible_server" "postgres_server" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "12"
  delegated_subnet_id    = null
  private_dns_zone_id    = null
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "B_Standard_B1ms"
  tags                   = var.tags

  lifecycle {
    ignore_changes = [
      administrator_password,
    ]
  }
}

resource "azurerm_postgresql_flexible_server_database" "user_database" {
  name      = "user_db"
  server_id = azurerm_postgresql_flexible_server.postgres_server.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow-all-ips"
  server_id        = azurerm_postgresql_flexible_server.postgres_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
