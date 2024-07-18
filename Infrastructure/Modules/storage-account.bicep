param storageAccount object
param resourceGroup object
param functionAppExternalUKSPrincipalIds object
param functionAppExternalUKWPrincipalIds object
param tags object

var storageBlobDataContributorRoleId = 'ba92f5b4-2d11-453d-a403-e96b0029c9fe'

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccount.name
  location: resourceGroup.location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
  tags: tags
}

resource blobServicesResource 'Microsoft.Storage/storageAccounts/blobServices@2021-08-01' = {
  parent: storageAccountResource
  name: 'default'
}

resource containerResourceProductCategories 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-08-01' = {
  parent: blobServicesResource
  name: 'productcategories'
  properties: {
    publicAccess: 'None'
  }
}

resource roleAssignmentBlobDevopsServicePrincipal 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, storageAccount.devopsServicePrincipalId, storageBlobDataContributorRoleId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: storageAccount.devopsServicePrincipalId
  }
}

resource roleAssignmentFunctionAppExternalUKS 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppExternalUKSPrincipalIds.functionApp, storageBlobDataContributorRoleId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: functionAppExternalUKSPrincipalIds.functionApp
  }
}

resource roleAssignmentFunctionAppExternalUKSSlot 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppExternalUKSPrincipalIds.functionAppSlot, storageBlobDataContributorRoleId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: functionAppExternalUKSPrincipalIds.functionAppSlot
  }
}

resource roleAssignmentFunctionAppExternalUKW 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppExternalUKWPrincipalIds.functionApp, storageBlobDataContributorRoleId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: functionAppExternalUKWPrincipalIds.functionApp
  }
}

resource roleAssignmentFunctionAppExternalUKWSlot 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccountResource
  name: guid(storageAccountResource.name, functionAppExternalUKWPrincipalIds.functionAppSlot, storageBlobDataContributorRoleId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', storageBlobDataContributorRoleId)
    principalId: functionAppExternalUKWPrincipalIds.functionAppSlot
  }
}
