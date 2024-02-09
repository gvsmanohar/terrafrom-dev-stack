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

resource "aws_subnet" "subnet_1" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "11.0.0.0/18"
    tags = {
        Name = "manu_subnet_1"
        VPC = "vpc1"
    }
}

resource "aws_subnet" "subnet_2" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "11.0.64.0/18"
    tags = {
        Name = "manu_subnet_2"
        VPC = "vpc1"
    }
}

resource "aws_subnet" "subnet_3" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "11.0.128.0/18"
    tags = {
        Name = "manu_subnet_3"
        VPC = "vpc1"
    }
}

