variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "11.0.0.0/16"
}

variable "public_subnet_1_cidr_block" {
  description = "The CIDR block for public subnet 1"
  type        = string
  default     = "11.0.0.0/18"
}

variable "public_subnet_2_cidr_block" {
  description = "The CIDR block for public subnet 2"
  type        = string
  default     = "11.0.64.0/18"
}

variable "private_subnet_3_cidr_block" {
  description = "The CIDR block for private subnet 3"
  type        = string
  default     = "11.0.128.0/18"
}

variable "ssh_ingress_port" {
  description = "The port for SSH ingress"
  type        = number
  default     = 22
}

variable "https_ingress_port" {
  description = "The port for HTTPS ingress"
  type        = number
  default     = 443
}

variable "custom_ingress_port" {
  description = "A custom ingress port"
  type        = number
  default     = 8080
}

variable "ubuntu_amd_ami_name_filter" {
  description = "The filter for Ubuntu AMIs"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ubuntu_arm_ami_name_filter" {
  description = "The filter for Ubuntu AMIs"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"
}

variable "amd_instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "arm_instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t4g.nano"
}

variable "amd_instance_name_tag" {
  description = "The tag for the EC2 instance"
  type        = string
  default     = "manu-terraform-inst-x86_64"
}

variable "arm_instance_name_tag" {
  description = "The tag for the EC2 instance"
  type        = string
  default     = "manu-terraform-inst-arm64"
}
