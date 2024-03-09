region                       = "us-east-1"
http_ingress_port            = 80
ingress_jenkins_default_port = 8080
ssh_ingress_port             = 22
ssh_http_protocol            = "tcp"
vpc_cidr_block               = "10.0.0.0/16"
jenkins_public_subnet_cidr   = "10.0.1.0/24"
jenkins_private_subnet_cidr  = "10.0.2.0/24"
ubuntu_ami_name_filter       = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
instance_type                = "t2.medium"
