output "id" {
  description = "Azure Function ID"
  value       = azurerm_function_app.this.id
}

output "name" {
  description = "Azure Function name"
  value       = module.labels.id_with_suffix.func
}

output "kv_name" {
  description = "Azure Function Name"
  value       = module.labels.id_with_suffix.func
}

output "identity" {
  description = "Managed Service Identity information for this App Service"
  value       = azurerm_function_app.this.identity[0]
}

