variable "ami_id" {
  description = "The AMI ID provided by Corelight"
  type        = string
}

variable "aws_key_pair_name" {
  description = "The name of the AWS key pair that will be used to access the sensor instances in the auto-scale group"
  type        = string
}

variable "fleet_community_string" {
  description = "the fleet manager community string (api string)"
  type        = string
  sensitive   = true
}

variable "management_interface_id" {
  description = "Used in place of the 'management_interface' variable if you would like to provide one"
  type        = string
  default     = ""
}

variable "management_interface_name" {
  description = "The name of the management interface for the sensor"
  type        = string
  default     = "corelight-mgmt-nic"
}

variable "management_interface_subnet_id" {
  description = "The subnet id of the management interface for the sensor"
  type        = string
  default     = ""
}

variable "management_interface_public_ip" {
  description = "The flag to determine if the management interface for the sensor should have a publicly assigned IP address"
  type        = bool
  default     = false
}

variable "monitoring_interface_id" {
  description = "The ID of a pre-exiting ENI if you would rather create it outside of the module"
  type        = string
  default     = ""
}

variable "monitoring_interface_name" {
  description = "The name of the monitoring interface for the sensor"
  type        = string
  default     = "corelight-mon-nic"
}

variable "monitoring_interface_subnet_id" {
  description = "Subnet where the monitoring ENI should reside"
  type        = string
  default     = ""
}

variable "monitoring_security_group_id" {
  description = "Used in place of the 'monitoring_security_group' variable if you would like to provide one"
  type        = string
  default     = ""
}

variable "monitoring_security_group_name" {
  description = "Name of the security group the module will provision for the monitoring ENI"
  type        = string
  default     = "corelight-sensor-mon-sg"
}

variable "monitoring_security_group_description" {
  description = "Description of the monitoring ENI security group"
  type        = string
  default     = "Corelight Sensor Monitoring SG"
}

variable "monitoring_security_group_vpc_id" {
  description = "Security group VPC ID module will use to provision the monitoring ENI security group"
  type        = string
  default     = ""
}

variable "management_security_group_id" {
  description = "Used in place of the 'management_security_group' variable if you would like to provide one"
  type        = string
  default     = ""
}

variable "management_security_group_name" {
  description = "Name of the security group the module will provision for the management ENI"
  type        = string
  default     = "corelight-sensor-mgmt-sg"
}

variable "management_security_group_description" {
  description = "Description of the management ENI security group"
  type        = string
  default     = "Corelight Sensor Managment SG"
}

variable "management_security_group_vpc_id" {
  description = "Security group VPC ID module will use to provision the management ENI security group"
  type        = string
  default     = ""
}

variable "custom_sensor_user_data" {
  description = "Custom user data for a sensor if the default doesn't apply"
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "The name for the sensor EC2 instance"
  type        = string
  default     = "corelight-sensor"
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
  default     = "c5.2xlarge"
}

variable "ebs_volume_size" {
  description = "The size, in GB, of the EBS volume to be attached to the instance. Not recommended to set lower than 500GB"
  type        = number
  default     = 500
}

variable "license_key_file_path" {
  description = "The path to your Corelight sensor license key. This must be provided if not licensing through fleet"
  type        = string
  sensitive   = true
  default     = ""
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile that should be attached to the EC2 instance"
  type        = string
  default     = ""
}


variable "fleet_token" {
  description = "(optional) the pairing token from the Fleet UI. Must be set if 'fleet_url' is provided"
  type        = string
  default     = ""
  sensitive   = true
}

variable "fleet_url" {
  description = "(optional) the URL of the fleet instance from the Fleet UI. Must be set if 'fleet_token' is provided"
  type        = string
  default     = ""
}

variable "fleet_server_sslname" {
  description = "(optional) the SSL hostname for the fleet server"
  type        = string
  default     = "1.broala.fleet.product.corelight.io"
}

variable "fleet_http_proxy" {
  description = "(optional) the proxy URL for HTTP traffic from the fleet"
  type        = string
  default     = ""
}

variable "fleet_https_proxy" {
  description = "(optional) the proxy URL for HTTPS traffic from the fleet"
  type        = string
  default     = ""
}

variable "fleet_no_proxy" {
  description = "(optional) hosts or domains to bypass the proxy for fleet traffic"
  type        = string
  default     = ""
}

variable "egress_allow_cidrs" {
  description = "The IP range allowed outbound for both network interfaces. Typically can be left as default"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_allow_cidrs" {
  description = "List of IPs (/32) to grant access to port 22"
  type        = list(string)
  default     = []
}

variable "mirror_ingress_allow_cidrs" {
  description = "IP range to allow EC2 mirroring. Typically the CIDR of the VPC being monitored"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "health_check_allow_cidrs" {
  description = "IP range to allow health checks. Typically the CIDR of the VPC being monitored"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}