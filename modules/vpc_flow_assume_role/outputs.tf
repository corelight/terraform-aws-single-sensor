# Outputs
output "assume_role_arn" {
  description = "ARN of the role that can be assumed"
  value       = aws_iam_role.cross_account_assume_role.arn
}

output "assume_role_name" {
  description = "Name of the role that can be assumed"
  value       = aws_iam_role.cross_account_assume_role.name
}

output "trusted_account_id" {
  description = "The account ID that is trusted to assume this role"
  value       = var.trusted_account_id
}
