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

module "drupal_app_service" {
  source                  = "../../modules/drupal_app_service"
  drupal_app_service_plan_name = var.drupal_app_service_plan_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  drupal_app_name             = var.drupal_app_name
  php_version                 = "PHP|8.1"
  database_url                = "mysql://username:password@mysqlserver/database"
  drupal_env                  = "staging"
  tags                        = var.tags
  sku_tier          = "Standard"
  sku_size          = "S1"
  subnet_id               = module.vnet.subnet_ids[1]
  virtual_network_id      = module.vnet.vnet_id
  private_endpoint_name = "drupal-private-endpoint"
}

data "azurerm_private_dns_zone" "existing_dns_zone" {
  name                = "privatelink.azurewebsites.net"  # Existing DNS zone name
  resource_group_name = var.resource_group_name         # Resource group containing the DNS zone
}
module "node_app_service" {
  source                  = "../../modules/node_app_service"
  node_app_service_plan_name = var.node_app_service_plan_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  node_app_name             = var.node_app_name
  node_env                     = "staging"
  tags                        = var.tags
  sku_tier          = "Standard"
  sku_size          = "S1"
  subnet_id               = module.vnet.subnet_ids[1]
  virtual_network_id      = module.vnet.vnet_id
  private_endpoint_name = "node-private-endpoint"
  dns_zone_name = data.azurerm_private_dns_zone.existing_dns_zone.name
}

module "db_mysql" {
  source = "../../modules/db_mysql"
  mysql_server_name   = var.mysql_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = "mysqladmin"
  admin_password      = "MyStrongPassword123!"
  mysql_version       = var.mysql_version
  subnet_id           = module.vnet.subnet_ids[2]
  virtual_network_id  = module.vnet.vnet_id
  private_endpoint_name = "mysql-private-endpoint"
  tags = var.tags
}