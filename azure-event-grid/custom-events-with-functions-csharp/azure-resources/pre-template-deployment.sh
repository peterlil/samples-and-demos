/usr/bin/az --version
echo $1
echo $2
## First argument is the resource group name
#RESOURCEGROUPNAME=$1
## Second argument is the location of the resource group
#LOCATION=$2
#
#if [ $(az group exists --name $RESOURCEGROUPNAME) = false ]; then
#    az group create --name $RESOURCEGROUPNAME --location $LOCATION
#fi