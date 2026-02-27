resource "random_id" "resource_group" {
  keepers = {
    value = var.azure_resource_group_name
  }
  byte_length = 4
}

resource "random_id" "kubernetes_cluster" {
  keepers = {
    value = var.azure_kubernetes_cluster_name
  }
  byte_length = 4
}

resource "random_id" "dns_prefix" {
  keepers = {
    value = var.azure_dns_prefix_aks
  }
  byte_length = 4
}

resource "random_id" "active_directory" {
  keepers = {
    value = var.azure_ad_group_name
  }
  byte_length = 4
}

