provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "vpc1" {

  cidr_block = "10.0.0.0/16"
  tags = {
    Name  = "manu_vpc_one"
    Group = "terraform"

  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "manu_subnet_1"
    VPC  = "vpc1"
  }
}

resource "aws_subnet" "subnet_2" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "manu_subnet_2"
    VPC  = "vpc1"
  }
}

