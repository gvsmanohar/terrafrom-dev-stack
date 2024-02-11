provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "vpc1" {

    cidr_block = "11.0.0.0/16"
    tags = {
        Name = "manu_vpc_one"
        Group = "terraform"

    }
}

resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "11.0.0.0/18"
    map_public_ip_on_launch = true
    tags = {
        Name = "manu_public_subnet_1"
        VPC = "vpc1"
    }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "11.0.64.0/18"
    map_public_ip_on_launch = true
    tags = {
        Name = "manu_public_subnet_2"
        VPC = "vpc1"
    }
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "11.0.128.0/18"
    tags = {
        Name = "manu_private_subnet_1"
        VPC = "vpc1"
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