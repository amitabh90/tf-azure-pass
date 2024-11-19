variable "drupal_app_service_plan_name" {
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

variable "drupal_app_name" {
  description = "The name of the Drupal App Service"
  type        = string
}

variable "php_version" {
  description = "The PHP version to use for the App Service"
  type        = string
  default     = "PHP|8.1"
}

variable "database_url" {
  description = "The database connection URL for the Drupal app"
  type        = string
}

variable "drupal_env" {
  description = "Environment variable for Drupal (e.g., production, staging)"
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
