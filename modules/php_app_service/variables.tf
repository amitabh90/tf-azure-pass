variable "php_app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "php_web_app_name" {
  description = "The name of the Web App"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the app service will be created"
  type        = string
}

variable "location" {
  description = "The Azure location where the resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the private endpoint"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network linked to the private DNS zone"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}
