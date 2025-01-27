resource "aws_iam_role" "vpc_flow_sensor_role" {
  name = var.vpc_flow_sensor_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "vpc_flow_sensor_policy" {
  name   = var.vpc_flow_sensor_policy_name
  policy = data.aws_iam_policy_document.merged_policies.json
}

data "aws_iam_policy_document" "merged_policies" {
  source_policy_documents = [
    data.aws_iam_policy_document.bucket_permissions.json,
    data.aws_iam_policy_document.enumeration_permissions.json,
  ]
}

data "aws_iam_policy_document" "enumeration_permissions" {
  statement {
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeFlowLogs",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "bucket_permissions" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      var.vpc_flow_log_bucket_arn,
      "${var.vpc_flow_log_bucket_arn}/*"
    ]
  }
}

data "aws_s3_bucket" "enrichment_bucket" {
  count  = var.cloud_enrichment_config.bucket_name != "" ? 1 : 0
  bucket = var.cloud_enrichment_config.bucket_name
}


data "aws_iam_policy_document" "enrichment_bucket_permissions" {
  count = var.cloud_enrichment_config.bucket_name != "" ? 1 : 0
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      data.aws_s3_bucket.enrichment_bucket[count.index].arn,
      "${data.aws_s3_bucket.enrichment_bucket[count.index].arn}/*"
    ]
  }
}

resource "aws_iam_policy" "enrichment_policy" {
  count  = var.cloud_enrichment_config.bucket_name != "" ? 1 : 0
  name   = var.enrichment_policy_name
  policy = data.aws_iam_policy_document.enrichment_bucket_permissions[count.index].json
}

resource "aws_iam_role_policy_attachment" "enrichment_bucket_permissions" {
  count      = var.cloud_enrichment_config.bucket_name != "" ? 1 : 0
  policy_arn = aws_iam_policy.enrichment_policy[count.index].arn
  role       = aws_iam_role.vpc_flow_sensor_role.name
}

resource "aws_iam_role_policy_attachment" "vpc_flow_sensor_role_attach" {
  policy_arn = aws_iam_policy.vpc_flow_sensor_policy.arn
  role       = aws_iam_role.vpc_flow_sensor_role.name
}