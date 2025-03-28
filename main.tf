module "management_security_group_rules" {
  for_each = { for r in local.mgmt_rules : r.description => r }
  source   = "./modules/security_group_rules"

  description = each.key
  rule_definition = {
    type        = each.value.type
    from_port   = each.value.from_port
    to_port     = each.value.to_port
    protocol    = each.value.protocol
    cidr_blocks = each.value.cidr_blocks
  }
  security_group_id = var.management_security_group_id == "" ? module.management_nic_security_group[0].id : var.management_security_group_id
}

module "monitoring_security_group_rules" {
  for_each = { for r in local.mon_rules : r.description => r }
  source   = "./modules/security_group_rules"

  description = each.key
  rule_definition = {
    type        = each.value.type
    from_port   = each.value.from_port
    to_port     = each.value.to_port
    protocol    = each.value.protocol
    cidr_blocks = each.value.cidr_blocks

  }
  security_group_id = var.monitoring_security_group_id == "" ? module.monitoring_nic_security_group[0].id : var.monitoring_security_group_id
}

module "monitoring_nic_security_group" {
  count  = var.monitoring_security_group_id == "" ? 1 : 0
  source = "./modules/security_group"

  security_group_name        = var.monitoring_security_group.name
  security_group_description = var.management_security_group.description
  vpc_id                     = var.monitoring_security_group.vpc_id
}

module "management_nic_security_group" {
  count  = var.management_security_group_id == "" ? 1 : 0
  source = "./modules/security_group"

  security_group_name        = var.management_security_group.name
  security_group_description = var.management_security_group.description
  vpc_id                     = var.management_security_group.vpc_id
}

module "management_interface" {
  count  = var.management_interface_id == "" ? 1 : 0
  source = "./modules//network_interface"

  associate_public_ip_address = var.management_interface.associate_public_ip_address
  interface_name              = var.management_interface.name
  security_group_ids          = var.management_security_group_id == "" ? [module.management_nic_security_group[0].id] : [var.management_security_group_id]
  subnet_id                   = var.management_interface.subnet_id
}

module "monitoring_interface" {
  count  = var.monitoring_interface_id == "" ? 1 : 0
  source = "./modules//network_interface"

  associate_public_ip_address = false
  interface_name              = var.monitoring_interface.name
  security_group_ids          = var.monitoring_security_group_id == "" ? [module.monitoring_nic_security_group[0].id] : [var.monitoring_security_group_id]
  subnet_id                   = var.monitoring_interface.subnet_id
}

module "config" {
  count  = var.custom_sensor_user_data == "" ? 1 : 0
  source = "github.com/corelight/terraform-config-sensor?ref=v0.3.0"

  fleet_community_string = var.fleet_community_string
  sensor_license         = var.license_key_file_path != "" ? file(var.license_key_file_path) : null

  sensor_management_interface_name = "eth1"
  sensor_monitoring_interface_name = "eth0"

  fleet_token          = var.license_key_file_path == "" ? var.fleet_config.token : null
  fleet_url            = var.license_key_file_path == "" ? var.fleet_config.url : null
  fleet_server_sslname = var.license_key_file_path == "" ? var.fleet_config.server_ssl_name : null
  fleet_http_proxy     = var.license_key_file_path == "" ? var.fleet_config.http_proxy : null
  fleet_https_proxy    = var.license_key_file_path == "" ? var.fleet_config.https_proxy : null
  fleet_no_proxy       = var.license_key_file_path == "" ? var.fleet_config.no_proxy : null
}

module "instance" {
  source = "./modules//instance"

  aws_key_pair_name       = var.aws_key_pair_name
  corelight_sensor_ami_id = var.ami_id
  ebs_volume_size         = var.ebs_volume_size
  instance_name           = var.instance_name
  instance_type           = var.instance_type
  network_interfaces = var.monitoring_interface != null && var.management_interface != null ? [
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

locals {
  mgmt_rules = [local.default_egress_rule, local.ssh_ingress_rule]
  mon_rules  = [local.default_egress_rule, local.mirror_ingress_rule, local.health_check_ingress_rule]
  default_egress_rule = {
    # rule = {
    type = "egress"
    from_port : 0
    to_port : 0
    protocol : "-1"
    cidr_blocks : ["0.0.0.0/0"]
    # }
    description : "Default Egress Rule"
  }
  ssh_ingress_rule = {
    # rule = {
    type = "ingress"
    from_port : 22
    to_port : 22
    protocol : "tcp"
    cidr_blocks : var.ssh_allow_cidrs
    # }
    description : "SSH for Corelight Sensor Admins"
  }
  mirror_ingress_rule = {
    # rule = {
    type = "ingress"
    from_port : 6081
    to_port : 6081
    protocol : "udp"
    cidr_blocks : ["0.0.0.0/0"]
    # }
    description : "GENEVE ingress for GWLB mirror"
  }
  health_check_ingress_rule = {
    # rule = {
    type = "ingress"
    from_port : 41080
    to_port : 41080
    protocol : "tcp"
    cidr_blocks : ["0.0.0.0/0"]
    # }
    description : "Health Check Rule"
  }
}


