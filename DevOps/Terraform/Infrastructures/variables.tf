variable "environment" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "az_function_storage_account_name" {
  type = string
  default = ""
}

variable "azurerm_windows_function_app_name" {
  type = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {
    app-name = "Example Az Function"
  }
}

variable "pv_endpoint_name" {
  type = string
  default = ""
}
variable "az_function_pv_svc_connection" {
  type = string
  default = ""
}

variable "az_function_private_dns_zone_group" {
  type = string
  default = ""
}

variable "service_bus_name" {
  type = string
  default = ""
}

variable "service_bus_queue_name" {
  type = string
  default = "example-az"
  description = "Queue Name of Service Bus using Azure Function"
}

variable "service_bus_sku" {
  type = string
  default = ""
}

variable "service_bus_capacity" {
  type = number
  default = 0
  description = "Service Bus Capacity of Azure Function"
}