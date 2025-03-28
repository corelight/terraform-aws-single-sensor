variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the Corelight Sensor"
}

variable "region" {
  type        = string
  description = "The region to deploy resources into"
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
  type    = string
  default = ""
}

variable "management_interface" {
  type = object({
    name : string
    index : number
    subnet_id : string
    associate_public_ip_address : bool
  })
  default = null
}

variable "monitoring_interface_id" {
  type    = string
  default = ""
}

variable "monitoring_interface" {
  type = object({
    name : string
    index : number
    subnet_id : string
  })
  default = null
}

variable "monitoring_security_group" {
  type = object({
    name : string
    description : string
    vpc_id : string
  })
  default = null
}

variable "monitoring_security_group_id" {
  type    = string
  default = ""
}

variable "management_security_group" {
  type = object({
    name : string
    description : string
    vpc_id : string
  })
  default = null
}

variable "management_security_group_id" {
  type    = string
  default = ""
}

variable "ssh_allow_cidrs" {
  description = "List of CIDRs from which SSH access is allowed"
  type        = list(string)
}

variable "mirror_allow_cidrs" {
  description = "List of CIDRs from which GENEVE traffic can be mirrored from"
}

## Defaults
variable "associate_public_ip_address" {
  description = "Associate a public IP address with the sensor management NIC"
  type        = bool
  default     = false
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

variable "management_network_interface_name" {
  description = "The name of the management network interface for the sensor"
  type        = string
  default     = "corelight-sensor-nic"
}

variable "monitoring_network_interface_name" {
  description = "The name of the monitoring network interface for the sensor"
  type        = string
  default     = "corelight-sensor-nic"
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

variable "management_security_group_name" {
  description = "The Name of the Sensor Security Group"
  type        = string
  default     = "corelight-management-sg"
}

variable "monitoring_security_group_name" {
  description = "The Name of the Sensor Security Group"
  type        = string
  default     = "corelight-management-sg"
}

variable "tags" {
  description = "Any tags that should be applied to resources deployed by the module"
  type        = object({})
  default     = {}
}

variable "license_key_file_path" {
  description = "The path to your Corelight sensor license key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "fleet_config" {
  type = object({
    token           = string
    url             = string
    server_ssl_name = string
    http_proxy      = string
    https_proxy     = string
    no_proxy        = string
  })
  description = "(optional) Configuration for Fleet"
  sensitive   = true
  default     = null
}
