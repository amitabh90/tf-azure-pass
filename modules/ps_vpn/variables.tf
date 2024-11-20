variable "resource_group_name" {
  type        = string
  description = "The name of the Azure resource group."
}

variable "location" {
  type        = string
  description = "The location/region of the Azure resource group."
}

variable "vpn_gateway_ip_name" {
  type        = string
  description = "The name of the public IP for the VPN gateway."
}

variable "vpn_gateway_name" {
  type        = string
  description = "The name of the VPN gateway."
}

variable "vpn_connection_name" {
  type        = string
  description = "The name of the VPN connection."
}

variable "local_network_gateway_name" {
  type        = string
  description = "The name of the local network gateway (on-premises gateway)."
}

variable "onprem_public_ip" {
  type        = string
  description = "The public IP address of the on-premises VPN gateway."
}

variable "onprem_address_space" {
  type        = list(string)
  description = "The address space of the on-premises network."
  default     = ["192.168.0.0/16"]
}

variable "shared_key" {
  type        = string
  description = "The shared key for the IPsec VPN connection."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the VPN gateway will be deployed."
}


