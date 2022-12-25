output "publicIPaddress"{
    value = azurerm_public_ip.load_ip.ip_address
}

output "fqdn"{
    value = azurerm_public_ip.load_ip.fqdn
}