# Create service bus instance
resource "azurerm_servicebus_namespace" "svc_bus" {
  name                			= var.service_bus_name
  location            			= data.azurerm_resource_group.rg.location
  resource_group_name 			= data.azurerm_resource_group.rg.name
  sku                 			= var.service_bus_sku
  minimum_tls_version 			= 1.2
  capacity 						= var.service_bus_capacity
  premium_messaging_partitions 	= var.service_bus_capacity

  local_auth_enabled			= true

  tags     			  			= merge(var.tags, {
    environment = var.environment
    data-classification = "internal"
  })
}

# Create queue
resource "azurerm_servicebus_queue" "queue_svc_bus" {
  name         = var.service_bus_queue_name
  namespace_id = azurerm_servicebus_namespace.svc_bus.id

  requires_session = true
}

resource "azurerm_servicebus_queue_authorization_rule" "queue_authorization_rule" {
  name     = "examplequeuerule"
  queue_id = azurerm_servicebus_queue.queue_svc_bus.id

  listen = true
  send   = true
  manage = false
}

output "bus_namespaces_details" {
  value = {
    id   = azurerm_servicebus_namespace.svc_bus.id
    name = azurerm_servicebus_namespace.svc_bus.name
  }
  description = "A map of the created Service Bus Namespace objects, providing each namespace's ID and name."
}


resource "azurerm_servicebus_namespace_network_rule_set" "svc_bus_network_rule" {
  namespace_id = azurerm_servicebus_namespace.svc_bus.id

  default_action                = "Deny"
  virtual_network_subnet_ids = [azurerm_subnet.az_func_subnet_int.id]
}