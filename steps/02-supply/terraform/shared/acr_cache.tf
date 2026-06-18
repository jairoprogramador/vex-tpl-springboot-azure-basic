# ACR Cache (pull-through) autenticado contra Docker Hub.
#
# Evita el rate limit anónimo de Docker Hub ("toomanyrequests: You have reached your
# unauthenticated pull rate limit") durante `az acr build`, cacheando las imágenes base
# en el propio ACR y autenticando el pull con una cuenta Docker Hub propiedad de la
# plataforma Vex.
resource "azurerm_key_vault" "acr_cache" {
  name                       = local.names.app_kv_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false # infra efímera: permitir purgar y recrear con el mismo nombre
  soft_delete_retention_days = 7
  tags                       = var.azure_resource_tags
}

# El service principal que ejecuta Terraform necesita poder escribir los secretos.
resource "azurerm_key_vault_access_policy" "deployer" {
  key_vault_id = azurerm_key_vault.acr_cache.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = ["Get", "Set", "Purge", "Recover"]
}

resource "azurerm_key_vault_secret" "dockerhub_username" {
  name         = "dockerhub-username"
  value        = var.dockerhub_username
  key_vault_id = azurerm_key_vault.acr_cache.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

resource "azurerm_key_vault_secret" "dockerhub_token" {
  name         = "dockerhub-token"
  value        = var.dockerhub_token
  key_vault_id = azurerm_key_vault.acr_cache.id

  depends_on = [azurerm_key_vault_access_policy.deployer]
}

# Credential set: identidad administrada del ACR que apunta a los secretos del Key Vault.
resource "azurerm_container_registry_credential_set" "dockerhub" {
  name                  = "dockerhub"
  container_registry_id = azurerm_container_registry.main.id
  login_server          = "docker.io"

  identity {
    type = "SystemAssigned"
  }

  authentication_credentials {
    username_secret_id = azurerm_key_vault_secret.dockerhub_username.versionless_id
    password_secret_id = azurerm_key_vault_secret.dockerhub_token.versionless_id
  }
}

# La identidad del credential set debe poder LEER los secretos en tiempo de pull.
resource "azurerm_key_vault_access_policy" "credential_set" {
  key_vault_id = azurerm_key_vault.acr_cache.id
  tenant_id    = azurerm_container_registry_credential_set.dockerhub.identity[0].tenant_id
  object_id    = azurerm_container_registry_credential_set.dockerhub.identity[0].principal_id

  secret_permissions = ["Get"]
}

# Regla de caché: cualquier imagen oficial de Docker Hub (docker.io/library/*) se sirve
# desde el ACR como library/* y se baja autenticada vía el credential set.
resource "azurerm_container_registry_cache_rule" "dockerhub_library" {
  name                  = "dockerhub-library"
  container_registry_id = azurerm_container_registry.main.id
  source_repo           = "docker.io/library/*"
  target_repo           = "library/*"
  credential_set_id     = azurerm_container_registry_credential_set.dockerhub.id

  depends_on = [azurerm_key_vault_access_policy.credential_set]
}
