$services = @(
"apigateway",
"auth",
"cachingdistributedinfrastructure",
"featurelicensing",
"inventorymanagement",
"notificationalerts",
"organisation",
"platformadmin",
"pricingbilling",
"protocolparser",
"reportinganalytics",
"reseller",
"retail",
"routeoptimization",
"storage",
"streaming",
"superadmin",
"tenantmanagement",
"timeseries",
"useraccessmanagement",
"vehiclemanagement",
"webhook",
"workflowmanagement"
)

foreach ($service in $services) {

    Write-Host "Validating $service"

    helm template `
        $service `
        ./helm/microservice-template `
        -f ./services/$service/values-dev.yaml > $null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ $service"
    }
    else {
        Write-Host "✗ $service"
        break
    }
}