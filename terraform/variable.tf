variable "ressource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "hub_ressource_group_name" {
  description = "Name of the hub resource group"
  type        = string

}
variable "location" {
  description = "Location of the resource group"
  type        = string

}


variable "tags" {
  type = map(string)
  default = {
    "application" = "datasynchro"
  }
  description = "A mapping of tags to assign to the resource."
}



variable "kubernetes_cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string

}

variable "kubernetes_cluster_vm_size" {
  description = "value of the VM size"
  type        = string
}

variable "kubernetes_cluster_node_count" {
  description = "Number of nodes in the cluster"
  type        = number

}

variable "kubernetes_cluster_lb_sku" {
  description = "SKU of the load balancer"
  type        = string

}

variable "kubernetes_cluster_node_admin" {
  description = "Admin of the Kubernetes cluster"
  type        = string

}
variable "kubernetes_sku_tier" {
  description = "Tier of the SKU"
  type        = string

}


# PostgreSQL variables
variable "postgresql_server_name" {
  type        = string
  description = "value of the PostgreSQL server name"

}

variable "postgresql_server_sku" {
  type        = string
  description = "value of the PostgreSQL server SKU"

}

variable "postgresql_server_admin_login" {
  type        = string
  description = "value of the PostgreSQL server admin login"

}

variable "postgresql_server_admin_password" {
  type        = string
  description = "value of the PostgreSQL server admin password"

}

variable "postgresql_database_name" {
  type        = string
  description = "value of the PostgreSQL database name"
}


