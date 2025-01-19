################################################ local variables ##################################################
locals {
  # UserAssigned will always enabled for the authentication of key vault access
  outboundIdentityType           = var.outboundIdentityType == "SystemAssigned" ? "SystemAssigned, UserAssigned" : "UserAssigned"
  outboundUserIdentityResourceId = "/subscriptions/${var.outboundIdentitySubscriptionId}/resourceGroups/${var.outboundIdentityResourceGroup}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${var.outboundIdentityName}"
  inboundAuthAppId               = length(var.inboundAuthIdentityName) > 0 ? data.azuread_service_principal.inboundUserManagedIdentity[0].client_id : var.inboundAuthIdentityAppId
}

################################################ existing resources ###############################################

data "azuread_service_principal" "inboundUserManagedIdentity" {
  count        = length(var.inboundAuthIdentityName) > 0 ? 1 : 0
  display_name = var.inboundAuthIdentityName
}

data "azuread_service_principal" "outboundUserManagedIdentity" {
  display_name = var.outboundIdentityName
}

############################################## resources to be deployed ###########################################

resource "azurerm_linux_function_app" "functionApp" {
  resource_group_name             = var.resourceGroupName
  location                        = var.location
  name                            = var.functionAppName
  tags                            = var.tags
  service_plan_id                 = var.appServicePlanId
  functions_extension_version     = var.functionsExtensionVersion
  https_only                      = true
  key_vault_reference_identity_id = local.outboundUserIdentityResourceId
  storage_account_name            = var.faStorageAccountName
  storage_uses_managed_identity   = true

  app_settings = {
    "AzureWebJobsStorage__clientId" : data.azuread_service_principal.outboundUserManagedIdentity.client_id
    "AzureWebJobsStorage__credential" : "managedidentity"
    "WEBSITE_RUN_FROM_PACKAGE_BLOB_MI_RESOURCE_ID" : local.outboundUserIdentityResourceId
  }

  site_config {
    application_insights_connection_string = var.appInsightsConnectionString
    application_insights_key               = var.appInsightsKey
    always_on                              = var.alwaysOnEnabled

    // https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app#application_stack
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "dotnet" ? [1] : []
      content {
        dotnet_version              = var.appStackLanguageVersion
        use_dotnet_isolated_runtime = var.dotnetIsolatedRuntime
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "java" ? [1] : []
      content {
        java_version = var.appStackLanguageVersion
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "node" ? [1] : []
      content {
        node_version = var.appStackLanguageVersion
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "python" ? [1] : []
      content {
        python_version = var.appStackLanguageVersion
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "powershell" ? [1] : []
      content {
        powershell_core_version = var.appStackLanguageVersion
      }
    }
  }

  # Outbound Identity
  identity {
    type         = local.outboundIdentityType
    identity_ids = [local.outboundUserIdentityResourceId]
  }

  dynamic "auth_settings_v2" {
    for_each = var.inboundAuthEnabled ? [1] : []
    content {
      auth_enabled           = true
      require_authentication = true
      unauthenticated_action = "Return401"
      login {}
      active_directory_v2 {
        tenant_auth_endpoint       = "https://login.microsoftonline.com/${var.inboundAuthTenantId}/"
        client_id                  = local.inboundAuthAppId
        client_secret_setting_name = "dummy"
      }
    }
  }

}

resource "azurerm_linux_function_app_slot" "functionAppSlot" {
  count                           = var.stagingSlotEnabled ? 1 : 0
  name                            = var.stagingSlotName
  tags                            = var.tags
  function_app_id                 = azurerm_linux_function_app.functionApp.id
  functions_extension_version     = var.functionsExtensionVersion
  https_only                      = true
  key_vault_reference_identity_id = local.outboundUserIdentityResourceId
  storage_account_name            = var.faStorageAccountName
  storage_uses_managed_identity   = true

  app_settings = {
    "AzureWebJobsStorage__clientId" : data.azuread_service_principal.outboundUserManagedIdentity.client_id
    "AzureWebJobsStorage__credential" : "managedidentity"
    "WEBSITE_RUN_FROM_PACKAGE_BLOB_MI_RESOURCE_ID" : local.outboundUserIdentityResourceId
  }

  site_config {
    application_insights_connection_string = var.appInsightsConnectionString
    application_insights_key               = var.appInsightsKey
    always_on                              = false
    // https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app#application_stack
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "dotnet" ? [1] : []
      content {
        dotnet_version              = var.appStackLanguageVersion
        use_dotnet_isolated_runtime = var.dotnetIsolatedRuntime
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "java" ? [1] : []
      content {
        java_version = var.appStackLanguageVersion
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "node" ? [1] : []
      content {
        node_version = var.appStackLanguageVersion
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "python" ? [1] : []
      content {
        python_version = var.appStackLanguageVersion
      }
    }
    dynamic "application_stack" {
      for_each = lower(var.appStackLanguage) == "powershell" ? [1] : []
      content {
        powershell_core_version = var.appStackLanguageVersion
      }
    }
  }

  identity {
    type         = local.outboundIdentityType
    identity_ids = [local.outboundUserIdentityResourceId]
  }

  dynamic "auth_settings_v2" {
    for_each = var.inboundAuthEnabled ? [1] : []
    content {
      auth_enabled           = true
      require_authentication = true
      unauthenticated_action = "Return401"
      login {}
      active_directory_v2 {
        tenant_auth_endpoint       = "https://login.microsoftonline.com/${var.inboundAuthTenantId}/"
        client_id                  = local.inboundAuthAppId
        client_secret_setting_name = "dummy"
      }
    }
  }

}
