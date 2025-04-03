locals {
  mgmt_rules = [local.default_egress_rule, local.ssh_ingress_rule]
  mon_rules  = [local.default_egress_rule, local.mirror_ingress_rule, local.health_check_ingress_rule]
  default_egress_rule = {
    type = "egress"
    from_port : 0
    to_port : 0
    protocol : "-1"
    cidr_blocks : var.egress_allow_cidrs
    description : "Default Egress Rule"
  }
  ssh_ingress_rule = {
    type = "ingress"
    from_port : 22
    to_port : 22
    protocol : "tcp"
    cidr_blocks : var.ssh_allow_cidrs
    description : "SSH for Corelight Sensor Admins"
  }
  mirror_ingress_rule = {
    type = "ingress"
    from_port : 6081
    to_port : 6081
    protocol : "udp"
    cidr_blocks : var.mirror_ingress_allow_cidrs
    description : "GENEVE ingress for GWLB mirror"
  }
  health_check_ingress_rule = {
    type = "ingress"
    from_port : 41080
    to_port : 41080
    protocol : "tcp"
    cidr_blocks : var.health_check_allow_cidrs
    description : "Health Check Rule"
  }
}