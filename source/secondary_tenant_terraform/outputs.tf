# output "azure_function_id" {
#   description = "Azure Function ID"
#   value       = azurerm_function_app.this.id
# }

# output "azure_function_name" {
#   description = "Azure Function name"
#   value       = azurerm_function_app.this.name
# }

# output "azurerm_function_app.this.identity" {
#   description = "Managed Service Identity information for this App Service"
#   value       = azurerm_function_app.this.identity[0]
# }

output "storage_account_access_key" {
    value = azurerm_storage_account.secondary_sa.primary_access_key  
}