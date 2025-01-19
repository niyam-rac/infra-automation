################################################ local variables ##################################################
locals {
  keyvaultPrivilegedPermissions = {
    keys         = (var.envKey == "dev" || var.envKey == "sit") ? local.keyvaultAccessPolicies.keys.ReadWrite : ((var.envKey == "uat") ? local.keyvaultAccessPolicies.keys.ReadOnly : [])
    certificates = (var.envKey == "dev" || var.envKey == "sit") ? local.keyvaultAccessPolicies.certificates.ReadWrite : ((var.envKey == "uat") ? local.keyvaultAccessPolicies.certificates.ReadOnly : [])
    secrets      = (var.envKey == "dev" || var.envKey == "sit") ? local.keyvaultAccessPolicies.secrets.ReadWrite : ((var.envKey == "uat") ? local.keyvaultAccessPolicies.secrets.ReadOnly : [])
  }
}

################################################ existing resources ###############################################

data "azurerm_client_config" "current" {}

data "azuread_group" "insOperationsAdmin" {
  display_name = "Role-IT-Insurance-Operations-Admin"
}

data "azuread_group" "insDevelopersAdmin" {
  display_name = "Role-IT-Insurance-Developers-Admin"
}

data "azuread_group" "insTestersAdmin" {
  display_name = "Role-IT-Insurance-Testers-Admin"
}

data "azuread_group" "insPipelineServicePrincipals" {
  display_name = "Role-Azure-INS-Pipeline-ServicePrincipals-${upper(var.pipelineSpEnvKey)}"
}

data "azuread_service_principal" "appManagedIdentity" {
  display_name = var.appIdentityName
}

data "azuread_service_principal" "apimManagedIdentity" {
  display_name = var.apimName
}

data "azuread_service_principal" "githubActionsIdentity" {
  display_name = var.githubActionsIdentityName
}

############################################ resources to be deployed #############################################

# Ignore Codacy `keyvault-specify-network-acl` until we are able to deploy from pipeline to VNet
# eg. after https://docs.github.com/en/enterprise-cloud@latest/admin/configuration/configuring-private-networking-for-hosted-compute-products/about-using-github-hosted-runners-in-your-azure-virtual-network
# nosemgrep
resource "azurerm_key_vault" "keyvault" {
  resource_group_name             = var.resourceGroupName
  location                        = var.location
  name                            = var.keyvaultName
  tags                            = var.tags
  sku_name                        = var.keyVaultSkuName
  enabled_for_template_deployment = true
  enabled_for_deployment          = true
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled        = true

  network_acls {
    #tfsec:ignore:AZU020 #Deny actions block MS hosted agents, and by extension Terraform, from accessing the keyvault
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyInsOperations" {
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_group.insOperationsAdmin.object_id
  key_permissions         = local.keyvaultAccessPolicies.keys.FullAccess
  secret_permissions      = local.keyvaultAccessPolicies.secrets.FullAccess
  certificate_permissions = local.keyvaultAccessPolicies.certificates.FullAccess
}

resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyInsPipelineServicePrincipals" {
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_group.insPipelineServicePrincipals.object_id
  key_permissions         = local.keyvaultAccessPolicies.keys.ReadWrite
  secret_permissions      = local.keyvaultAccessPolicies.secrets.ReadWrite
  certificate_permissions = local.keyvaultAccessPolicies.certificates.ReadWrite
}

resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyInsDevelopers" {
  count                   = (var.envKey != "prd") ? 1 : 0
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_group.insDevelopersAdmin.object_id
  key_permissions         = local.keyvaultPrivilegedPermissions.keys
  secret_permissions      = local.keyvaultPrivilegedPermissions.secrets
  certificate_permissions = local.keyvaultPrivilegedPermissions.certificates
}

resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyInsTesters" {
  count                   = (var.envKey != "prd") ? 1 : 0
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_group.insTestersAdmin.object_id
  key_permissions         = local.keyvaultPrivilegedPermissions.keys
  secret_permissions      = local.keyvaultPrivilegedPermissions.secrets
  certificate_permissions = local.keyvaultPrivilegedPermissions.certificates
}

# The app identity always has the read only access on all environments
# Required for the app configuration key vault references
resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyAppIdentity" {
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_service_principal.appManagedIdentity.object_id
  key_permissions         = local.keyvaultAccessPolicies.keys.ReadOnly
  secret_permissions      = local.keyvaultAccessPolicies.secrets.ReadOnly
  certificate_permissions = local.keyvaultAccessPolicies.certificates.ReadOnly
}

resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyApimManagedIdentity" {
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_service_principal.apimManagedIdentity.object_id
  key_permissions         = local.keyvaultAccessPolicies.keys.ReadOnly
  secret_permissions      = local.keyvaultAccessPolicies.secrets.ReadOnly
  certificate_permissions = local.keyvaultAccessPolicies.certificates.ReadOnly
}

resource "azurerm_key_vault_access_policy" "keyvaultAccessPolicyGitHubActionsIdentity" {
  key_vault_id            = azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = data.azuread_service_principal.githubActionsIdentity.object_id
  key_permissions         = local.keyvaultAccessPolicies.keys.ReadWrite
  secret_permissions      = local.keyvaultAccessPolicies.secrets.ReadWrite
  certificate_permissions = local.keyvaultAccessPolicies.certificates.ReadWrite
}
