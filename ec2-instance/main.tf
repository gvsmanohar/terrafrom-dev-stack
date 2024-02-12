provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "terraformSecurityGroup" {
  name        = "terraform-instance-SG"
  description = "Allow inbound traffic on specified ports"
  vpc_id      = "vpc-02a9512400e081a2d"
  tags = {
    Name = "terraform-secutity-group"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "manu-terraform-instance-1" {
  ami           = "ami-0c7217cdde317cfec"  # Replace with your desired AMI ID
  instance_type = "t2.micro"            # Example instance type

  key_name      = "terraform-keypair"  # Replace with your key pair name
  subnet_id     = "subnet-0692a6dce81700f07"      # Replace with your subnet ID
  vpc_security_group_ids = [aws_security_group.terraformSecurityGroup.id]

  root_block_device {
    volume_size = 8  # Size of the root volume in GB
    volume_type = "gp2"  # Example volume type (General Purpose SSD)
  }
  tags = {
    Name = "manu-terraform-inst-1"
  }
}
