# Deploying Keycloak on Azure Kubernetes Service (AKS) with Terraform and Helm

## Introduction  
This tutorial explains how to set up Keycloak, an Identity and Access Management (IAM) solution, on Azure Kubernetes Service (AKS). The infrastructure is provisioned using Terraform, and Keycloak is deployed with Helm. PostgreSQL is used as the database for Keycloak.

## Main Steps  

### 1. **Infrastructure Provisioning with Terraform**  
- Create an AKS cluster on Azure.  
- Deploy a PostgreSQL database on Azure.  
- Configure the necessary resources (networking, storage, etc.).  

### 2. **Deploying Keycloak with Helm**  
- Install Helm on the local machine.  
- Add the Keycloak Helm repository.  
- Configure Helm values for Keycloak (PostgreSQL connection, authentication settings).  
- Deploy Keycloak on AKS using Helm.  

### 3. **Configuration and Security**  
- Set up users and roles in Keycloak.  
- Secure access with TLS/SSL.  
- Implement an Ingress Controller to securely expose Keycloak.  

## Summary  
With this approach, Keycloak is deployed in an automated and reproducible manner on Azure Kubernetes Service. Terraform handles infrastructure provisioning, while Helm simplifies Keycloak deployment and configuration.

## Technologies Used  
- **Terraform**: Infrastructure provisioning.  
- **Azure Kubernetes Service (AKS)**: Container orchestration.  
- **Helm**: Managing Keycloak deployment.  
- **PostgreSQL**: Database for Keycloak.  
- **Ingress Controller**: Securely exposing Keycloak.  

## References  
- [Keycloak Documentation](https://www.keycloak.org/documentation)  
- [Helm Charts for Keycloak](https://artifacthub.io/packages/helm/bitnami/keycloak)  
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)  



# ######################
# Terraform Configuration for Deploying AKS and PostgreSQL on Azure

## Overview  
This Terraform file provisions an Azure infrastructure consisting of:  
- **An Azure Kubernetes Service (AKS) cluster**  
- **A PostgreSQL flexible server**  
- **Networking and firewall configurations**  

## Resources Created  

### 1. **Resource Group**  
- Defines a **resource group** to contain all deployed Azure resources.  

### 2. **Kubernetes Cluster (AKS)**  
- Creates an **Azure Kubernetes Service (AKS) cluster** with:  
  - **A managed identity** for authentication.  
  - **A randomly generated DNS prefix** to avoid conflicts.  
  - **A specific Kubernetes version**.  
  - A **node pool** with a defined **VM size** and **node count**.  
  - **Networking configured** with `kubenet` and a Load Balancer.  

### 3. **PostgreSQL Flexible Server**  
- Deploys a **PostgreSQL flexible server** in **France Central** (defined in `locals`).  
- Uses **PostgreSQL version 16**.  
- Configures:  
  - **Admin credentials** for database access.  
  - **SKU tier** for database performance.  
  - **Public network access enabled** (which may be a security risk in production).  

### 4. **PostgreSQL Database**  
- Creates a **database on the PostgreSQL server**.  
- Sets up **UTF-8 collation** for better compatibility with different languages.  

### 5. **PostgreSQL Firewall Rule**  
- Defines a **firewall rule** allowing access from **all IP addresses (`0.0.0.0/0`)**, making it publicly accessible (which is insecure for production environments).  

## Summary  
This Terraform configuration automates the deployment of:  
- **An AKS cluster** for running containerized applications.  
- **A PostgreSQL database** for data storage.  
- **Networking and access settings** configurable via Terraform variables.  

## Potential Improvements  
- **Security risk:** The firewall allows all IPs (`0.0.0.0/0`), which should be restricted.  
- **Performance tuning:** The PostgreSQL storage and performance settings could be further optimized.  

# #########################################

# Automating Keycloak Deployment on Azure Kubernetes Service (AKS)

## Overview  
This script automates the deployment of **Keycloak** on **Azure Kubernetes Service (AKS)** using **Helm** and configures an **NGINX Ingress Controller** for external access.

## Steps  

### 1. **Set Up Environment Variables**  
- Defines key variables such as:  
  - **Namespace**  
  - **Resource group name**  
  - **AKS cluster name**  
  - **Helm chart names**  
  - **PostgreSQL password**  
- Displays these variables in the terminal for reference.  

### 2. **Connect to the AKS Cluster**  
- Retrieves **AKS credentials** and sets them in the local environment.  
- Lists existing Kubernetes deployments to verify the connection.  

### 3. **Install and Configure Ingress Controller**  
- Adds the **ingress-nginx** Helm repository and updates it.  
- Creates a **Kubernetes namespace** for the deployment.  
- Generates a **TLS secret** using SSL certificates for secure HTTPS communication.  
- Deploys the **NGINX Ingress Controller** using Helm with a **LoadBalancer** service type.  

### 4. **Wait for External IP Assignment**  
- Continuously checks if the **Ingress Controller's LoadBalancer** has been assigned an external IP address.  
- Displays the assigned external IP once available.  

### 5. **Deploy Keycloak Using Helm**  
- Installs or upgrades the **Keycloak Helm chart** while setting the PostgreSQL password.  
- Ensures the Keycloak pod is running before proceeding.  

### 6. **Deploy Ingress Configuration**  
- Installs or upgrades an **Ingress Helm chart** for managing external access to Keycloak.  
- Describes the **Ingress class** and the specific Ingress resource for Keycloak to verify configurations.  

### 7. **Validate Deployment and Test Keycloak Access**  
- Waits for the **Keycloak pod to be fully ready**.  
- Attempts to access Keycloak via **HTTPS** using `curl`, resolving the domain name to the assigned **external IP**.  

## Summary  
This script **automates** the entire Keycloak deployment process on AKS by:  
✅ **Provisioning and configuring AKS**  
✅ **Installing an Ingress Controller for external access**  
✅ **Deploying Keycloak with PostgreSQL as its database**  
✅ **Ensuring security with TLS encryption**  
✅ **Verifying the deployment and testing Keycloak accessibility**  

## Technologies Used  
- **Azure Kubernetes Service (AKS)** – Manages containerized applications.  
- **Helm** – Simplifies deployment of Kubernetes applications.  
- **NGINX Ingress Controller** – Manages external access to services.  
- **PostgreSQL** – Database for Keycloak.  
- **Kubernetes (kubectl)** – Manages cluster resources.  

Let me know if you need any modifications! 🚀


# keycloak-identity-and-access-management-aks

terraform workspace new dev

terraform workspace select dev

terraform init -var-file="dev.tfvars"

terraform plan  -var-file="dev.tfvars" -var "postgresql_server_admin_password=passer@123!"  -out="terraform.tfplan"
  
terraform apply terraform.tfplan 



# testing

![pods](https://github.com/user-attachments/assets/854fd31d-c702-4e39-baa0-7a38f5f26594)

![service](https://github.com/user-attachments/assets/0dc0e0d4-9add-4f53-976d-be19ccde3832)

![dns](https://github.com/user-attachments/assets/a3443a4d-4fd4-43ca-8af2-fedc017835bd)

![nslookup](https://github.com/user-attachments/assets/c512e346-50d7-411a-8063-3592e4e3c34f)

![browser](https://github.com/user-attachments/assets/5fec895a-8dbf-4e6d-b8ab-0c639c58d38a)




