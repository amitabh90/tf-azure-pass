# variables for the virtual network module
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}
variable "vnet_address_space" {
  description = "Address space of the virtual network"
  type        = list(string)
}
variable "vnet_dns_servers" {
  description = "DNS servers of the virtual network"
  type        = list(string)
}
variable "subnet_names" {
  description = "Names of the subnets"
  type        = list(string)
}
variable "subnet_address_prefixes" {
  description = "Address prefixes of the subnets"
  type        = list(string)
}
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
variable "location" {
  description = "Location of the resource group"
  type        = string
}
variable "tags" {
  description = "Tags of the resource group"
  type        = map(string)
}

