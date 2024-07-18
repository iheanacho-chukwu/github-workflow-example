param topicNameParam string
param tagsParam object = {}
param location string = resourceGroup().location

var serviceName = 'exampleservice'

module eventGrid './Modules/eventGridTopic.bicep' = {
  name: '${serviceName}-eventGridtopic'
  params: {
    topicName: topicNameParam
    location: location
    tags: tagsParam
  }
}

output topicEndpoint string = eventGrid.outputs.topicEndpoint
output topicProvisioningState string = eventGrid.outputs.topicProvisioningState
