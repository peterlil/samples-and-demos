# First argument is the resource group name
rgName=$1
# Second argument is the location of the resource group
location=$2

if [ $(az group exists --name $rgName) = false ]; then
    az group create --name $rgName --location $location
fi