param applicationInsights object
param logAnalytics object
param tags object
param location string

resource logAnalyticsResource 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: logAnalytics.name
}

resource applicationInsightsResource 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsights.name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsResource.id
  }
  tags: tags
}
