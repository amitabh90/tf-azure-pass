variable "name" {
  description = "The name of the Redis Cache instance."
  type        = string
}

variable "location" {
  description = "The location/region where the Redis Cache instance is created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Redis Cache instance is created."
  type        = string
}

variable "capacity" {
  description = "The size of the Redis Cache instance. Values are 0 for C0 (Basic), 1 for C1, etc."
  type        = number
}

variable "family" {
  description = "The SKU family to use. Possible values are 'C' for Basic/Standard and 'P' for Premium."
  type        = string
}

variable "sku_name" {
  description = "The type of Redis Cache to deploy. Options are Basic, Standard, and Premium."
  type        = string
}

variable "enable_non_ssl_port" {
  description = "Specifies whether the non-SSL Redis server port is enabled."
  type        = bool
  default     = false
}

variable "redis_configuration" {
  description = "A map of Redis settings to configure."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "virtual_network_id" {
  description = "The ID of the virtual network to link the private DNS zone to."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet for the private endpoint."
  type        = string
}
