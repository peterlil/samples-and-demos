#
# First argument is the resource group name
rgName=$1
# Second argument is the location of the resource group
location=$2
# Third argument is the name of the Key Vault
keyVaultName=$3

################################################################################
### Create the resource group
################################################################################
if [ $(az group exists --name $rgName) = false ]; then
    az group create --name $rgName --location $location
fi

################################################################################
### Deploy Key Vault
################################################################################

# The name of the Key Vault and the ObjectID of the user should not be checked 
# in to source control, hence they are not in the parameter file.
#
#echo $(pwd)
sed -i 's/#keyvaultname#/$keyVaultName/' ./azure-event-grid/custom-events-with-functions-csharp/azure-resources/azuredeploy.keyvault.parameters.json