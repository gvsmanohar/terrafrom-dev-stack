data "aws_key_pair" "nexus" {
  filter {
    name   = "tag:name"
    values = ["nexus"]
  }
}

data "aws_subnet" "jenkins_public_subnet" {
  filter {
    name   = "cidr"
    values = ["10.0.1.0/24"]
  }
}

data "aws_vpc" "MainVPC" {
  filter {
    name   = "cidr"
    values = ["10.0.0.0/16"]
  }
}

resource "aws_security_group" "nexus_security_group" {
  vpc_id = data.aws_vpc.MainVPC.id

  ingress {
    description = "ssh for nexus"
    from_port   = var.ssh_ingress_port
    to_port     = var.ssh_ingress_port
    protocol    = var.ssh_http_protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http for nexus"
    from_port   = var.http_ingress_port
    to_port     = var.http_ingress_port
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

  tags = {
    Name = "NexusSG-manu"
  }
}

# data "aws_security_group" "jenkinsSG" {
#   filter {
#     name   = "tag:name"
#     values = ["terraform-20240309175147425600000001"]
#   }
# }

resource "aws_security_group_rule" "jenkins_to_nexus" {
  type              = "ingress"
  from_port         = var.http_ingress_port
  to_port           = var.http_ingress_port
  protocol          = var.ssh_http_protocol
  security_group_id = aws_security_group.nexus_security_group.id

  # Source security group rule
  source_security_group_id = "sg-0de075353b3bd2cdd"
}




resource "aws_instance" "nexus" {

  ami                    = var.centos_ami_id
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.nexus.key_name
  subnet_id              = data.aws_subnet.jenkins_public_subnet.id
  vpc_security_group_ids = [aws_security_group.nexus_security_group.id]

  tags = {
    Name = "manu-nexus-instance"
  }
}
