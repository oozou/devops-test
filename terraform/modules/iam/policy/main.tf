resource "aws_iam_policy" "default" {
  name        = var.name
  description = var.description
  path        = var.path
  policy      = jsonencode(var.policy)

  lifecycle {
    create_before_destroy = true
  }
}
