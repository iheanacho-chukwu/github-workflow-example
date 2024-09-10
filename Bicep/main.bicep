param topicNameParam string
param tagsParam object = {}
param location string = resourceGroup().location

var serviceName = 'exampleservice'

module eventGridTopic './Modules/eventGridTopic.bicep' = {
  name: '${serviceName}-eventGridTopic'
  params: {
    topicName: topicNameParam
    location: location
    tags: tagsParam
  }
}

output topicEndpoint string = eventGridTopic.outputs.topicEndpoint
output topicProvisioningState string = eventGridTopic.outputs.topicProvisioningState
