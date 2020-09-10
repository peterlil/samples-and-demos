#!/bin/bash
# First argument is the resource group name
rgName=$1
# Second argument is the location of the resource group
location=$2
# Third argument is the name of the Key Vault
keyVaultName=$3
# Fourth argument is the object ID of the service principal creating the Key Vault
keyVaultOwnerObjectID=$4

################################################################################
### If not logged in, then do it as the script is not running in DevOps
################################################################################
noAzLocations=`az account list-locations | jq '. | length'`

if [ $noAzLocations -le 5 ]; then
    az login
fi


################################################################################
### Create the resource group
################################################################################
if [ $(az group exists --name $rgName) = false ]; then
    az group create --name $rgName --location $location
fi

################################################################################
### Deploy Storage Account for deployment of resources
################################################################################

echo "##[group]Creating storage account for deployment"

result=$(az deployment group create \
  --name 'CICD-deployment' \
  --resource-group $rgName \
  --template-file ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.storagefordeployment.json \
  --parameters @./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.storagefordeployment.parameters.json)

echo "##[debug]$result"

echo "##[endgroup]"

################################################################################
### Deploy Key Vault
################################################################################

# The name of the Key Vault and the ObjectID of the user should not be checked 
# in to source control, hence they are not in the parameter file.
echo "##[group]Deploying Key Vault"

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
echo "##[endgroup]"

################################################################################
### Prepare for linked deployment templates
################################################################################

# Create a storage container for the deployment resources and a SAS token that's
# valid for 30 minutes.

echo "##[group]Creating storage container"

storageParameterFile=./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.storagefordeployment.parameters.json

storageAccountName=$(cat $storageParameterFile | jq -r '.parameters.storageAccountName.value')

timestamp=`date +"%Y%m%d-%H%M%S"`
deploymentContainerName="deploy-$timestamp"


result=`az storage container create \
    -n $deploymentContainerName \
    --account-name $storageAccountName \
    --auth-mode login`

echo "##[debug]$result"
echo "##[endgroup]"

echo "##[command]Getting the storage key"
storageKey=`az storage account keys list --account-name $storageAccountName | jq -r '.[0].value'`

echo "##[command]Generating SAS token"
sasEnd=`date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ'`
sasToken=`az storage container generate-sas -n $deploymentContainerName \
    --account-name $storageAccountName \
    --https-only --permissions dlrw \
    --expiry $sasEnd \
    -o tsv \
    --auth-mode key \
    --account-key $storageKey`

echo "##[group]Upload all ARM templates to the new blob"
# Upload all ARM templates by uploading all .json files in the azure-resources folder
for i in ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/*.json; do
    [ -f "$i" ] || break
    echo "##[debug]$i"
    filename=`basename $i`
    result=`az storage blob upload \
        -f "$i" \
        -c $deploymentContainerName \
        -n $filename \
        --content-type "application/octet-stream" \
        --account-name $storageAccountName \
        --account-key $storageKey`
    echo "##[debug]$result"
done
echo "##[endgroup]"

################################################################################
### Deploy linked templates
################################################################################

echo "##[group]Deploying linked templates"

_artifactsLocation="https://$storageAccountName.blob.core.windows.net/$deploymentContainerName"

result=`az deployment group create \
  --name 'CICD-deployment' \
  --resource-group $rgName \
  --template-uri $_artifactsLocation/azuredeploy.master.json?$sasToken \
  --parameters _artifactsLocation=$_artifactsLocation _artifactsLocationSasToken=$sasToken`

#EXAMPLE
#az deployment group create --resource-group testrg --name rollout01 \
#    --template-file azuredeploy.json  --parameters @params.json \
#    --parameters https://mysite/params.json --parameters MyValue=This MyArray=@array.json

echo "##[debug]$result"

echo "##[endgroup]"
