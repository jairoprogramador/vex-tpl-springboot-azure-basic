resource "random_id" "random_rg_name" {
  keepers = {
    value = var.resource_group_name
  }
  byte_length = 4
}

resource "random_id" "random_sa_name" {
  keepers = {
    value = var.storage_account_name
  }
  byte_length = 4
}

resource "random_id" "random_sc_name" {
  keepers = {
    value = var.storage_container_name
  }
  byte_length = 4
}

resource "azurerm_resource_group" "tf_state_rg" {
  name     = "${var.resource_group_name}${random_id.random_rg_name.hex}"
  location = var.location
  tags = {
    environment = "staging"
    author = "fastdeploy"
  }
}

resource "azurerm_storage_account" "tf_state_sa" {
  name                     = "${var.storage_account_name}${random_id.random_sa_name.hex}"
  resource_group_name      = azurerm_resource_group.tf_state_rg.name
  location                 = azurerm_resource_group.tf_state_rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "staging"
    author = "fastdeploy"
  }
}

resource "azurerm_storage_container" "tf_state_sc" {
  name                  = "${var.storage_container_name}${random_id.random_sc_name.hex}"
  storage_account_id    = azurerm_storage_account.tf_state_sa.id
  container_access_type = "private"
}
