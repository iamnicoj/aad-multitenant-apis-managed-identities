
resource "azurerm_app_service_plan" "secondary_app_service_plan" {
  name                = var.secondary_app_service_plan_name
  location            = var.location
  resource_group_name = azurerm_resource_group.secondary_arg.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_application_insights" "insights" {
  name                = var.azure_insights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.secondary_arg.name
  application_type    = "web"
}

resource "azurerm_function_app" "this" {
  name                       = var.azure_function_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.secondary_arg.name
  app_service_plan_id        = azurerm_app_service_plan.secondary_app_service_plan.id
  client_affinity_enabled    = false
  storage_account_name       = azurerm_storage_account.secondary_sa.name
  storage_account_access_key = azurerm_storage_account.secondary_sa.primary_access_key 
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
