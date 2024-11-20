variable "name" {
  description = "The name of the Front Door instance."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the Front Door will be created."
  type        = string
}

variable "location" {
  description = "The location/region where the Front Door will be created."
  type        = string
}

variable "app_service_hostname" {
  description = "The hostname of the App Service to be used as the backend pool."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the Private Endpoint will be created."
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network where the private endpoint resides."
  type        = string
}

variable "front_door_sku_name" {
  description = "The SKU name for the Front Door."
  type        = string
}
variable "app_service_id" {
  description = "The ID of the App Service."
  type        = string
}
