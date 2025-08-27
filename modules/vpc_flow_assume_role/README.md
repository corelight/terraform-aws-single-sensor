# VPC Flow Assume Role Module

Creates an IAM role that can be assumed by a trusted external AWS account for VPC Flow Log access.

## Usage

```hcl
module "vpc_flow_assume_role" {
  source = "./modules/vpc_flow_assume_role"

  trusted_account_id = "123456789012"
  trusted_role_name  = "corelight-flow-role"
  assume_role_name   = "corelight-cross-account-role"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| trusted_account_id | The AWS account ID that is allowed to assume this role | `string` | `"123456789012"` | no |
| trusted_role_name | The name of the role in the trusted account that can assume this role | `string` | `"corelight-flow-role"` | no |
| assume_role_name | The name of the role to create in this account | `string` | `"corelight-cross-account-role"` | no |

## Outputs

| Name | Description |
|------|-------------|
| assume_role_arn | ARN of the role that can be assumed |
| assume_role_name | Name of the role that can be assumed |
| trusted_account_id | The account ID that is trusted to assume this role |
| current_account_id | The current AWS account ID where this role is created |

## Permissions

The role grants the following EC2 permissions:
- `ec2:DescribeVpcs`
- `ec2:DescribeFlowLogs`
