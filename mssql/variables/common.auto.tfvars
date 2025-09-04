location       = "East US"
prefix         = "nprd"
tags = {
  Environment = "nprd"
  Project     = "sql-elasticpool"
}
admin_username           = "sqladmin"
elasticpool_sku_name     = "GP_Gen5"
elasticpool_tier         = "GeneralPurpose"
elasticpool_family       = "Gen5"
elasticpool_capacity     = 2
databases                = ["db1", "db2", "db3"]

