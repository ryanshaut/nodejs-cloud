#!/usr/bin/env bash

############### Variables #############
resourceSuffix=49547186adcb

subscription=hq-devtest
resourcegroup=rg-devtest-$resourceSuffix
location=eastus
dateForTag=$(date +%Y%b%d)

image="shaurm/nodejs-cloud:latest"


############### Functions #############

CreateRG(){
    echo "Checking resource group"

    if [ $(az group exists --name $resourcegroup) = false ]; then
        echo "Creating resource group $resourcegroup in $location"
        az group create --name $resourcegroup --location $location \
        --tags \
        "CreatedBy"="{\"email\":\"ryan@shaut.us\"}" \
        "CreatedOn"="{\"date\":\"$dateForTag\"}" \
        "Function"="{\"use\":\"testing global apps\"}" \
        "environment"="{\"env\":\"devtest\"}"
    fi
    
}


CreateASP(){
    echo "Checking ASP"
    
    if [ $(az appservice plan list --query "[?name == '$aspName'] | length(@)") = 0 ]; then
        echo "Creating ASP $aspName "
        az appservice plan create -g $resourcegroup -n $aspName --is-linux --sku F1 \
        --tags \
        "CreatedBy"="{\"email\":\"ryan@shaut.us\"}" \
        "CreatedOn"="{\"date\":\"$dateForTag\"}" \
        "Function"="{\"use\":\"testing global apps\"}" \
        "environment"="{\"env\":\"devtest\"}"
    fi
}

CreateWebApp(){
    echo "Checking Web App"
    
    if [ $(az webapp list --query "[?name == '$webappName'] | length(@)" ) = 0 ]; then
        
        echo "Creating Webapp $webappName"
        
        az webapp create -g $resourcegroup --name $webappName -p $aspName  \
        -i $image \
        --assign-identity '[system]' \
        --https-only \
        --tags \
        "CreatedBy"="{\"email\":\"ryan@shaut.us\"}" \
        "CreatedOn"="{\"date\":\"$dateForTag\"}" \
        "Function"="{\"use\":\"testing global apps\"}" \
        "environment"="{\"env\":\"devtest\"}"
        
        
        az webapp config appsettings set -g $resourcegroup --name $webappName --settings AzRegion=$location
        
        az webapp deployment container config --enable-cd true -g $resourcegroup --name $webappName
        
        
        az webapp config set  -g $resourcegroup --name $webappName --ftps-state disabled
        az webapp config set  -g $resourcegroup --name $webappName --min-tls-version '1.2'
    fi
}





############### Main #############
az account set --subscription $subscription



CreateRG
rg=$(az group show --name $resourcegroup -o json)



aspName=asp-$location-$resourceSuffix
CreateASP
asp=$(az appservice plan show --name $aspName --resource-group $resourcegroup -o json)

webappName=app-$location-$resourceSuffix
CreateWebApp
app=$(az webapp show -g $resourcegroup -n $webappName -o json)

appHostname=$(az webapp config hostname list -g $resourcegroup --webapp-name $webappName --query "[].name" -o tsv)
echo "$webappName is ready at https://$appHostname"
az webapp deployment container show-cd-url -g $resourcegroup -n $webappName