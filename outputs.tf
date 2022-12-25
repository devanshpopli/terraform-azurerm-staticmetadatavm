output "public_IP"{
    description = "Public IP address of Load Balancer"
    value = azurerm_public_ip.load_ip.ip_address
}
