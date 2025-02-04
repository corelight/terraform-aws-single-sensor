resource "aws_security_group" "management_sg" {
  name        = var.management_security_group_name
  description = var.management_security_group_description
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "mgmt_network_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.management_sg.id
  description       = "Default egress rule"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "management_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.management_sg.id

  cidr_blocks = var.ssh_allow_cidrs
  description = "SSH for Corelight Sensor Admins"
}


resource "aws_security_group" "monitoring_sg" {
  name        = var.monitoring_security_group_name
  description = var.monitoring_security_group_description
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "mon_ingress" {
  type              = "ingress"
  from_port         = 6081
  to_port           = 6081
  protocol          = "udp"
  security_group_id = aws_security_group.monitoring_sg.id
  description       = "GENEVE ingress for GWLB mirror"
  cidr_blocks       = var.mirror_allow_cidrs
}

resource "aws_security_group_rule" "mon_health_check_rule" {
  type              = "ingress"
  from_port         = 41080
  to_port           = 41080
  protocol          = "tcp"
  security_group_id = aws_security_group.monitoring_sg.id
  description       = "GWLB Health Check Port"
  cidr_blocks       = var.mirror_allow_cidrs
}

resource "aws_security_group_rule" "mon_network_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.monitoring_sg.id
  description       = "Default egress rule"
  cidr_blocks       = ["0.0.0.0/0"]
}
