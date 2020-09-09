
echo '##[debug]Line 2'
az_version=$(/usr/bin/az --version)
echo "##[debug]$az_version"

## First argument is the resource group name
#RESOURCEGROUPNAME=$1
## Second argument is the location of the resource group
#LOCATION=$2
#
#if [ $(az group exists --name $RESOURCEGROUPNAME) = false ]; then
#    az group create --name $RESOURCEGROUPNAME --location $LOCATION
#fi