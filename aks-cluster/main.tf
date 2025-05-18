provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_name           = var.vnet_name
  address_space       = ["10.0.0.0/8"]
  subnet_names        = ["aks-subnet", "app-subnet"]
  subnet_prefixes     = ["10.240.0.0/16", "10.241.0.0/16"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "aks-${var.aks_name}"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = module.vnet.subnet_ids["aks-subnet"]
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.2.0.10"
    service_cidr   = "10.2.0.0/24"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  tags = {
    environment = "dev"
  }
}
