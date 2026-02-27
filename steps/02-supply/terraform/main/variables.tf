/*VARIABLES OBLIGATORIAS*/
variable "app_environment" {
  description = "Define the environment of the deployment (sand, stag, prod)"
  type        = string
}

variable "app_project_name" {
  description = "Define the name of the project"
  type = string
  validation {
    condition = length(var.app_project_name) > 0
    error_message = "The project name cannot be empty"
  }
}

variable "app_team_name" {
  description = "Define the name of the team responsible for the project"
  type = string
  validation {
    condition = length(var.app_team_name) > 0
    error_message = "The team name cannot be empty"
  }
}

variable "azure_container_registry_rg" {
  description = "Define the name of the Resource Group for the Azure Container Registry"
  type        = string
  validation {
    condition = length(var.azure_container_registry_rg) > 0
    error_message = "The container registry resource group name cannot be empty"
  }
}

variable "azure_container_registry_name" {
  description = "Define the name of the Azure Container Registry"
  type        = string
  validation {
    condition = length(var.azure_container_registry_name) > 0
    error_message = "The container registry name cannot be empty"
  }
}

variable "azure_container_registry_login_server" {
  description = "Define the domain of the login server of the Azure Container Registry"
  type        = string
  validation {
    condition = length(var.azure_container_registry_login_server) > 0
    error_message = "The container registry login server cannot be empty"
  }
}

/*VARIABLES OPCIONALES*/
variable "azure_resource_tags" {
  description = "Define the common tags applied to all Azure resources"
  type        = map(string)
  default     = {
    owner        = "fastdeploy@fastdeploy.com"
    cost_center  = "fastdeploy"
    compliance   = "RGPD is example"
    create_by    = "fastdeploy"
    lifecycle    = "ephemeral"
  }
}

variable "azure_location" {
  description = "Define the region of Azure where the resources will be deployed"
  type        = string
  default     = "eastus"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.azure_location))
    error_message = "The location must contain only lowercase letters, numbers and hyphens."
  }
}

variable "azure_resource_group_name" {
  description = "Define the name of the Azure resource group"
  type        = string
  default     = "vexrgn"
}

variable "azure_ad_group_name" {
  description = "Define the name of the Group in Azure Entra ID"
  type        = string
  default     = "vexadg"
}

variable "azure_kubernetes_cluster_name" {
  description = "Define the name of the Azure Kubernetes Service (AKS) cluster"
  type        = string
  default     = "vexkcn"
}

variable "azure_kubernetes_cluster_node_count" {
  description = "Define the initial number of nodes in the default pool of the AKS cluster"
  type        = number
  default     = 1
  validation {
    condition     = var.azure_kubernetes_cluster_node_count >= 1 && var.azure_kubernetes_cluster_node_count <= 100
    error_message = "The number of nodes must be between 1 and 100."
  }
}

variable "azure_kubernetes_cluster_vm_size" {
  description = "Define the size of the virtual machines for the nodes of the AKS cluster"
  type        = string
  default     = "standard_a2_v2"
}

variable "azure_dns_prefix_aks" {
  description = "Define the DNS prefix for the Azure Kubernetes Service cluster"
  type        = string
  default     = "vexdns"
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.azure_dns_prefix_aks))
    error_message = "The DNS prefix must contain only lowercase letters, numbers and hyphens."
  }

}
