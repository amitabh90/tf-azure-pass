# ressource variables
variable "subscription_id" {
  description = "The subscription ID to use"
  type        = string
}
variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
}

variable "location" {
    description = "The location of the resource group"
    type        = string
    default     = "East US"
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}


variable "address_space" {
  description = "The address space that is used by the Virtual Network"
  type        = list(string)
}

# variable "dns_servers" {
#   description = "The list of DNS servers for the Virtual Network"
#   type        = list(string)
#   default     = []
# }

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = <<EOT
A list of subnet configurations, where each object should have the following structure:
  - name: The name of the subnet
  - address_prefix: The address prefix for the subnet
EOT
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "storage_account_name" {
  description = "The name of the storage account to be created."
  type        = string
}
variable "drupal_app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "drupal_app_name" {
  description = "The name of the Drupal App Service"
  type        = string
}
variable "node_app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
}

variable "node_app_name" {
  description = "The name of the Drupal App Service"
  type        = string
}
variable "mysql_server_name" {
  description = "Name of the MySQL Flexible Server"
  type        = string
}
variable "sku_name" {
  description = "SKU for the MySQL Flexible Server"
  type        = string
  default     = "Standard_B2ms"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
  }
variable "redis_name" {
  description = "The name of the Redis Cache instance."
  type        = string
}

variable "frontdoor_name" {
  description = "The name of the Front Door instance."
  type        = string
}

variable "front_door_sku_name" {
  description = "The SKU name for the Front Door."
  type        = string
}

variable "bastion_name" {
  description = "The name of the Bastion Host"
  type        = string
}

variable "bastion_public_ip_name" {
  description = "The name of the Public IP for the Bastion Host"
  type        = string
}

# variable "bastion_dns_name" {
#   description = "The DNS name for the Bastion Host"
#   type        = string
#   default     = null
# }