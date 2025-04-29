resource "aws_security_group_rule" "management_rules" {
  for_each = { for r in local.mgmt_rules : r.description => r }

  description       = each.key
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = var.management_security_group_id == "" ? aws_security_group.management_sg[0].id : var.monitoring_security_group_id
}

resource "aws_security_group_rule" "monitoring_rules" {
  for_each = { for r in local.mon_rules : r.description => r }

  description       = each.key
  type              = each.value.type
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  security_group_id = var.monitoring_security_group_id == "" ? aws_security_group.monitoring_sg[0].id : var.monitoring_security_group_id
}

resource "aws_security_group" "monitoring_sg" {
  count       = var.monitoring_security_group_id == "" ? 1 : 0
  name        = var.monitoring_security_group_name
  description = var.monitoring_security_group_description
  vpc_id      = var.monitoring_security_group_vpc_id
}

resource "aws_security_group" "management_sg" {
  count       = var.management_security_group_id == "" ? 1 : 0
  name        = var.management_security_group_name
  description = var.management_security_group_description
  vpc_id      = var.management_security_group_vpc_id
}

module "management_interface" {
  count  = var.management_interface_id == "" ? 1 : 0
  source = "./modules//network_interface"

  associate_public_ip_address = var.management_interface_public_ip
  interface_name              = var.management_interface_name
  security_group_ids          = var.management_security_group_id == "" ? [aws_security_group.management_sg[0].id] : [var.management_security_group_id]
  subnet_id                   = var.management_interface_subnet_id
}

module "monitoring_interface" {
  count  = var.monitoring_interface_id == "" ? 1 : 0
  source = "./modules//network_interface"

  associate_public_ip_address = false
  interface_name              = var.monitoring_interface_name
  security_group_ids          = var.monitoring_security_group_id == "" ? [aws_security_group.monitoring_sg[0].id] : [var.monitoring_security_group_id]
  subnet_id                   = var.monitoring_interface_subnet_id
}

module "config" {
  count  = var.custom_sensor_user_data == "" ? 1 : 0
  source = "github.com/corelight/terraform-config-sensor?ref=v0.3.0"

  fleet_community_string = var.fleet_community_string
  sensor_license         = var.license_key_file_path != "" ? file(var.license_key_file_path) : ""

  sensor_management_interface_name = "eth1"
  sensor_monitoring_interface_name = "eth0"

  fleet_token          = var.license_key_file_path == "" ? var.fleet_token : ""
  fleet_url            = var.license_key_file_path == "" ? var.fleet_url : ""
  fleet_server_sslname = var.license_key_file_path == "" ? var.fleet_server_sslname : ""
  fleet_http_proxy     = var.license_key_file_path == "" ? var.fleet_http_proxy : ""
  fleet_https_proxy    = var.license_key_file_path == "" ? var.fleet_https_proxy : ""
  fleet_no_proxy       = var.license_key_file_path == "" ? var.fleet_no_proxy : ""
}

module "instance" {
  source = "./modules//instance"

  aws_key_pair_name         = var.aws_key_pair_name
  corelight_sensor_ami_id   = var.ami_id
  ebs_volume_size           = var.ebs_volume_size
  instance_name             = var.instance_name
  instance_type             = var.instance_type
  iam_instance_profile_name = var.iam_instance_profile_name
  network_interfaces = var.monitoring_interface_id == "" && var.management_interface_id == "" ? [
    {
      id    = module.monitoring_interface[0].network_interface_id,
      index = 0,

    },
    {
      id    = module.management_interface[0].network_interface_id,
      index = 1,
    }
    ] : [
    {
      id    = var.monitoring_interface_id,
      index = 0,
    },
    {
      id    = var.management_interface_id,
      index = 1,
    }
  ]

  user_data = var.custom_sensor_user_data == "" ? module.config[0].cloudinit_config.rendered : var.custom_sensor_user_data
}
