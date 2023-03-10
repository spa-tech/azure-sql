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
  name                         = var.mssql_server_name
  resource_group_name          = azurerm_resource_group.azure_sql.name
  location                     = azurerm_resource_group.azure_sql.location
  version                      = "12.0"
  administrator_login          = var.admin_login_username
  administrator_login_password = var.admin_login_password
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = var.azuread_admin_login_username
    object_id      = var.azuread_admin_login_object_id
  }

  tags = {
    environment = "production"
  }
}
resource "azurerm_mssql_firewall_rule" "example" {
  name             = "FirewallRule1"
  server_id        = azurerm_mssql_server.server1.id
  start_ip_address = var.mssql_firewall_rule_start_ip
  end_ip_address   = var.mssql_firewall_rule_end_ip
}
resource "azurerm_mssql_database" "emaildb" {
  name                        = "emaildb"
  server_id                   = azurerm_mssql_server.server1.id
  sku_name                    = "GP_S_Gen5_1"
  min_capacity                = "0.5"
  auto_pause_delay_in_minutes = "60"
}
