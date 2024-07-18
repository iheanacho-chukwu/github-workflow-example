param functionApp object
param logAnalytics object
param tags object
param location string
param slotName string = 'staging'

output principalIds object = {
  functionApp: functionAppResource.identity.principalId
  functionAppSlot: functionAppSlotResource.identity.principalId
}

resource logAnalyticsResource 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalytics.name
  scope: resourceGroup(logAnalytics.resourceGroup)
}

resource serverFarmResource 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: functionApp.serverFarm.name
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  tags: tags
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: functionApp.storageAccount.name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
  tags: tags
}

resource functionAppResource 'Microsoft.Web/sites@2021-02-01' = {
  name: functionApp.name
  location: location
  kind: 'functionApp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: serverFarmResource.id
    siteConfig: {
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
  tags: tags
}

resource functionAppAuthSettingsResource 'Microsoft.Web/sites/config@2021-02-01' = {
  name: 'authsettingsV2'
  parent: functionAppResource
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'RedirectToLoginPage'
      redirectToProvider: 'AzureActiveDirectory'
    }
    login: {
      tokenStore: {
        enabled: true
      }
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          openIdIssuer: 'https://sts.windows.net/${subscription().tenantId}/'
          clientId: functionApp.authClientId
        }
        validation: {
          allowedAudiences: [
            functionApp.authAllowedAudience
          ]
        }
      }
    }
  }
}

resource functionAppDiagnosticsResource 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: functionAppResource.name
  scope: functionAppResource
  properties: {
    workspaceId: logAnalyticsResource.id
    logs: [
      {
        category: 'FunctionAppLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

resource functionAppSlotResource 'Microsoft.Web/sites/slots@2021-02-01' = {
  name: format('{0}/{1}', functionAppResource.name, slotName)
  location: location
  kind: 'functionApp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: serverFarmResource.id
    siteConfig: {
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
  tags: tags
}

resource functionAppSlotAuthSettingsResource 'Microsoft.Web/sites/slots/config@2021-02-01' = {
  name: 'authsettingsV2'
  parent: functionAppSlotResource
  properties: {
    globalValidation: {
      requireAuthentication: true
      unauthenticatedClientAction: 'RedirectToLoginPage'
      redirectToProvider: 'AzureActiveDirectory'
    }
    login: {
      tokenStore: {
        enabled: true
      }
    }
    identityProviders: {
      azureActiveDirectory: {
        enabled: true
        registration: {
          openIdIssuer: 'https://sts.windows.net/${subscription().tenantId}/'
          clientId: functionApp.authClientId
        }
        validation: {
          allowedAudiences: [
            functionApp.authAllowedAudience
          ]
        }
      }
    }
  }
}
