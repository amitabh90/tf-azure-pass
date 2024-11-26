# virtual network with four subnets
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  #dns_servers         = var.dns_servers

  tags = var.tags
}

# create subnets in the virtual network
resource "azurerm_subnet" "subnet" {
  count               = length(var.subnets)
  name                = var.subnets[count.index].name
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnets[count.index].address_prefix]
}



