resource "aws_s3_bucket" "manu-state-bucket" {
  bucket = "manu-terraform-statefile-bucket"

  tags = {
    Name        = "manu-terraform-statefile-bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "state_bucket_version" {
  bucket = aws_s3_bucket.manu-state-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_dynamodb_table" "manu_terraform_locks" {
  name           = "manu_terraform"
  billing_mode   = "PROVISIONED"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}
