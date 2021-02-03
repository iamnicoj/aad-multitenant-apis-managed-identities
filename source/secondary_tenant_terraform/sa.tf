resource "azurerm_storage_account" "secondary_sa" {
  name                      = var.storage_account_name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.storage_account_kind
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  access_tier               = contains(["BlobStorage", "FileStorage", "StorageV2"], var.storage_account_kind) ? var.storage_account_access_tier : null
  allow_blob_public_access  = var.allow_blob_public_access
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version
  is_hns_enabled            = var.storage_account_enable_hns

  identity {
    type = "SystemAssigned"
  }
}