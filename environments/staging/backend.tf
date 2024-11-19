# generate terraform backend configuration
# terraform {
#   backend "azurerm" {
#     resource_group_name   = "tf-azure-pass-rg"
#     storage_account_name  = "tfazurepassstaging"
#     container_name        = "tfstate"
#     key                   = "terraform.tfstate"
#   }
# }

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}
