output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.eks.node_security_group_id
}
output "oidc_provider_arn" {
  description = "https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/19.13.1#output_oidc_provider_arn"
  value       = module.eks.oidc_provider_arn
}
output "cluster_oidc_issuer_url" {
  description = "https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/19.13.1#output_cluster_oidc_issuer_url"
  value       = module.eks.cluster_oidc_issuer_url
}
output "eks_kms_key_arn" {
  description = "EKS's KMS key arn"
  value       = module.kms.key_arn
}
output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}
output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}
output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}
