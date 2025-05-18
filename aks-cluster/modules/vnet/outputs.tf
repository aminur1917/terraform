output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  value = {
    for i, name in var.subnet_names :
    name => azurerm_subnet.subnets[i].id
  }
}
