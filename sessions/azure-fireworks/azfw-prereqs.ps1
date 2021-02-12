param(
    [string] $ResourceGroup
)
# Pre-reqs -> Be logged in to the right subscription first

az group create -g AzureFireworks $ResourceGroup

az appservice plan create -n "ASP-AFW" -g $ResourceGroup -l westeurope --sku S1

az monitor app-insights
