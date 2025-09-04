provider "azurerm" {
  features {}
}

resource "random_password" "admin" {
  length      = 20
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

resource "azurerm_sql_server" "server" {
  name                         = "${var.prefix}-sqlsrv"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  administrator_login          = var.admin_username
  administrator_login_password = local.password
  version                      = "12.0"
}

resource "azurerm_mssql_elasticpool" "pool" {
  name                = "${var.prefix}-ep"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  server_name         = azurerm_sql_server.server.name

  sku {
    name     = var.elasticpool_sku_name
    tier     = var.elasticpool_tier
    family   = var.elasticpool_family
    capacity = var.elasticpool_capacity
  }
}

resource "azurerm_mssql_database" "dbs" {
  for_each            = toset(var.databases)
  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.server.name
  elastic_pool_id     = azurerm_mssql_elasticpool.pool.id
}

# Networking: VNet, Subnet, Private DNS, VNet Links, Private Endpoints
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "pe_subnet" {
  name                                         = "pe-subnet"
  resource_group_name                          = azurerm_resource_group.rg.name
  virtual_network_name                         = azurerm_virtual_network.vnet.name
  address_prefixes                             = ["10.0.1.0/24"]
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql_link" {
  name                  = "${var.prefix}-dns-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "sql_pe" {
  name                = "${var.prefix}-sql-pe"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "sql-conn"
    private_connection_resource_id = azurerm_sql_server.server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }
}

# Key Vault, Secret, and RBAC for copying password
resource "azurerm_key_vault" "kv" {
  name                        = "${var.prefix}-kv"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = ["get", "set", "list"]
  }
}

resource "azurerm_key_vault_secret" "sql_password" {
  name         = "sql-admin-password"
  key_vault_id = azurerm_key_vault.kv.id
  value        = local.password
}

