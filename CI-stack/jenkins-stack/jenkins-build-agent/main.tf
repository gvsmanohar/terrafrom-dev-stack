data "aws_key_pair" "jenkins" {
  filter {
    name   = "tag:name"
    values = ["jenkins"]
  }
}

# data "aws_ami" "ubuntu_x86_ami" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = var.ubuntu_ami_name_filter
#   }
# }

# data "aws_security_group" "jenkins_agent_SG" {
#   tags = {
#     Name = "terraform-20240309175147425600000001"
#   }
# }

data "aws_subnet" "jenkins_public_subnet" {
  filter {
    name   = "cidr"
    values = ["10.0.1.0/24"]
  }
}

resource "aws_instance" "jenkins_agent" {

  ami                    = "ami-0dfb1520a8026d466"
  instance_type          = var.instance_type
  key_name               = data.aws_key_pair.jenkins.key_name
  subnet_id              = data.aws_subnet.jenkins_public_subnet.id
  vpc_security_group_ids = ["sg-0de075353b3bd2cdd"]
  tags = {
    Name = "manu-jenkins-build-agent-instance"
  }
}
