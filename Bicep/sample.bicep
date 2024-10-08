// Bicep file for deploying a sample App Service Plan
resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'sample-app-service-plan'
  location: resourceGroup().location
  sku: {
    tier: 'Basic'
    name: 'B1'
  }
}

// Bicep file for deploying a Web App
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'sample-web-app-nacho'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
  kind: 'app'
}
