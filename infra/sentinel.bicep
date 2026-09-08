targetScope = 'resourceGroup'
param workspaceName string
resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: workspaceName
}
resource deniedWrite 'Microsoft.SecurityInsights/alertRules@2024-03-01' = {
  scope: workspace
  name: guid(workspace.id, 'data-defense-denied-financial-write')
  kind: 'Scheduled'
  properties: {
    displayName: 'Financial records - denied blob write'
    description: 'A write to the dedicated financial-records container was rejected. Investigate authorization and workload context. A denied write is not proof of exfiltration.'
    enabled: true
    severity: 'Medium'
    query: loadTextContent('../docs/kql/denied-financial-write.kql')
    queryFrequency: 'PT5M'
    queryPeriod: 'PT1H'
    triggerOperator: 'GreaterThan'
    triggerThreshold: 0
    suppressionEnabled: false
    suppressionDuration: 'PT1H'
    eventGroupingSettings: { aggregationKind: 'SingleAlert' }
    incidentConfiguration: {
      createIncident: true
      groupingConfiguration: {
        enabled: true
        reopenClosedIncident: false
        lookbackDuration: 'PT24H'
        matchingMethod: 'AllEntities'
        groupByEntities: []
        groupByAlertDetails: []
        groupByCustomDetails: []
      }
    }
    entityMappings: [{
      entityType: 'AzureResource'
      fieldMappings: [{ identifier: 'ResourceId', columnName: 'StorageResource' }]
    }]
    customDetails: {
      Attempts: 'Attempts'
      FailureReasons: 'FailureReasons'
      RequesterObjectId: 'RequesterObjectId'
    }
  }
}
output ruleId string = deniedWrite.id
