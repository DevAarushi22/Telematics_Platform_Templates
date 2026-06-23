# ==========================================
# Auth Service Deployment - DEV
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

Write-Host ""
Write-Host "====================================="
Write-Host "Deploying Auth..."
Write-Host "====================================="
Write-Host ""

helm upgrade --install auth `
    ./helm/microservice-template `
    -f ./services/auth/values-dev.yaml `
    --namespace apps

Write-Host ""
Write-Host "====================================="
Write-Host "Deployment Status"
Write-Host "====================================="
Write-Host ""

kubectl rollout status deployment/auth `
    -n apps `
    --timeout=300s

Write-Host ""
Write-Host "====================================="
Write-Host "Resources"
Write-Host "====================================="
Write-Host ""

kubectl get pods -n apps
kubectl get svc -n apps
kubectl get ingress -n apps