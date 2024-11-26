variable "resource_group_name" {
  description = "The name of the Resource Group for the Bastion Host"
  type        = string
}

variable "location" {
  description = "The Azure location for resources"
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

variable "bastion_dns_name" {
  description = "The DNS name for the Bastion Host"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The ID of the Subnet for the Bastion Host"
  type        = string
}
