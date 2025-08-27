# Trust policy document that allows the external role to assume this role
data "aws_iam_policy_document" "assume_role_trust_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.trusted_account_id}:role/${var.trusted_role_name}"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# IAM role that can be assumed by the external account
resource "aws_iam_role" "cross_account_assume_role" {
  name               = var.assume_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_trust_policy.json

  tags = {
    Name           = var.assume_role_name
    Purpose        = "Corelight VPC Flow Sensor Cross-account Role Assumption"
    TrustedAccount = var.trusted_account_id
  }
}

# Custom inline policy for specific permissions
resource "aws_iam_role_policy" "cross_account_custom_policy" {
  name = "${var.assume_role_name}-custom-policy"
  role = aws_iam_role.cross_account_assume_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeVpcs",
          "ec2:DescribeFlowLogs"
        ],
        "Resource" : "*"
      }
    ]
  })
}
