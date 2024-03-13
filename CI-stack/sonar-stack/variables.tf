variable "instance_type" {
  type = string
}

variable "ubuntu_ami" {
  type = string
}

variable "ssh_ingress_port" {
  type = number
}

variable "http_ingress_port" {
  type = number
}

variable "ssh_http_protocol" {
  type = string
}
