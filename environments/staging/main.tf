# create the resource group from module
module "rg" {
  source = "../../modules/resource_group"
  resource_group_name = var.resource_group_name
  location = var.location
}