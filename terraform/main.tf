locals {
  db_location = "francecentral"
}
resource "azurerm_resource_group" "resource_group" {
  name     = var.ressource_group_name
  location = var.location
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "azurerm_kubernetes_cluster" "kubernetes_cluster" {
  name                = var.kubernetes_cluster_name
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id


  identity {
    type         = "SystemAssigned"

  }

  kubernetes_version = "1.30.7"
  sku_tier           = var.kubernetes_sku_tier

  default_node_pool {
    name           = "agentpool"
    vm_size        = var.kubernetes_cluster_vm_size
    node_count     = var.kubernetes_cluster_node_count

  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = var.kubernetes_cluster_lb_sku
  }


  tags = (merge(var.tags, tomap({
    type = "kubernetes_cluster"
    })
  ))

  depends_on = [azurerm_resource_group.resource_group]
}

resource "azurerm_postgresql_flexible_server" "postgresql_flexible_server" {
  name                = "${var.postgresql_server_name}-srv"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = local.db_location
  version             = 16

  administrator_login           = var.postgresql_server_admin_login
  administrator_password        = var.postgresql_server_admin_password

  sku_name                      = "B_Standard_B1ms"
  public_network_access_enabled = true

  tags = (merge(var.tags, tomap({
    type = "postgresql_flexible_server"
    })
  ))

  depends_on = [azurerm_resource_group.resource_group]

}

resource "azurerm_postgresql_flexible_server_database" "postgresql_flexible_server_database" {
  name      = var.postgresql_database_name
  server_id = azurerm_postgresql_flexible_server.postgresql_flexible_server.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  depends_on = [azurerm_postgresql_flexible_server.postgresql_flexible_server]
}
