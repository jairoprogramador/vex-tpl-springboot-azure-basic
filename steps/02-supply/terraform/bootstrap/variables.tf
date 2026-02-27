variable "subscription_id" {
  description = "ID de la suscripción"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Nombre del Resource Group (si vacío, se crea uno)"
  type        = string
  default     = "fastdeployrg"
}

variable "storage_account_name" {
  description = "Nombre del Storage Account (si vacío, se crea uno)"
  type        = string
  default     = "fastdeploysa"
}
variable "storage_container_name" {
  description = "Nombre del Storage Container (si vacío, se crea uno)"
  type        = string
  default     = "fastdeploysc"
}
