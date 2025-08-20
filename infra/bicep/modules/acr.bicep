@description('The resource group location')
param location string

@description('acr name')
param acrName string

resource acr 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    adminUserEnabled: true
  }
}

output acrName string = acr.name
output acrId string = acr.id
