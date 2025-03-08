#./deploy-helm.ps1 -NAMESPACE "dev" -RESOURCE_GROUP_NAME "logcorner-dev-rg" -RESOURCE_GROUP_LOCATION "westeurope" -CLUSTER_NAME "logcorner-dev-aks" -PRIVATE_DNS_ZONE_NAME "datasynchro.com" -REPOSITORY_NAME "logcornerarepodev" -IMAGE_TAG 1333
# param(
#     [Parameter(Mandatory=$true)]
#     [string]$NAMESPACE ="dev",
#     [Parameter(Mandatory=$true)]
#     [string]$RESOURCE_GROUP_NAME="datasynchro-dev-rg",
#     [Parameter(Mandatory=$true)]
#     [string]$CLUSTER_NAME="datasynchro-dev-aks"
# )


$NAMESPACE ="dev"

$RESOURCE_GROUP_NAME="datasynchro-dev-rg"

$CLUSTER_NAME="datasynchro-dev-aks"
  
$keycloakChartName = "keycloak"

write-host "NAMESPACE  =>  $NAMESPACE " -ForegroundColor Green
write-host "RESOURCE_GROUP_NAME  =>  $RESOURCE_GROUP_NAME " -ForegroundColor Green

write-host "CLUSTER_NAME  =>  $CLUSTER_NAME " -ForegroundColor Green

$keycloakChartName = "keycloak"

Write-Host "Setting up the environment..." -ForegroundColor Green
az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME --overwrite-existing
kubectl get deployments --all-namespaces=true


Write-Host "Adding the ingress-nginx repository..." -ForegroundColor Green
 # Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Update the Helm repo to ensure we have the latest charts
helm repo update

kubectl create namespace $NAMESPACE

#kubectl create secret tls secret-name --cert=ssl/tls.crt --key=ssl/tls.key
<# mkdir ssl
openssl pkcs12 -in ssl/datasync-ssl.pfx -nocerts -nodes -out ssl/tls.key
openssl pkcs12 -in ssl/datasync-ssl.pfx -clcerts -nokeys -out ssl/tls.crt #>

# cat ssl/tls.crt
# cat ssl/tls.key

Write-Host "Deploying keycloak  chart..." -ForegroundColor Green

helm upgrade --install logcorner-keycloak $keycloakChartName 

# Write-Host "Waiting for the keycloak pod to be ready... " -ForegroundColor Green
# kubectl wait --namespace  $NAMESPACE --for=condition=ready pod -l app=keycloak-deployment --timeout=300s


<# Write-Host  "Calling  keycloak : https://logcorner.datasynchro.com/keycloak/ ... " -ForegroundColor Green
kubectl exec -it curl-test -n $NAMESPACE -- curl -v -k --resolve logcorner.datasynchro.com:443:$PRIVATE_IP https://logcorner.datasynchro.com/keycloak/ #>
