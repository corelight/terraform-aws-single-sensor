variable "subnet_id" {
  type = string
}

variable "interface_name" {
  type = string
}

variable "associate_public_ip_address" {
  type = bool
}

variable "security_group_ids" {
  type = list(string)
}

variable "tags" {
  type    = object({})
  default = {}
}

