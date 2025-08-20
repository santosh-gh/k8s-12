// Parameters
targetScope = 'subscription'

@description('Project name')
param projectName string

@description('Environment name')
param environment string

@description('Primary Resource Instance')
param resourceInstance string

@description('Primary location for the resources')
param location string

var resourceLocator = '${projectName}-${environment}-${location}-${resourceInstance}'

// Parameters for AKS
@description('The number of nodes for the cluster.')
@minValue(1)
@maxValue(50)
param agentCount int = 1

@description('The size of the Virtual Machine.')
param agentVMSize string = 'Standard_B2s'

@description('Optional DNS Prefix to use with hosted Kubernetes API server FQDN')
param dnsPrefix string = 'aks${projectName}'

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

// Parameters for roleAssignments
var acrPullRoleDefinitionId = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d')


// Create a resource group
resource resGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${resourceLocator}'
  location: location
}

module acr 'modules/acr.bicep' = {
  name: 'ACR-deployment'
  scope: resourceGroup(resGroup.name)
  params: {
    acrName: 'acr${projectName}${environment}${location}${resourceInstance}'
    location: location
  }
}

module aks 'modules/aks.bicep' = {
  name: 'AKS-Deployment'
  scope: resourceGroup(resGroup.name)
  params: {
    aksName: 'aks-${resourceLocator}'
    location: location
    agentCount: agentCount
    agentVMSize: agentVMSize
    dnsPrefix: dnsPrefix
    osDiskSizeGB: osDiskSizeGB
  }
}

module roleAssignments 'modules/roleassignments.bicep' = {
  name: 'RoleAssignments-Deployment'
  scope: resourceGroup(resGroup.name)
  params: {
    aksId: aks.outputs.aksId
    principalId: aks.outputs.principalId // Principal ID of the AKS cluster
    acrPullRoleDefinitionId: acrPullRoleDefinitionId    
  }
}
