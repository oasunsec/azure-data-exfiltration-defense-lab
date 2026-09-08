targetScope = 'subscription'
param labResourceGroupName string

resource lab 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: labResourceGroupName
}
resource denyPublic 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'data-defense-deny-public-blob'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Data Defense Lab - deny anonymous blob access'
    description: 'Applied only to the dedicated lab resource group.'
    policyRule: {
      if: {
        allOf: [
          { field: 'type', equals: 'Microsoft.Storage/storageAccounts' }
          { field: 'Microsoft.Storage/storageAccounts/allowBlobPublicAccess', notEquals: false }
        ]
      }
      then: { effect: 'Deny' }
    }
  }
}
resource auditClassification 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: 'data-defense-audit-classification'
  properties: {
    policyType: 'Custom'
    mode: 'Indexed'
    displayName: 'Data Defense Lab - audit financial data classification tag'
    policyRule: {
      if: {
        allOf: [
          { field: 'type', equals: 'Microsoft.Storage/storageAccounts' }
          { field: 'tags[DataClassification]', notEquals: 'Confidential' }
        ]
      }
      then: { effect: 'Audit' }
    }
  }
}
module assignments 'policy-assignments.bicep' = {
  name: 'data-defense-policy-assignments'
  scope: lab
  params: {
    denyDefinitionId: denyPublic.id
    auditDefinitionId: auditClassification.id
  }
}
