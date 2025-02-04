corelight_sensor_ami_id = "ami-123456789"
region                  = "us-east-1"
vpc_id                  = "vpc-123456789"
management_subnet_id    = "subnet-987654321"
monitoring_subnet_id    = "subnet-123456789"
fleet_community_string  = "SuperAwes0meP@ssw0rd"
mirror_allow_cidrs      = ["10.0.0.0/8"]
ssh_allow_cidrs         = ["10.10.10.10/24"]
tags = {
  Owner   = "joe.dirt@corelight.com"
  Team    = "Cloud Security"
  Purpose = "Corelight Sensor"
}
