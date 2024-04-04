terraform {
  backend "s3" {
    bucket         = "manu-terraform-statefile-bucket"
    key            = "monitoring/prometheus/terraform.tfstate"
    dynamodb_table = "manu_terraform"
  }
}
