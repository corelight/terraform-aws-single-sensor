variable "security_group_id" {
  type = string
}

variable "description" {
  type = string
}

variable "rule_definition" {
  type = object({
    type : string
    from_port : number
    to_port : number
    protocol : string
    cidr_blocks : list(string)
  })
}

