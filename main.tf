terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "azure_sql" {
  name     = "azure-sql-terraform"
  location = "East US 2"
}

resource "azurerm_mssql_server" "server1" {
  name                         = "stmssqlserver1"
  resource_group_name          = azurerm_resource_group.azure_sql.name
  location                     = azurerm_resource_group.azure_sql.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "jaspangler"
    object_id      = "57a280ce-45bd-4d44-84c0-c731c5194dbf"
  }

  tags = {
    environment = "production"
  }
}
resource "azurerm_mssql_database" "emaildb" {
  name           = "emaildb"
  server_id      = azurerm_mssql_server.server1.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    foo = "bar"
  }
}
