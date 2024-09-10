param topicName string
param location string = resourceGroup().location
param tags object

resource eventGridTopic 'Microsoft.EventGrid/topics@2021-12-01' = {
  name: topicName
  location: location
  tags: tags
  properties: {}
}

resource storageAccountResource 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: topicName
  location: location
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

output topicEndpoint string = eventGridTopic.properties.endpoint
output topicProvisioningState string = eventGridTopic.properties.provisioningState
