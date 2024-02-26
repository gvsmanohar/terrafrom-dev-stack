terraform {
  backend "s3" {
    bucket         = "manu-terraform-statefile-bucket"
    key            = "dev/terraform.tfstate"
    dynamodb_table = "manu_terraform"
  }
}
