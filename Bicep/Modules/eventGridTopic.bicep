param topicName string
param location string = resourceGroup().location
param tags object

resource eventGridTopic 'Microsoft.EventGrid/topics@2021-12-01' = {
  name: topicName
  location: location
  tags: tags
  properties: {}
}

output topicEndpoint string = eventGridTopic.properties.endpoint
output topicProvisioningState string = eventGridTopic.properties.provisioningState
