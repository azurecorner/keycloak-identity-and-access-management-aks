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
$ingressChartName="ingress" 
$KEYCLOAK_INGRESS_NAME="keycloak-ingress"

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

kubectl create secret tls secret-name --cert=ssl/tls.crt --key=ssl/tls.key -n $NAMESPACE
<# mkdir ssl
openssl pkcs12 -in ssl/datasync-ssl.pfx -nocerts -nodes -out ssl/tls.key
openssl pkcs12 -in ssl/datasync-ssl.pfx -clcerts -nokeys -out ssl/tls.crt #>

# cat ssl/tls.crt
# cat ssl/tls.key

# Use Helm to deploy an NGINX ingress controller without static private IP address
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx  `
--namespace $NAMESPACE  `
--set controller.service.type=LoadBalancer  `
--set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz 


$ServiceName = "ingress-nginx-controller"

Write-Host "Waiting for external IP for service '$ServiceName' in namespace '$NAMESPACE'..." -ForegroundColor Green

do {
    $PRIVATE_IP = kubectl get service $ServiceName --namespace $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
    if (-not $PRIVATE_IP) {
        Write-Host "External IP is still pending. Retrying in 5 seconds..."
        Start-Sleep -Seconds 5
    }
} while (-not $PRIVATE_IP)

Write-Host "Service is ready! External IP: $PRIVATE_IP" -ForegroundColor Green


#Check the status of the pods to see if the ingress controller is online.
kubectl get pods --namespace $NAMESPACE

#Now let's check to see if the service is online. This of type LoadBalancer, so do you have an EXTERNAL-IP?
kubectl get services --namespace $NAMESPACE


Write-Host "Deploying keycloak  chart..." -ForegroundColor Green

helm upgrade --install logcorner-keycloak $keycloakChartName 


Write-Host "Deploying Ingress chart..." -ForegroundColor Green

helm upgrade --install logcorner-ingress $ingressChartName 

write-host "Waiting for the ingress pod to be ready... " -ForegroundColor Green
kubectl describe ingressclasses nginx
kubectl describe ingress $KEYCLOAK_INGRESS_NAME --namespace $NAMESPACE

# Write-Host "Waiting for the keycloak pod to be ready... " -ForegroundColor Green
# kubectl wait --namespace  $NAMESPACE --for=condition=ready pod -l app=keycloak-deployment --timeout=300s


<# Write-Host  "Calling  keycloak : https://logcorner.datasynchro.com/keycloak/ ... " -ForegroundColor Green
kubectl exec -it curl-test -n $NAMESPACE -- curl -v -k --resolve logcorner.datasynchro.com:443:$PRIVATE_IP https://logcorner.datasynchro.com/keycloak/ #>
