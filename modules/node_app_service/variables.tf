variable "node_app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "location" {
  description = "The location/region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "node_app_name" {
  description = "The name of the Node.js App Service"
  type        = string
}

variable "node_env" {
  description = "Environment variable for Node.js (e.g., production, staging)"
  type        = string
  default     = "production"
}

variable "tags" {
  description = "Tags to associate with the resources"
  type        = map(string)
  default     = {}
}

variable "sku_tier" {
  description = "The pricing tier for the App Service Plan"
  type        = string
  default     = "Standard"
}

variable "sku_size" {
  description = "The size of the App Service Plan"
  type        = string
  default     = "S1"
}

variable "private_endpoint_name" {
  description = "The name of the private endpoint for the App Service"
  type        = string
}
variable "subnet_id" {
  description = "The subnet ID where the private endpoint will be placed"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network linked to the private DNS zone"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the private DNS zone"
  type        = string
}