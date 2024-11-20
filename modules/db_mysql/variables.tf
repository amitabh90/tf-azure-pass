variable "mysql_server_name" {
  description = "Name of the MySQL Flexible Server"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku_name" {
  description = "SKU for the MySQL Flexible Server"
  type        = string
  default     = "Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
}

variable "storage_mb" {
  description = "Storage size in MB for the MySQL server"
  type        = number
  default     = 5120
}

variable "backup_retention_days" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "admin_username" {
  description = "Administrator username for the MySQL server"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the MySQL server"
  type        = string
  sensitive   = true
}

variable "create_dns_zone" {
  description = "Whether to create a new private DNS zone"
  type        = bool
  default     = false
}

variable "private_endpoint_name" {
  description = "Name of the private endpoint"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
variable "subnet_id" {
  description = "The subnet ID where the private endpoint will be placed"
  type        = string
}

variable "virtual_network_id" {
  description = "The ID of the virtual network linked to the private DNS zone"
  type        = string
}
