provider "aws" {
  region = "us-east-1"
}
data "aws_key_pair" "jenkins" {
  filter {
    name   = "tag:name"
    values = ["jenkins"]
  }
}

resource "aws_ecr_repository" "mlproj" {
  name                 = "mlproj"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_vpc" "MainVPC" {
  filter {
    name   = "cidr"
    values = ["10.0.0.0/16"]
  }
}
data "aws_subnet" "mlproj_subnet" {
  filter {
    name   = "cidr"
    values = ["10.0.1.0/24"]
  }
}


resource "aws_security_group" "mlproj_SG" {
  name        = "mlproj-security-group"
  description = "Allow inbound traffic on specified ports"
  vpc_id      = data.aws_vpc.MainVPC.id
  tags = {
    Name = "mlproj-security-group"
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

  egress {
    description = "To allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_instance" "mlproj-instance" {
  ami           = "ami-080e1f13689e07408" # Replace with your desired AMI ID
  instance_type = "t2.large"              # Example instance type

  key_name               = data.aws_key_pair.jenkins.key_name # Replace with your key pair name
  subnet_id              = data.aws_subnet.mlproj_subnet.id   # Replace with your subnet ID
  vpc_security_group_ids = [aws_security_group.mlproj_SG.id]

  root_block_device {
    volume_size = 32    # Size of the root volume in GB
    volume_type = "gp2" # Example volume type (General Purpose SSD)
  }
  tags = {
    Name = "mlproj-instance"
  }
}
