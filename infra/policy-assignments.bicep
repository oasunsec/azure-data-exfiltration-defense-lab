param denyDefinitionId string
param auditDefinitionId string
resource denyAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'defense-deny-public'
  properties: {
    displayName: 'Data Defense Lab - deny anonymous blob access'
    policyDefinitionId: denyDefinitionId
    enforcementMode: 'Default'
  }
}
resource auditAssignment 'Microsoft.Authorization/policyAssignments@2023-04-01' = {
  name: 'defense-audit-tag'
  properties: {
    displayName: 'Data Defense Lab - audit classification'
    policyDefinitionId: auditDefinitionId
    enforcementMode: 'Default'
  }
}
