output "id" {
  value       = aws_eip.default.id
  description = "Contains the EIP allocation ID."
}

output "public_ip" {
  value       = aws_eip.default.public_ip
  description = "Contains the public IP address."
}

output "private_ip" {
  value       = aws_eip.default.private_ip
  description = "Contains the private IP address (if in VPC)."
}
