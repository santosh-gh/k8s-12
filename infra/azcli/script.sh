# Customize these values
RESOURCE_GROUP="rg-onlinestore-dev-uksouth-001"
LOCATION="uksouth"
AKS_NAME="aks-onlinestore-dev-uksouth-001"
ACR_NAME="acronlinestoredevuksouth001"
NODE_COUNT=1

# Create a resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create ACR (Azure Container Registry)
az acr create --resource-group $RESOURCE_GROUP \
              --name $ACR_NAME \
              --sku Basic \
              --admin-enabled true


# Create AKS cluster and attach ACR in one step
az aks create \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_NAME \
  --node-count $NODE_COUNT \
  --enable-managed-identity \
  --attach-acr $ACR_NAME \
  --generate-ssh-keys



# # Create AKS Cluster (without ACR integration yet)
# Create a Kubernetes clusteraz aks create --resource-group $RESOURCE_GROUP \
#               --name $AKS_NAME \
#               --node-count $NODE_COUNT \
#               --generate-ssh-keys

# # Allow AKS to pull images from ACR
# az aks update --name $AKS_NAME \
#               --resource-group $RESOURCE_GROUP \
#               --attach-acr $ACR_NAME