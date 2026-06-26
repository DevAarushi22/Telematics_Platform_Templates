#deploying all the microservices in the services folder using helm and kubectl
$services = @(
"apigateway",
# "auth",
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

$Succeeded = @()
$Failed = @()

foreach ($service in $services)
{
    Write-Host ""
    Write-Host "=================================================="
    Write-Host "Deploying $service"
    Write-Host "=================================================="

    helm upgrade --install `
    $service `
    ./helm/microservice-template `
    -f ./services/$service/values-dev.yaml `
    -n apps `
    --create-namespace

    if ($LASTEXITCODE -ne 0)
    {
        Write-Host "FAILED: Helm deployment for $service"
        $Failed += $service
        continue
    }

    kubectl rollout status deployment/$service `
        -n apps `
        --timeout=180s

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host "SUCCESS: $service"
        $Succeeded += $service
    }
    else
    {
        Write-Host "FAILED: Rollout for $service"
        $Failed += $service
    }
}

Write-Host ""
Write-Host "==================== SUMMARY ===================="

Write-Host ""
Write-Host "Successful Deployments:"
$Succeeded

Write-Host ""
Write-Host "Failed Deployments:"
$Failed