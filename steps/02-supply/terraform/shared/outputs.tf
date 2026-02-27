output "azure_container_registry_rg" {
  description = "Return the name of the Resource Group for the Azure Container Registry (ACR)"
  value       = azurerm_resource_group.main.name
}

output "azure_container_registry_name" {
  description = "Return the name of the Azure Container Registry (ACR) created"
  value       = azurerm_container_registry.main.name
}

output "azure_container_registry_login_server" {
  description = "Return the domain of the login server of the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}
