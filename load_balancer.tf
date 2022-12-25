resource "azurerm_public_ip" "load_ip" {
  name                = "load-ip"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_lb" "app_lb" {
  name                = "app_loadbalancer"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.load_ip.id
  }
  depends_on = [
    azurerm_public_ip.load_ip
  ]
}

resource "azurerm_lb_backend_address_pool" "PoolA" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name            = "PoolA"
  depends_on = [
    azurerm_lb.app_lb
  ]
}

resource "azurerm_lb_backend_address_pool_address" "appvm1-address" {
  name                                = "appvm1-address"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.PoolA.id
  virtual_network_id = azurerm_virtual_network.app_network.id
  ip_address = azurerm_network_interface.app_interface1.private_ip_address
}

resource "azurerm_lb_backend_address_pool_address" "appvm2-address" {
  name                                = "appvm2-address"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.PoolA.id
  virtual_network_id = azurerm_virtual_network.app_network.id
  ip_address = azurerm_network_interface.app_interface2.private_ip_address
}

resource "azurerm_lb_probe" "ProbeA" {
  loadbalancer_id = azurerm_lb.app_lb.id
  name            = "ProbeA"
  port            = 80
}

resource "azurerm_lb_rule" "ruleA" {
  loadbalancer_id                = azurerm_lb.app_lb.id
  name                           = "ruleA"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.PoolA.id ]
  probe_id = azurerm_lb_probe.ProbeA.id
  depends_on = [
    azurerm_lb.app_lb
  ]
}