# keycloak-identity-and-access-management-aks

terraform workspace new dev

terraform workspace select dev

terraform init -var-file="dev.tfvars"

terraform plan  -var-file="dev.tfvars" -var "postgresql_server_admin_password=passer@123!"  -out="terraform.tfplan"
  
terraform apply terraform.tfplan 