resource "azurerm_private_endpoint" "keyvault" {
  name                = "keyvault-${terraform.workspace}-weu-pe"
  location            = azurerm_key_vault.main.location
  resource_group_name = azurerm_key_vault.main.resource_group_name
  subnet_id           = azurerm_subnet.keyvault_pe.id

  private_service_connection {
    name                           = "keyvault-connection"
    private_connection_resource_id = azurerm_key_vault.main.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.keyvault.id,
    ]
  }

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_endpoint" "cosmosdb" {
  name                = "cosmosdb-${terraform.workspace}-weu-pe"
  location            = azurerm_cosmosdb_account.main.location
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name
  subnet_id           = azurerm_subnet.cosmosdb_pe.id

  private_service_connection {
    name                           = "cosmosdb-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.main.id
    is_manual_connection           = false
    subresource_names              = ["Sql"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.cosmosdb.id,
    ]
  }

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_endpoint" "sqlserver" {
  name                = "sqlserver-${terraform.workspace}-weu-pe"
  location            = azurerm_mssql_server.main.location
  resource_group_name = azurerm_mssql_server.main.resource_group_name
  subnet_id           = azurerm_subnet.sql_server_pe.id

  private_service_connection {
    name                           = "sqlserver-connection"
    private_connection_resource_id = azurerm_mssql_server.main.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.sqlserver.id,
    ]
  }

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_zone" "keyvault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_key_vault.main.resource_group_name

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_zone" "cosmosdb" {
  name                = "privatelink.documents.azure.com"
  resource_group_name = azurerm_cosmosdb_account.main.resource_group_name

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_zone" "sqlserver" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_mssql_server.main.resource_group_name

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  name                  = "keyvault-dns-link"
  resource_group_name   = azurerm_key_vault.main.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "cosmosdb" {
  name                  = "cosmosdb-dns-link"
  resource_group_name   = azurerm_cosmosdb_account.main.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.cosmosdb.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_zone_virtual_network_link" "sqlserver" {
  name                  = "sqlserver-dns-link"
  resource_group_name   = azurerm_mssql_server.main.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sqlserver.name
  virtual_network_id    = azurerm_virtual_network.main.id

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_a_record" "keyvault" {
  name                = "privatelink-vault"
  zone_name           = azurerm_private_dns_zone.keyvault.name
  resource_group_name = azurerm_private_dns_zone.keyvault.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.keyvault.private_service_connection[0].private_ip_address]

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_a_record" "cosmosdb" {
  name                = "privatelink-documents"
  zone_name           = azurerm_private_dns_zone.cosmosdb.name
  resource_group_name = azurerm_private_dns_zone.cosmosdb.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.cosmosdb.private_service_connection[0].private_ip_address]

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}

resource "azurerm_private_dns_a_record" "sqlserver" {
  name                = "privatelink-sqlserver"
  zone_name           = azurerm_private_dns_zone.sqlserver.name
  resource_group_name = azurerm_private_dns_zone.sqlserver.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.sqlserver.private_service_connection[0].private_ip_address]

  tags = merge(var.default_tags, {
    "env" = terraform.workspace
  })
}
