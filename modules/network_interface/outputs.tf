output "network_interface_id" {
  value = aws_network_interface.this.id
}

output "aws_eip_id" {
  value = var.associate_public_ip_address ? aws_eip.this[0].id : ""
}

output "network_interface" {
  value = {
    id : aws_network_interface.this.id
  }
}