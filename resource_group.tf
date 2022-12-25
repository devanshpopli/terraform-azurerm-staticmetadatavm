resource "azurerm_resource_group" "app_grp"{
  name = var.rg_name
  location = var.location
}