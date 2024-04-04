terraform {
  backend "s3" {
    bucket         = "manu-terraform-statefile-bucket"
    key            = "ML-Flow/terraform.tfstate"
    dynamodb_table = "manu_terraform"
  }
}
