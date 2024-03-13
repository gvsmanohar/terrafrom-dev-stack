variable "region" {
  description = "AWS region where the resources will be created"
  type        = string
}

variable "http_ingress_port" {
  type = number
}

variable "ssh_ingress_port" {
  type = number
}

variable "nginx_port" {
  type = number
}

variable "ssl_port" {
  type = number
}

variable "jenkins_build_port" {
  type = number
}


variable "ssh_http_protocol" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "jenkins_public_subnet_cidr" {
  type = string
}

variable "jenkins_private_subnet_cidr" {
  type = string
}

variable "ubuntu_ami_name_filter" {
  type = list(string)
}

variable "instance_type" {
  type = string
}
