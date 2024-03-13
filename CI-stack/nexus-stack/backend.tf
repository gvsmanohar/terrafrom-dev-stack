terraform {
  backend "s3" {
    bucket         = "manu-terraform-statefile-bucket"
    key            = "ci-stack/nexus/terraform.tfstate"
    dynamodb_table = "manu_terraform"
  }
}
