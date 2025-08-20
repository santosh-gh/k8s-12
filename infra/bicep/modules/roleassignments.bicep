@description('aks Id')
param aksId string

@description('acr Pull Role Definition Id')
param acrPullRoleDefinitionId string

@description('aks principal id')
param principalId string

resource acrPullRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, aksId, acrPullRoleDefinitionId)
  properties: {
    principalId: principalId
    roleDefinitionId: acrPullRoleDefinitionId
    principalType: 'ServicePrincipal'
  }
}
