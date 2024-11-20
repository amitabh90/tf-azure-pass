variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the storage account will be created"
  type        = string
}

variable "location" {
  description = "The Azure location where the storage account will be created"
  type        = string
}

variable "account_tier" {
  description = "The storage account's performance tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type for the storage account"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to assign to the storage account"
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

