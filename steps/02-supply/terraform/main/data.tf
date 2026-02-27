data "azuread_client_config" "current" {}

data "azurerm_container_registry" "main" {
  name                = var.azure_container_registry_name
  resource_group_name = var.azure_container_registry_rg
}