ressource_group_name     = "datasynchro-dev-rg"
hub_ressource_group_name = "RG-DATASYNCHRO-HUB"
location                 = "eastus"
tags = {
  environment = "dev"
  application = "datasynchro"
  deployed_by = "terraform"
}

# kubernetes cluster variables
kubernetes_cluster_name       = "datasynchro-dev-aks"
kubernetes_cluster_vm_size    = "Standard_D2_v2"
kubernetes_cluster_node_count = 3
kubernetes_cluster_lb_sku     = "standard"
kubernetes_cluster_node_admin = "datasynchroadmin"
kubernetes_sku_tier           = "Standard" # Free, Standard, Premium

# PostgreSQL variables
postgresql_server_name = "datasynchrodevpg"
postgresql_server_sku  = "B_Gen5_1"

postgresql_server_admin_login = "datasynchro"
postgresql_database_name      = "datasynchro"

