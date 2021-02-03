
# General
variable "resource_group_name" {
  description = "The resource group where the resources should be created."
}

variable "location" {
  default     = "eastus2"
  description = "The azure datacenter location where the resources should be created."
}

# Storage Account
variable "storage_account_name" {
  description = "Storage Account Name"
}

variable "storage_account_kind" {
  description = "https://www.terraform.io/docs/providers/azurerm/r/storage_account.html#account_kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_tier" {
  description = "Storage account tier: Standard or Premium."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Type of replication to use for this storage account. LRS, GRS, RAGRS or ZRS."
  type        = string
  default     = "LRS"
}

variable "storage_account_access_tier" {
  description = "Access tier for BlobStorage, FileStorage and StorageV2"
  type        = string
  default     = "Hot"
}

variable "allow_blob_public_access" {
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  type        = bool
  default     = false
}

variable enable_https_traffic_only {
  description = "Allow or disallow https access to all blobs or containers in the storage account."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "Minimum TLS version required to connect"
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_enable_hns" {
  description = "Enable hierarchical namespace for Azure Data Lake Storage Gen 2"
  type        = bool
  default     = true
}

# App Service Plan Variables
variable "secondary_app_service_plan_name"{
    description = "App Service Plan name"
}

variable azure_insights_name{
    description = "App Insights name"
}

#Resource Deployment Properties
variable "labels_context" {
  description = "label module context"
  type        = string
}

variable "azure_function_name" {
  description = "The name for the function app. Without environment naming."
}

variable "auth_enabled_flag" {
  default     = false
  description = "The Auth Settings flag that tells whether the particular block is enabled or not"
}

variable "auth_client_id" {
  default     = ""
  description = "Client Id used for Authorizing Active Directory Tokens"
}

variable "auth_issuer" {
  default     = "https://sts.windows.net/00000000000000000000000/"
  description = "The issuer of the AD Tenant."
}

variable "auth_allowed_audiences" {
  default     = null
  type        = list(string)
  description = "Allowed Audiences for the specified Azure AD Application"
}

variable "token_store_enabled" {
  default     = false
  type        = string
  description = "Token store enabled flag"
}

variable "unauthenticated_client_action" {
  default     = "RedirectToLoginPage"
  type        = string
  description = "Action to define when token in unauthorized"
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "Azure Resource Tags"
}

#Resource Instance Properties

variable "app_settings" {
  default     = {}
  type        = map(string)
  description = "Application settings to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}

variable "always_on" {
  default     = false
  type        = string
  description = "Site Config to insert on creating the function app. Following updates will be ignored, and has to be set manually. Updates done on application deploy or in portal will not affect terraform state file."
}

variable "connection_string" {
  default     = {}
  type        = map(string)
  description = "A block containing connection string definitions, see https://www.terraform.io/docs/providers/azurerm/r/function_app.html#connection_string"

}

variable "runtime_version" {
  description = ""
  default     = "~3"
}

variable "os_type" {
  description = ""
  default     = "linux"
}
