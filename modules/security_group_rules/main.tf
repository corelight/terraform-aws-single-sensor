resource "aws_security_group_rule" "this" {
  type              = var.rule_definition.type
  from_port         = var.rule_definition.from_port
  to_port           = var.rule_definition.to_port
  protocol          = var.rule_definition.protocol
  security_group_id = var.security_group_id
  description       = var.description
  cidr_blocks       = var.rule_definition.cidr_blocks
}
