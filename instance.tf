resource "aws_instance" "corelight_sensor" {
  ami           = var.corelight_sensor_ami_id
  instance_type = var.instance_type
  user_data     = var.custom_sensor_user_data == "" ? module.config[0].cloudinit_config.rendered : var.custom_sensor_user_data
  key_name      = var.aws_key_pair_name

  iam_instance_profile = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : null
  root_block_device {
    volume_size = var.ebs_volume_size
    encrypted   = true
  }

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.monitoring_interface.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.management_interface.id
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}

resource "aws_network_interface" "management_interface" {
  subnet_id       = var.management_subnet_id
  security_groups = [aws_security_group.management_sg.id]

  tags = merge(var.tags, {
    Name = var.management_network_interface_name
  })
}

resource "aws_eip" "management_eip" {
  count             = var.associate_public_ip_address ? 1 : 0
  network_interface = aws_network_interface.management_interface.id
}


resource "aws_network_interface" "monitoring_interface" {
  subnet_id       = var.monitoring_subnet_id
  security_groups = [aws_security_group.monitoring_sg.id]

  tags = merge(var.tags, {
    Name = var.monitoring_network_interface_name
  })
}
