provider "aws" {
  region = var.region
}


# # Data source to fetch IAM user details
# data "aws_iam_user" "existing_user" {
#   user_name = "manu-1" # Replace with the name of your existing IAM user
# }

# # Resource to attach Route 53 IAM policy to the existing IAM user
# resource "aws_iam_policy_attachment" "route53_policy_attachment" {
#   name       = "route53-policy-attachment"                       # Specify a name for the policy attachment
#   users      = [data.aws_iam_user.existing_user.id]              # Attach to the existing IAM user
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess" # ARN of Route 53 IAM policy
# }


data "aws_key_pair" "jenkins" {
  filter {
    name   = "tag:name"
    values = ["jenkins"]
  }
}
# # creating a key pair
# resource "aws_key_pair" "jenkins_keypair" {

#   # Name of the key
#   key_name = data.aws_key_pair.jenkins.key_name

#   # specify public key
#   # Here, I have used file function to extract my already created key from SSH
#   #internally, but here random key created by you can also be entered, in
#   # that case there is no need to use the file function!
#   public_key = file("~/.ssh/id_rsa.pub")
# }

# vpc
resource "aws_vpc" "vpc_main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}


# Creating a security group
resource "aws_security_group" "jenkins_security_group" {
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc_main.id


  # Created an inbound rule for jenkins to allow port 80,
  # as jenkins generally uses HTTP protocol which uses port 80!
  ingress {
    description = "HTTP for jenkins"
    from_port   = var.http_ingress_port
    to_port     = var.http_ingress_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Created an inbound rule for jenkins to allow port 22 for SSH, 
  # because SSH protocol works on port 22!

  ingress {
    description = "SSH for jenkins"
    from_port   = var.ssh_ingress_port
    to_port     = var.ssh_ingress_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "nginx_port"
    from_port   = var.nginx_port
    to_port     = var.nginx_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssl_port"
    from_port   = var.ssl_port
    to_port     = var.ssl_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "jenkins_build_port"
    from_port   = var.jenkins_build_port
    to_port     = var.jenkins_build_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    description = "To allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Adding a tag to the security group
  tags = {
    Name = "jenkinsSG_manu"
  }
}


# public subnet
# 1. Attach Internet gateway to the vpc to enable communication with the internet
# 2. Define a route table and associate it with the public subnet.
# Ensure it has a default route pointing to the internet gateway
resource "aws_subnet" "jenkins_public_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.jenkins_public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "jenkins_public_subnet"
  }
}

# Internet gateway
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.vpc_main.id
}

# Route Table
resource "aws_route_table" "jenkins_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }
}

# Route table association
resource "aws_route_table_association" "jenkins_route_table_association" {
  subnet_id      = aws_subnet.jenkins_public_subnet.id
  route_table_id = aws_route_table.jenkins_route_table.id
}

# private subnet
resource "aws_subnet" "jenkins_private_subnet" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.jenkins_private_subnet_cidr
}

# data source for ami id
data "aws_ami" "ubuntu_x86_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = var.ubuntu_ami_name_filter
  }
}


# Creating a AWS instance
resource "aws_instance" "jenkins" {

  ami                    = "ami-0dfb1520a8026d466"
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.jenkins.key_name
  subnet_id              = aws_subnet.jenkins_public_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_security_group.id]



  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("/Users/manohar/Desktop/Study/DevOps/ClassNotes/terrafrom-dev-stack/keypairs/jenkins-keypair.pem")
  #   host        = aws_instance.jenkins.public_ip
  # }
  # provisioner "remote-exec" {
  #   # Installing Git into the system.  Here in this inline list,
  #   # multiple commands can be passed which 
  #   # are required to run in the remote system.
  #   inline = [
  #     "#!/bin/bash",
  #     "sudo apt update",
  #     "echo 'Y' | sudo apt install openjdk-17-jre-headless",
  #     "sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key",
  #     "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
  #     "sudo apt-get update",
  #     "echo 'Y' | sudo apt-get install jenkins",
  #   ]
  # }

  tags = {
    Name = "manu-jenkins-instance"
  }
}

data "aws_route53_zone" "ninhogen_zone" {
  name         = "ninhogen.com."
  private_zone = false
}

resource "aws_route53_record" "manu_jenkins_record" {
  zone_id = data.aws_route53_zone.ninhogen_zone.zone_id
  name    = "manu.jenkins.ninhogen.com"
  type    = "A"
  ttl     = 300
  records = [aws_instance.jenkins.public_ip]
}
