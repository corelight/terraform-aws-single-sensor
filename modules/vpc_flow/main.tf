module "sensor" {
  source = "../../"

  corelight_sensor_ami_id               = var.corelight_sensor_ami_id
  region                                = var.region
  vpc_id                                = var.vpc_id
  management_subnet_id                  = var.management_subnet_id
  monitoring_subnet_id                  = var.monitoring_subnet_id
  fleet_community_string                = var.fleet_community_string
  mirror_allow_cidrs                    = var.mirror_allow_cidrs
  ssh_allow_cidrs                       = var.ssh_allow_cidrs
  aws_key_pair_name                     = var.aws_key_pair_name
  license_key_file_path                 = var.license_key_file_path
  management_security_group_name        = var.management_security_group_name
  monitoring_security_group_name        = var.monitoring_security_group_name
  associate_public_ip_address           = var.associate_public_ip_address
  instance_name                         = var.instance_name
  management_network_interface_name     = var.management_network_interface_name
  monitoring_network_interface_name     = var.monitoring_network_interface_name
  instance_type                         = var.instance_type
  ebs_volume_size                       = var.ebs_volume_size
  management_security_group_description = var.management_security_group_description
  monitoring_security_group_description = var.monitoring_security_group_description
  custom_sensor_user_data               = data.cloudinit_config.config.rendered
}


resource "aws_iam_instance_profile" "sensor_profile" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.vpc_flow_sensor_role.name
}
