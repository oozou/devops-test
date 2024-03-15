module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                 = var.repository_name
  repository_type                 = var.repository_type
  repository_image_tag_mutability = var.repository_image_tag_mutability

  repository_encryption_type = "KMS"
  repository_kms_key         = module.kms_ecr.key_arn

  repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_read_access_arns       = var.repository_read_access_arns
  create_lifecycle_policy           = var.repository_lifecycle_policy == "" ? false : true
  repository_lifecycle_policy       = var.repository_lifecycle_policy
}

module "kms_ecr" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.1.0"

  aliases               = ["ecr/${var.repository_name}"]
  description           = "ECR encryption key"
  enable_default_policy = true
}
