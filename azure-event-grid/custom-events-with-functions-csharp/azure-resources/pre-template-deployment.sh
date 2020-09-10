#!/bin/bash
# First argument is the resource group name
rgName=$1
# Second argument is the location of the resource group
location=$2
# Third argument is the name of the Key Vault
keyVaultName=$3
# Third argument is the object ID of the service principal creating the Key Vault
keyVaultOwnerObjectID=$4

################################################################################
### Create the resource group
################################################################################
if [ $(az group exists --name $rgName) = false ]; then
    az group create --name $rgName --location $location
fi

################################################################################
### Deploy Storage Account for deployment of resources
################################################################################

result=$(az deployment group create \
  --name 'CICD-deployment' \
  --resource-group $rgName \
  --template-file ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.storagefordeployment.json \
  --parameters @./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.storagefordeployment.parameters.json)

echo "##[debug]$result"


################################################################################
### Deploy Key Vault
################################################################################

# The name of the Key Vault and the ObjectID of the user should not be checked 
# in to source control, hence they are not in the parameter file.

sed -i "s/#keyvaultname#/$keyVaultName/" ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.keyvault.parameters.json
sed -i "s/#objectIdOfUser#/$keyVaultOwnerObjectID/" ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.keyvault.parameters.json

#pFile=$(cat ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.keyvault.parameters.json)
#echo "##[debug]$pFile"

result=$(az deployment group create \
  --name 'CICD-deployment' \
  --resource-group $rgName \
  --template-file ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.keyvault.json \
  --parameters @./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.keyvault.parameters.json)

echo "##[debug]$result"

