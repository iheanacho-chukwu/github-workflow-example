param logAnalytics object
param tags object
param location string

resource logAnalyticsResource 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalytics.name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: logAnalytics.retentionInDays
    workspaceCapping: {
      dailyQuotaGb: logAnalytics.dailyQuotaGb
    }
  }
  tags: tags
}
