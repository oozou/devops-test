resource "aws_kms_key" "default" {
  description         = var.description
  is_enabled          = var.is_enabled
  enable_key_rotation = var.enable_key_rotation
  tags                = var.tags
  policy              = var.policy
}

resource "aws_kms_alias" "default" {
  name          = format("alias/%s", var.name)
  target_key_id = aws_kms_key.default.key_id
}
