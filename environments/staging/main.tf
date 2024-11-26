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
  #dns_servers = var.dns_servers
  tags = var.tags
  subnets = var.subnets
  depends_on = [ module.rg ]
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
  depends_on = [ module.vnet, module.rg ]
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
  depends_on = [ module.rg, module.vnet, module.storage_account ]
}

data "azurerm_private_dns_zone" "existing_dns_zone" {
  name                = "privatelink.azurewebsites.net"  # Existing DNS zone name
  resource_group_name = var.resource_group_name         # Resource group containing the DNS zone

  depends_on = [ module.drupal_app_service ]
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
  depends_on = [ module.rg, module.vnet, module.storage_account ]
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
  depends_on = [ module.vnet, module.rg ]
}

module "redis" {
  source              = "../../modules/db_redis"
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity             = 2
  family               = "C"
  sku_name             = "Standard"
  enable_non_ssl_port = false
  virtual_network_id  = module.vnet.vnet_id
  subnet_id           = module.vnet.subnet_ids[2]
  tags = var.tags
  depends_on = [ module.vnet, module.rg ]
}

module "frontdoor" {
  source              = "../../modules/lb_frontdoor"
  name                = var.frontdoor_name
  resource_group_name = var.resource_group_name
  location = var.location
  virtual_network_id  = module.vnet.vnet_id
  subnet_id           = module.vnet.subnet_ids[0]
  app_service_hostname = module.node_app_service.node_app_url
  front_door_sku_name = var.front_door_sku_name
  app_service_id      = module.node_app_service.node_app_service_id
  depends_on = [ module.vnet, module.rg, module.node_app_service ]
}

# module "vpn_gateway" {
#   source              = "../../modules/ps_vpn"
#   resource_group_name = var.resource_group_name
#   location = var.location
#   vpn_gateway_name    = "site-vpn-gateway"
#   vpn_gateway_ip_name = "vpn-public-ip"
#   vpn_connection_name = "my-vpn-connection"
#   local_network_gateway_name = "onprem-vpn-gateway"
#   onprem_public_ip     = "198.51.100.1"
#   onprem_address_space = ["192.168.0.0/16"]
#   shared_key           = "MySharedSecretKey"
#   subnet_id           = module.vnet.subnet_ids[6]
#   depends_on = [ module.vnet, module.rg ]
# }


module "bastion" {
  source                 = "../../modules/azure_bastion"
  resource_group_name    = var.resource_group_name
  location               = var.location
  subnet_id              = module.vnet.subnet_ids[3]
  bastion_name           = var.bastion_name
  bastion_public_ip_name = var.bastion_public_ip_name
  #bastion_dns_name       = var.bastion_dns_name
  depends_on = [ module.rg, module.vnet ]
}