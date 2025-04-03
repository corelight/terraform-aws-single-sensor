variable "ami_id" {
  description = "The AMI ID provided by Corelight"
  type        = string
}

variable "aws_key_pair_name" {
  description = "The name of the AWS key pair that will be used to access the sensor instances in the auto-scale group"
  type        = string
}

variable "fleet_community_string" {
  description = "the Fleet Manager community string (api string)"
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
  description = ""
  type        = string
  default     = ""
}

variable "monitoring_security_group_id" {
  description = "Used in place of the 'monitoring_security_group' variable if you would like to provide one"
  type        = string
  default     = ""
}

variable "monitoring_security_group_name" {
  description = ""
  type        = string
  default     = "corelight-sensor-mon-sg"
}

variable "monitoring_security_group_description" {
  description = ""
  type        = string
  default     = "Corelight Sensor Monitoring SG"
}

variable "monitoring_security_group_vpc_id" {
  description = ""
  type        = string
  default     = ""
}

variable "management_security_group_id" {
  description = "Used in place of the 'management_security_group' variable if you would like to provide one"
  type        = string
  default     = ""
}

variable "management_security_group_name" {
  description = ""
  type        = string
  default     = "corelight-sensor-mgmt-sg"
}

variable "management_security_group_description" {
  description = ""
  type        = string
  default     = "Corelight Sensor Managment SG"
}

variable "management_security_group_vpc_id" {
  description = ""
  type        = string
  default     = ""
}

variable "custom_sensor_user_data" {
  description = "custom user data for a sensor if the default doesn't apply"
  type        = string
  default     = ""
}

variable "instance_name" {
  type        = string
  description = "The instance name for the instance"
  default     = "corelight-sensor"
}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
  default     = "c5.2xlarge"
}

variable "ebs_volume_size" {
  description = "The size, in GB of the EBS volume to be attached to the instance"
  type        = number
  default     = 500
}

variable "license_key_file_path" {
  description = "The path to your Corelight sensor license key. This must be provided if not licensing through fleet"
  type        = string
  sensitive   = true
  default     = ""
}

variable "fleet_config" {
  description = "(optional) Configuration for Fleet. This can be used in place of `license_key_file_path` for licensing the sensor"
  type = object({
    token           = string
    url             = string
    server_ssl_name = string
    http_proxy      = string
    https_proxy     = string
    no_proxy        = string
  })

  sensitive = true
  default = {
    token           = ""
    url             = ""
    server_ssl_name = ""
    http_proxy      = ""
    https_proxy     = ""
    no_proxy        = ""
  }
}

variable "egress_allow_cidrs" {
  description = ""
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ssh_allow_cidrs" {
  description = ""
  type        = list(string)
  default     = []
}

variable "mirror_ingress_allow_cidrs" {
  description = ""
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "health_check_allow_cidrs" {
  description = ""
  type        = list(string)
  default     = ["0.0.0.0/0"]
}