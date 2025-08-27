# Variables for cross-account role assumption
variable "trusted_account_id" {
  description = "The AWS account ID that is allowed to assume this role"
  type        = string
}

variable "trusted_role_name" {
  description = "The name of the role in the trusted account that can assume this role"
  type        = string
}

variable "assume_role_name" {
  description = "The name of the role to create in this account"
  type        = string
}