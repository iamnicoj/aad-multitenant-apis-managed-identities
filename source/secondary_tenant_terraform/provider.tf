# Configure the Azure Provider
provider "azurerm" {
    features {}
}

# Create a resource group
resource "azurerm_resource_group" "secondary_arg" {
  name     = var.resource_group_name 
  location = var.location
}