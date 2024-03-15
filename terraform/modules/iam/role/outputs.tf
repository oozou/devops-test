output "name" {
  value       = aws_iam_role.default[0].name
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role.html#name"
}
output "arn" {
  value       = aws_iam_role.default[0].arn
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role.html#arn"
}
