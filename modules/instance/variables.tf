variable "instance_name" {
  type = string
}

variable "corelight_sensor_ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "user_data" {
  type = string
}

variable "aws_key_pair_name" {
  type = string
}

variable "ebs_volume_size" {
  type = number
}

variable "network_interfaces" {
  type = list(object({
    id : string
    index : string
  }))
}

variable "iam_instance_profile_name" {
  type    = string
  default = ""
}

variable "tags" {
  type    = object({})
  default = {}
}

