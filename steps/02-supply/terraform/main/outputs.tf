output "azure_resource_group_name" {
  description = "Return the name of the resource group created in Azure"
  value       = azurerm_resource_group.main.name
}

output "azure_kubernetes_cluster_fqdn" {
  description = "Return the fully qualified domain name (FQDN) of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "azure_kubernetes_cluster_name" {
  description = "Return the name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}
