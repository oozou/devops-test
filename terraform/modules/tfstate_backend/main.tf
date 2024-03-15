resource "aws_kms_key" "tfstate_bucket_kms_key" {
  description             = "KMS key used for encrypting tf states"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "tfstate_kms_key_alias" {
  name          = "alias/tfstate_bucket_kms_key"
  target_key_id = aws_kms_key.tfstate_bucket_kms_key.key_id
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.8.2"

  bucket = "tfstate-${local.tags.Environment}-${var.random_suffix}"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  versioning = {
    enabled    = true
    mfa_delete = false
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = aws_kms_key.tfstate_bucket_kms_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_dynamodb_table" "tfstate_lock" {
  name           = "tfstate_lock"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
