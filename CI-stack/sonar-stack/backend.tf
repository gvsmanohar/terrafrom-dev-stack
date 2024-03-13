terraform {
  backend "s3" {
    bucket         = "manu-terraform-statefile-bucket"
    key            = "ci-stack/sonar/terraform.tfstate"
    dynamodb_table = "manu_terraform"
  }
}
