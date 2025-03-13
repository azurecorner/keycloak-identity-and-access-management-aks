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




