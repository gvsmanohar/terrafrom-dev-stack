provider "aws" {
  region = var.region
}

data "aws_key_pair" "webserver" {
  filter {
    name   = "tag:name"
    values = ["webserver"]
  }
}
# # creating a key pair
# resource "aws_key_pair" "webserver_keypair" {

#   # Name of the key
#   key_name = data.aws_key_pair.webserver.key_name

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
resource "aws_security_group" "webserver_security_group" {
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc_main.id


  # Created an inbound rule for webserver to allow port 80,
  # as webserver generally uses HTTP protocol which uses port 80!
  ingress {
    description = "HTTP for webserver"
    from_port   = var.http_ingress_port
    to_port     = var.http_ingress_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Created an inbound rule for webserver to allow port 22 for SSH, 
  # because SSH protocol works on port 22!

  ingress {
    description = "SSH for webserver"
    from_port   = var.ssh_ingress_port
    to_port     = var.ssh_ingress_port
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
    Name = "webserver-security-group"
  }
}


# public subnet
# 1. Attach Internet gateway to the vpc to enable communication with the internet
# 2. Define a route table and associate it with the public subnet.
# Ensure it has a default route pointing to the internet gateway
resource "aws_subnet" "webserver_public_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id
  cidr_block              = var.webserver_public_subnet_cidr
  map_public_ip_on_launch = true
}

# Internet gateway
resource "aws_internet_gateway" "webserver_igw" {
  vpc_id = aws_vpc.vpc_main.id
}

# Route Table
resource "aws_route_table" "webserver_route_table" {
  vpc_id = aws_vpc.vpc_main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webserver_igw.id
  }
}

# Route table association
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.webserver_public_subnet.id
  route_table_id = aws_route_table.webserver_route_table.id
}

# private subnet
resource "aws_subnet" "webserver_private_subnet" {
  vpc_id     = aws_vpc.vpc_main.id
  cidr_block = var.webserver_private_subnet_cidr
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
resource "aws_instance" "webserver" {

  ami                    = data.aws_ami.ubuntu_x86_ami.id
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.webserver.key_name
  subnet_id              = aws_subnet.webserver_public_subnet.id
  vpc_security_group_ids = [aws_security_group.webserver_security_group.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/Users/manohar/Desktop/Study/DevOps/ClassNotes/terrafrom-dev-stack/keypairs/webserver-keypair.pem")
    host        = aws_instance.webserver.public_ip
  }

  tags = {
    Name = "webserver-instance"
  }
}

