resource "aws_instance" "this" {
  ami           = var.corelight_sensor_ami_id
  instance_type = var.instance_type
  user_data     = var.user_data
  key_name      = var.aws_key_pair_name

  iam_instance_profile = var.iam_instance_profile_name != "" ? var.iam_instance_profile_name : null

  root_block_device {
    volume_size = var.ebs_volume_size
    encrypted   = true
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      device_index         = network_interface.value.index
      network_interface_id = network_interface.value.id
    }
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = { Name = var.instance_name }
}
