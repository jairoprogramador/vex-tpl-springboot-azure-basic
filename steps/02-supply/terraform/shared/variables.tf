/*VARIABLES OPCIONALES*/
variable "azure_acr_resource_group_name" {
  description = "Define the name of the Resource Group for the Azure Container Registry (ACR)"
  type        = string
  default     = "vexacrrg"
}

variable "azure_acr_name" {
  description = "Define the name of the Azure Container Registry"
  type        = string
  default     = "vexacr"
}

variable "azure_key_vault_name" {
  description = "Define the base name of the Key Vault that stores the Docker Hub credentials for the ACR cache (a random suffix is appended)"
  type        = string
  default     = "vexkv"
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

variable "azure_resource_tags" {
  description = "Define the common tags applied to all Azure resources"
  type        = map(string)
  default     = {
    owner        = "vex@vex.com"
    cost_center  = "vex"
    compliance   = "RGPD is example"
    create_by    = "vex"
    lifecycle    = "ephemeral"
  }
}

variable "dockerhub_username" {
  description = "Docker Hub username of the Vex-owned puller account, used by the ACR cache credential set to authenticate base-image pulls"
  type        = string
  sensitive   = true
}

variable "dockerhub_token" {
  description = "Docker Hub access token (read-only) paired with dockerhub_username for the ACR cache credential set"
  type        = string
  sensitive   = true
}
