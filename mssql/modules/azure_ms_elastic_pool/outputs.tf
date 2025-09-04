output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "sql_server_name" {
  value = azurerm_sql_server.server.name
}

output "elastic_pool_id" {
  value = azurerm_mssql_elasticpool.pool.id
}

output "db_names" {
  value = [for db in azurerm_mssql_database.dbs : db.name]
}

output "admin_password_secret_id" {
  value = azurerm_key_vault_secret.sql_password.id
}

