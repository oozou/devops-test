resource "aws_iam_role" "default" {
  count = var.external_role == "" ? 1 : 0

  name               = var.name
  description        = var.description
  assume_role_policy = jsonencode(var.assume_role_policy)
  path               = var.path
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "default" {
  count = length(var.attached_policies)

  role       = var.external_role != "" ? var.external_role : aws_iam_role.default[0].name
  policy_arn = var.attached_policies[count.index]
}

resource "aws_iam_instance_profile" "default" {
  count = var.create_instance_profile == true ? 1 : 0

  name = var.name
  role = aws_iam_role.default[0].name
}
