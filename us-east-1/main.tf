provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc1" {

  cidr_block = "11.0.0.0/16"
  tags = {
    Name  = "manu_vpc_one"
    Group = "terraform"

  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "11.0.0.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "manu_public_subnet_1"
    VPC  = "vpc1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = "11.0.64.0/18"
  map_public_ip_on_launch = true
  tags = {
    Name = "manu_public_subnet_2"
    VPC  = "vpc1"
  }
}

resource "aws_subnet" "private_subnet_3" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "11.0.128.0/18"
  tags = {
    Name = "manu_private_subnet_3"
    VPC  = "vpc1"
  }
}

resource "aws_security_group" "terraformSecurityGroup" {
  name        = "manu-security-group "
  description = "Allow inbound traffic on specified ports"
  vpc_id      = aws_vpc.vpc1.id
  tags = {
    Name = "manu-secutity-group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route_table" "public_route_table_1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "manu_public_route_table"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "public_subnet_1_association" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table_1.id
}


resource "aws_route_table_association" "public_subnet_2_association" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table_1.id
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "manu_igw_1"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc1.id
}

data "aws_ami" "ubuntu_x86_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "manu-terraform-instance-1" {
  ami           = data.aws_ami.ubuntu_x86_ami.id # Replace with your desired AMI ID
  instance_type = "t2.micro"                     # Example instance type

  key_name               = "terraform-keypair"           # Replace with your key pair name
  subnet_id              = aws_subnet.public_subnet_1.id # Replace with your subnet ID
  vpc_security_group_ids = [aws_security_group.terraformSecurityGroup.id]

  root_block_device {
    volume_size = 8     # Size of the root volume in GB
    volume_type = "gp2" # Example volume type (General Purpose SSD)
  }
  tags = {
    Name = "manu-terraform-inst-1"
  }
}

