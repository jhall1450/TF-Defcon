output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_ip_address" {
  value = azurerm_linux_virtual_machine.dedcon-vm.public_ip_address
}
