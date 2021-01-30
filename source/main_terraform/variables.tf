variable "mainAppId" {
  type        = string
  description = "Id for Main API - Known after first terraform apply"
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "app_role_id" {
  type        = string
  description = "Main App Role ID - Known after first terraform apply"
  default     = "00000000-0000-0000-0000-000000000000"
}
