locals {
  names = {
    app_rm_acr_resource_group = "${var.azure_acr_resource_group_name}${random_id.acr_resource_group.hex}"
    app_rm_acr_name           = "${var.azure_acr_name}${random_id.acr_name.hex}"
  }
}
