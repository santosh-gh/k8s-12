@description('The resource group location')
param location string

@description('aks name')
param aksName string

@description('dnsPrefix name')
param dnsPrefix string

@description('Disk size (in GB) to provision for each of the agent pool nodes. This value ranges from 0 to 1023. Specifying 0 will apply the default disk size for that agentVMSize.')
@minValue(0)
@maxValue(1023)
param osDiskSizeGB int = 0

@description('agent count for the cluster.')
param agentCount int = 1

@description('agent vm size for the cluster.')
param agentVMSize string

resource aks 'Microsoft.ContainerService/managedClusters@2025-05-01' = {
  name: aksName
  location: location
  identity: {
   type: 'SystemAssigned' 
  }
  sku: {
    name: 'Base'
    tier: 'Standard'
  }
  properties: {
    dnsPrefix: dnsPrefix
    agentPoolProfiles: [
      {
        name: 'agentpool'
        osDiskSizeGB: osDiskSizeGB
        count: agentCount
        vmSize: agentVMSize
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
}

output aksName string = aks.name
output aksId string = aks.id
output principalId string =aks.properties.identityProfile.kubeletidentity.objectId
