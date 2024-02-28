region        = "us-east-1"
instance_type = "t2.micro"

# VPC variables
vpc_cidr_block = "11.0.0.0/16"

# Subnet variables
public_subnet_1_cidr_block  = "11.0.0.0/18"
public_subnet_2_cidr_block  = "11.0.64.0/18"
private_subnet_3_cidr_block = "11.0.128.0/18"

# Security group variables
ssh_ingress_port    = 22
https_ingress_port  = 443
custom_ingress_port = 8080

# AMI filter values
ubuntu_ami_name_filter = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"

# Instance tags
instance_name_tag = "manu-terraform-inst-1"
