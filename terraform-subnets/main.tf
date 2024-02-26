Data source to retrieve existing subnets filtered by tags
data "aws_subnet" "selected_subnets" {
  filter {
    name   = "tag:Name"
    values = ["manu-subnet-1-public"]
  }
}

output "subnet_id" {
  value = data.aws_subnet.selected_subnets.id
}


