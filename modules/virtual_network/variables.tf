# variables for virtual network module
variable "vnet_name" {
  description = "The name of the Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Virtual Network will be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Network will be deployed"
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

