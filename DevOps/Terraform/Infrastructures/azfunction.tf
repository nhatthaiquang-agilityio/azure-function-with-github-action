# Azure Storage
resource "azurerm_storage_account" "example" {
  name                     = "${var.az_function_storage_account_name}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags     			  			= merge(var.tags, {
    environment = var.environment
  })

  network_rules {
    default_action             = "Deny"
    bypass                     = ["AzureServices"]
    virtual_network_subnet_ids = [azurerm_subnet.az_func_subnet_int.id]
  }
}

resource "azurerm_application_insights" "application_insights" {
  name                = "application-insights"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  application_type    = "web"
}

# Azure Service Plan
resource "azurerm_service_plan" "example" {
  name                = "rk-app-service-plan01"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Windows"
  # Windows Premium Plan
  sku_name            = "P1v2"
}

# Azure Function
resource "azurerm_windows_function_app" "example_az_func" {
  name                = "${var.azurerm_windows_function_app_name}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  storage_account_name = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  service_plan_id      = azurerm_service_plan.example.id

  # Virtual network configuration
  virtual_network_subnet_id = azurerm_subnet.az_func_subnet_int.id

  public_network_access_enabled = false

  app_settings = {
    "WEBSITE_RUN_FROM_PACKAGE" = 1
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet-isolated",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.application_insights.instrumentation_key,
  }

  site_config {
  }
}


# Create private DNS zones based on the service domains.
resource "azurerm_private_dns_zone" "pdnszone_az_func" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Private Endpoint for Azure Function
resource "azurerm_private_endpoint" "pv_endpoint_example_az_func" {
  name                = var.pv_endpoint_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.az_func_subnet_pe.id

  tags     			  			= merge(var.tags, {
    environment = var.environment
  })

  private_service_connection {
    name                           = var.az_function_pv_svc_connection
    private_connection_resource_id = azurerm_windows_function_app.example_az_func.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "dns-az-func"
    private_dns_zone_ids = [azurerm_private_dns_zone.pdnszone_az_func.id]
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_lnk_az_func" {
  name                  = "lnk-dns-vnet-az-func"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pdnszone_az_func.name
  virtual_network_id    = azurerm_virtual_network.az_func_network.id
}

resource "azurerm_private_dns_a_record" "dns_a_sta" {
  name                = "a-record-az-func"
  zone_name           = azurerm_private_dns_zone.pdnszone_az_func.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pv_endpoint_example_az_func.private_service_connection.0.private_ip_address]
}