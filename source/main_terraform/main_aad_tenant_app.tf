# Configure the Microsoft Azure Active Directory Provider
provider "azuread" {
    tenant_id = "e4022446-350c-4e31-8a9e-c0e887dbe6f8"
}

# Create an application
resource "azuread_application" "example" {
  display_name               = "ExampleApp"
  homepage                   = "https://homepage"
  reply_urls                 = ["https://replyurl"]
  identifier_uris            = ["api://${var.mainAppId}"]
  available_to_other_tenants = true

  required_resource_access {
    resource_app_id = local.msgraph_resource_id

    resource_access {
      id   = local.msgraph_resource_access_id
      type = "Scope"    
    }
  }

   required_resource_access {
    resource_app_id = var.mainAppId

    resource_access {
      id   = var.app_role_id 
      type = "Role"
    }
  }

  app_role {
    allowed_member_types = [
      "Application"
    ]

    description  = "Admins can manage roles and perform all task actions"
    display_name = "call main API"
    is_enabled   = true
    value        = "consumer"
  }
}

# Create a service principal
resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}