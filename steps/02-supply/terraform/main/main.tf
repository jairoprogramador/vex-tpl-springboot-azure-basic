resource "azurerm_resource_group" "main" {
  name     = "${local.names_rm.resource_group}"
  location = var.azure_location
  tags     = local.tags
}

resource "azuread_group" "main" {
  display_name     = "${local.names_ad.user_group}"
  security_enabled = true
  members = [
    data.azuread_client_config.current.object_id
  ]
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${local.names_rm.kubernetes_cluster}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.prefix.app_dns_prefix_aks}"

  node_resource_group = "${azurerm_resource_group.main.name}nodes"

  default_node_pool {
    name       = "default"
    node_count = var.azure_kubernetes_cluster_node_count
    vm_size    = var.azure_kubernetes_cluster_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  local_account_disabled = true
  azure_policy_enabled = true

  azure_active_directory_role_based_access_control {
    tenant_id = data.azuread_client_config.current.tenant_id
    azure_rbac_enabled = true
    admin_group_object_ids = [azuread_group.main.object_id]
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "sp_aks_admin_role" {
  scope                = azurerm_kubernetes_cluster.main.id
  role_definition_name = "Azure Kubernetes Service Cluster Admin Role"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_role_assignment" "aks_acr_pull_permissions" {
  scope                = data.azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
