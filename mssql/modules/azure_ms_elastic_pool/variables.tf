variable "location" { type = string }
variable "prefix" { type = string }
variable "tags" { type = map(string) }

variable "admin_username" { type = string }

variable "elasticpool_sku_name" { type = string }
variable "elasticpool_tier" { type = string }
variable "elasticpool_family" { type = string }
variable "elasticpool_capacity" { type = number }
variable "databases" { type = list(string) } // Names for 3 DBs

