resource "azurerm_resource_group" "main" {
  name     = "${local.names.app_rm_acr_resource_group}"
  location = var.azure_location
  tags     = var.azure_resource_tags
}

resource "azurerm_container_registry" "main" {
  name                = "${local.names.app_rm_acr_name}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = false
  tags                = var.azure_resource_tags
  
  lifecycle {
    ignore_changes = [name] 
  }
}

resource "azurerm_role_assignment" "acr_push_permissions" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_role_assignment" "acr_pull_permissions" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = data.azuread_client_config.current.object_id
}