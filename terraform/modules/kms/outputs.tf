output "arn" {
  value       = aws_kms_key.default.arn
  description = "Arn of the kms key"
}

output "key_id" {
  value       = aws_kms_key.default.key_id
  description = "Id of the kms key"
}
