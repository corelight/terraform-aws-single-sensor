ami_id                 = "ami-12345abc"
fleet_community_string = "<fleet community string>"
aws_key_pair_name      = "<your aws key pair>"
license_key_file_path  = "/path/to/license.txt"

monitoring_interface_subnet_id   = "<mon subnet id>"
monitoring_security_group_vpc_id = "<vpc of the mon subnet>"

management_interface_subnet_id   = "<mgmt subnet id>"
management_interface_public_ip   = true
management_security_group_vpc_id = "<vpc of the mgmt subnet>"

ssh_allow_cidrs = ["111.222.333.444/5"]