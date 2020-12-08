# AAD-Multitenant-APIs-w-Managed-Identities
This project includes a working example on how to setup and run a service to service authentication using OAuth v2 client credential flow, on a multi-tenant set up without the need to share any client secret, but using Managed Identities in Azure.

## Content
* Preconditions
* Multitenant SetUp
** Create main App in Tenant A
** Authorized main App in Tenant B
* Terraform Deployments enabling MI
* Java Code to get MI Access token
