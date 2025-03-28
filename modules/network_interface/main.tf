resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id
  security_groups = var.security_group_ids

  tags = merge(var.tags, {
    Name = var.interface_name
  })
}

resource "aws_eip" "this" {
  count             = var.associate_public_ip_address ? 1 : 0
  network_interface = aws_network_interface.this.id
}
