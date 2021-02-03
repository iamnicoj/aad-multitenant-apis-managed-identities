# Configure the Azure Provider
provider "azurerm" {
    features {}
}

# Create a resource group
resource "azurerm_resource_group" "primary_arg" {
  name     = var.resource_group_name 
  location = var.location
}

resource "azurerm_storage_account" "primary_sa" {
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

resource "azurerm_app_service_plan" "primary_app_service_plan" {
  name                = var.primary_app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.primary_arg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_application_insights" "insights" {
  name                = var.azure_insights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.primary_arg.name
  application_type    = "web"
}

resource "azurerm_app_service" "this" {
  name                = var.azure_app_service_name
  location            = var.location
  resource_group_name = azurerm_resource_group.primary_arg.name
  app_service_plan_id = azurerm_app_service_plan.primary_app_service_plan.id

  site_config {
    dotnet_framework_version = "v4.0"
    linux_fx_version         = "DOTNETCORE|3.1"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}

resource "azurerm_function_app" "this" {
  name                       = var.azure_function_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.primary_arg.name
  app_service_plan_id        = azurerm_app_service_plan.primary_app_service_plan.id
  client_affinity_enabled    = false
  storage_account_name       = azurerm_storage_account.primary_sa.name
  storage_account_access_key = azurerm_storage_account.primary_sa.primary_access_key 
  https_only                 = true
  enabled                    = true
  os_type                    = var.os_type
  version                    = var.runtime_version
  daily_memory_time_quota    = 0

  identity {
    type = "SystemAssigned"
  }

  app_settings = merge(var.app_settings, {
    # App Insights
    APPINSIGHTS_INSTRUMENTATIONKEY        = azurerm_application_insights.insights.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING = "InstrumentationKey=${azurerm_application_insights.insights.instrumentation_key}"
  })

  auth_settings {
    enabled = var.auth_enabled_flag
    dynamic "active_directory" {
      for_each = var.auth_client_id != "" ? ["this"] : []
      content {
        client_id         = var.auth_client_id
        allowed_audiences = var.auth_allowed_audiences
      }
    }
    issuer                        = var.auth_issuer
    token_store_enabled           = var.token_store_enabled
    unauthenticated_client_action = var.unauthenticated_client_action
  }


  site_config {
    always_on = var.always_on
  }

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["MSDEPLOY_RENAME_LOCKED_FILES"],
      app_settings["FUNCTIONS_WORKER_RUNTIME"],
      app_settings["WEBSITES_ENABLE_APP_SERVICE_STORAGE"],
      app_settings["WEBSITE_ENABLE_SYNC_UPDATE_SITE"],
      site_config["remote_debugging_enabled"],
      site_config["remote_debugging_version"],
      site_config["scm_type"],
      source_control,
      id,
    ]
  }
}
