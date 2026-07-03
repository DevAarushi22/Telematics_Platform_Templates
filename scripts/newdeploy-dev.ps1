# ==========================================
# Deploy All Microservices - DEV
# ==========================================

Write-Host ""
Write-Host "====================================="
Write-Host "Connecting to Dev AKS..."
Write-Host "====================================="
Write-Host ""

az account set --subscription "TelematicsDev"

az aks get-credentials `
    --resource-group telematicsrgdevcin01 `
    --name telematicsaksdevcin01 `
    --overwrite-existing

Write-Host ""
Write-Host "====================================="
Write-Host "Ensuring apps namespace exists..."
Write-Host "====================================="
Write-Host ""

kubectl create namespace apps --dry-run=client -o yaml | kubectl apply -f -

# ==========================================
# List of Services
# ==========================================

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

# ==========================================
# Deploy Services
# ==========================================

foreach ($service in $services)
{
    Write-Host ""
    Write-Host "====================================="
    Write-Host "Deploying $service..."
    Write-Host "====================================="
    Write-Host ""

    helm upgrade --install $service `
        ./helm/microservice-template `
        -f "./services/$service/values-dev.yaml" `
        --namespace apps

    if ($LASTEXITCODE -ne 0)
    {
        Write-Host "❌ Failed deploying $service" -ForegroundColor Red
        continue
    }

    Write-Host "Waiting for rollout..."

    kubectl rollout status deployment/$service `
        -n apps `
        --timeout=300s

    if ($LASTEXITCODE -eq 0)
    {
        Write-Host "✅ $service deployed successfully." -ForegroundColor Green
    }
    else
    {
        Write-Host "⚠️ Rollout failed for $service." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "====================================="
Write-Host "Deployment Complete"
Write-Host "====================================="
Write-Host ""

kubectl get pods -n apps
kubectl get svc -n apps
kubectl get ingress -n apps