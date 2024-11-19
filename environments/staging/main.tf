# create the resource group from module
module "rg" {
  source = "../../modules/resource_group"
  resource_group_name = var.resource_group_name
  location = var.location
}
# create the virtual network from module
module "vnet" {
  source = "../../modules/virtual_network"
  resource_group_name = var.resource_group_name
  location = var.location
  vnet_name = var.vnet_name
  address_space = var.address_space
  dns_servers = var.dns_servers
  tags = var.tags
  subnets = var.subnets
}

module "storage_account" {
  source                  = "../../modules/storage_account"
  storage_account_name    = var.storage_account_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                    = var.tags
  subnet_id               = module.vnet.subnet_ids[5]
  virtual_network_id      = module.vnet.vnet_id
}

module "app_service_php" {
  source                  = "../../modules/php_app_service"
  php_app_service_plan_name = var.php_app_service_plan_name
  php_web_app_name          = var.php_web_app_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  subnet_id               = module.vnet.subnet_ids[1]
  virtual_network_id      = module.vnet.vnet_id
  tags                    = var.tags
}