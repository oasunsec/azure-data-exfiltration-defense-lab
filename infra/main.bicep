targetScope = 'resourceGroup'

@description('Existing Sentinel workspace in the same subscription.')
param workspaceResourceGroup string
param workspaceName string
@description('Operator public IPv4 address. Supply privately; never commit it.')
param operatorIp string
param location string = resourceGroup().location
param classificationTag string = 'Confidential'

var tags = union({
  Project: 'DataDefenseLab'
  Environment: 'Lab'
}, empty(classificationTag) ? {} : { DataClassification: classificationTag })

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
  scope: resourceGroup(workspaceResourceGroup)
}

resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: 'stdef${uniqueString(resourceGroup().id)}'
  location: location
  tags: tags
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    defaultToOAuthAuthentication: true
    allowCrossTenantReplication: false
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'None'
      defaultAction: 'Deny'
      ipRules: [{ action: 'Allow', value: operatorIp }]
      virtualNetworkRules: []
    }
    encryption: {
      keySource: 'Microsoft.Storage'
      requireInfrastructureEncryption: true
      services: {
        blob: { enabled: true, keyType: 'Account' }
        file: { enabled: true, keyType: 'Account' }
      }
    }
  }
}

resource blobs 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storage
  name: 'default'
  properties: {
    isVersioningEnabled: true
    deleteRetentionPolicy: { enabled: true, days: 7 }
    containerDeleteRetentionPolicy: { enabled: true, days: 7 }
  }
}
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: blobs
  name: 'financial-records'
  properties: { publicAccess: 'None' }
}
resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'data-defense-blob-audit'
  scope: blobs
  properties: {
    workspaceId: workspace.id
    logAnalyticsDestinationType: 'Dedicated'
    logs: [
      { category: 'StorageRead', enabled: true }
      { category: 'StorageWrite', enabled: true }
      { category: 'StorageDelete', enabled: true }
    ]
  }
}
resource retainedLock 'Microsoft.Authorization/locks@2020-05-01' = {
  name: 'retain-data-defense-lab'
  properties: {
    level: 'CanNotDelete'
    notes: 'Retained for continued lab validation. Remove deliberately before future teardown.'
  }
}

output storageName string = storage.name
output storageId string = storage.id
output containerId string = container.id
output workspaceId string = workspace.id
output blobEndpoint string = storage.properties.primaryEndpoints.blob
