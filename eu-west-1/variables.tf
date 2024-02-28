variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-west-1"
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_1_cidr_block" {
  description = "The CIDR block for subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_2_cidr_block" {
  description = "The CIDR block for subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}
