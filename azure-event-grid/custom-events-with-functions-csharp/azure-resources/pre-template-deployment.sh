# First argument is the resource group name
rgName=$1
# Second argument is the location of the resource group
location=$2

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

echo $(pwd)