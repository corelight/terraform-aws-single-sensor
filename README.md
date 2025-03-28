# terraform-aws-single-sensor (Early Access)
Deploy a single AWS Corelight EC2 instance Cloud Sensor. 

## Getting Started

### Initialize Terraform state
```shell 
    terraform init
```

### Deployment Permissions
Ensure you are able to authenticate to the AWS account you are looking to deploy
these resources into and have the proper permissions to create resources. Any deployment 
including IAM resources will require administrator level permissions.

## Example Deployments
* [Basic](examples/basic/README.md)