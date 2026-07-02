$Services = @(
    "apigateway",
    "auth",
    "organisation",
    "tenantmanagement",
    "timeseries",
    "streaming",
    ...
)

foreach ($Service in $Services) {

    helm upgrade `
        --install $Service `
        .\helm\microservice-template `
        --namespace apps `
        -f ".\services\$Service\values-dev.yaml"

}