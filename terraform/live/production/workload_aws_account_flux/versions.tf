terraform {
  required_version = ">= 1.4"

  # backend "s3" {
  #   bucket         = "tfstate-production-rfvtgb"
  #   key            = "flux"
  #   region         = "ap-southeast-1"
  #   encrypt        = true
  #   kms_key_id     = "alias/tfstate_bucket_kms_key"
  #   dynamodb_table = "tfstate_lock"
  # }
}
