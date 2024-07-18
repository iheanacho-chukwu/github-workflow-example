param keyVault object
param logAnalytics object
param functionAppExternalUKSPrincipalIds object
param functionAppExternalUKWPrincipalIds object
param tags object
param location string

resource logAnalyticsResource 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalytics.name
}

resource keyVaultSecretsUserRoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: '4633458b-17de-408a-b874-0445c86b69e6'
}

resource keyVaultResource 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVault.name
  location: location
  properties: {
    enableRbacAuthorization: true
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
  }
  tags: tags
}

resource keyVaultDiagnosticsResource 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: keyVaultResource
  name: keyVaultResource.name
  properties: {
    workspaceId: logAnalyticsResource.id
    logs: [
      {
        category: 'AuditEvent'
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

resource roleAssignmentFunctionAppExternalUKS 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppExternalUKSPrincipalIds.functionApp, keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppExternalUKSPrincipalIds.functionApp
  }
}

resource roleAssignmentFunctionAppExternalUKSSlot 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppExternalUKSPrincipalIds.functionAppSlot, keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppExternalUKSPrincipalIds.functionAppSlot
  }
}

resource roleAssignmentFunctionAppExternalUKW 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppExternalUKWPrincipalIds.functionApp, keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppExternalUKWPrincipalIds.functionApp
  }
}

resource roleAssignmentFunctionAppExternalUKWSlot 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: keyVaultResource
  name: guid(keyVaultResource.name, functionAppExternalUKWPrincipalIds.functionAppSlot, keyVaultSecretsUserRoleDefinition.id)
  properties: {
    roleDefinitionId: keyVaultSecretsUserRoleDefinition.id
    principalId: functionAppExternalUKWPrincipalIds.functionAppSlot
  }
}
