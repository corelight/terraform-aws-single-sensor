# terraform-aws-single-sensor
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

## Usage
```terraform
ami_id                 = "ami-12345abc"
fleet_community_string = "<fleet community string>"
aws_key_pair_name      = "<your aws key pair>"

// Monitoring Interface - User Provided (Option A) 
monitoring_interface_id = "<your monitoring ENI ID>"

// Monitoring Interface - Module Provided (Option B)
monitoring_interface_subnet_id = "<your monitoring subnet id>"
monitoring_interface_name      = "<your preferred interface name>" // default: corelight-mon-nic

// Monitoring Interface Security Group - User Provided (Option A)
// Rules will be added to the security group provided
monitoring_security_group_id = "<your existing security group for the monitoring NIC>"

// Monitoring Interface Security Group - Module Provided (Option B)
monitoring_security_group_vpc_id      = "<your monitoring subnet VPC id>"
monitoring_security_group_name        = "<your preferred security group name>"        // default: corelight-sensor-mon-sg
monitoring_security_group_description = "<your preferred security group description>" // default: Corelight Sensor Monitoring SG

// Management Interface - User Provided (Option A)
management_interface_id = "<your management ENI ID>"

// Management Interface - Module Provided (Option B)
management_interface_subnet_id = "<your management subnet id>"
management_interface_name      = "<your preferred interface name>" // default: corelight-mgmt-nic
management_interface_public_ip = true                              // default: false

// Management Interface Security Group - User Provided (Option A)
//  Rules will be added to the security group provided
management_security_group_id = "<your existing security group for the management NIC>"

// Management Interface Security Group - Module Provided (Option B)
management_security_group_vpc_id      = "<your management subnet VPC id>"
management_security_group_name        = "<your preferred security group name>"        // default: corelight-sensor-mgmt-sg
management_security_group_description = "<your preferred security group description>" // default: Corelight Sensor Management SG

// Security Rules Configuration
ssh_allow_cidrs          = ["<CIDRs allowed to SSH to a public mgmt nic>"] // default: []
egress_allow_cidrs       = ["<your preferred egress CIDR(s)>"]              // default: ["0.0.0.0/0"]
health_check_allow_cidrs = ["<your preferred health check CIDR(s)>"]        // default: ["0.0.0.0/0"]

// Recommend using the CIDR of the VPC being monitored
mirror_ingress_allow_cidrs = ["<your preferred mirror CIDR(s)>"] // default: ["0.0.0.0/0"]

// Licensing Module Provided - with Fleet (Option A)
fleet_token = "<your fleet token>"
fleet_url = "https://<your-fleet-instance>:1443/fleet/v1/internal/softsensor/websocket"
fleet_server_sslname = "foo.example.com"

// Licensing Module Provided - Without Fleet (Option B)
license_key_file_path = "/path/to/license.txt"

// Custom User Data for Cloud-Init
//  it is recommended to use the module for sensor configuration. Providing your own custom user data may lead to unforeseen consequences.
custom_sensor_user_data = ""

// Instance Configuration
instance_name   = "<your preferred instance name>"                 // default: corelight-sensor
instance_type   = "<your preferred instance type>"                 // default: c5.2xlarge
ebs_volume_size = "<your preferred EBS volume size in GB (number)" // default: 500
```

### Copy an example tfvars file and populate it with your details
```shell
cp minimal-example.tfvars foo.tfvars 
```

### Plan the deployment
```shell
terraform plan --var-file foo.tfvars -out=tfplan
```

### Deploy the Plan
If the plan looks good go ahead and deploy it
```shell
terraform apply tfplan
```
