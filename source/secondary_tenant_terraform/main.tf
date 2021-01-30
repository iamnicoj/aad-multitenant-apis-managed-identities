


resource "azurerm_function_app" "this" {
  name                       = module.labels.id_with_suffix.func
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  client_affinity_enabled    = false
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
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
    APPINSIGHTS_INSTRUMENTATIONKEY        = var.app_insights
    APPLICATIONINSIGHTS_CONNECTION_STRING = "InstrumentationKey=${var.app_insights}"
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

  tags = module.labels.tags
}
