resource "random_id" "acr_resource_group" {
  keepers = {
    value = var.azure_acr_resource_group_name
  }
  byte_length = 4
}

resource "random_id" "acr_name" {
  keepers = {
    value = var.azure_acr_name
  }
  byte_length = 8
}

resource "random_id" "key_vault" {
  keepers = {
    value = var.azure_key_vault_name
  }
  byte_length = 8
}


