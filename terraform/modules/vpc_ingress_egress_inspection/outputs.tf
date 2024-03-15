output "ingress_vpc_id" {
  description = "VPC Ingress ID"
  value       = module.ingress_vpc.vpc_id
}

output "ingress_vpc_cgw_ids" {
  description = "List of IDs of Ingress Customer Gateway"
  value       = module.ingress_vpc.cgw_ids
}

output "ingress_vpc_public_subnets" {
  description = "List of IDs of Ingress public subnets"
  value       = module.ingress_vpc.public_subnets
}

output "ingress_vpc_private_subnets" {
  description = "List of IDs of Ingress private subnets"
  value       = module.ingress_vpc.private_subnets
}

output "ingress_vpc_private_route_table_ids" {
  description = "List of IDs of Ingress private route tables"
  value       = module.ingress_vpc.private_route_table_ids
}

output "ec2_transit_gateway_id" {
  description = "EC2 Transit Gateway identifier"
  value       = aws_ec2_transit_gateway.default.id
}

output "ec2_transit_gateway_route_table_firewall_id" {
  description = "Firewall EC2 Transit Gateway Route Table identifier"
  value       = aws_ec2_transit_gateway_route_table.firewall.id
}

output "vpn_client_cert" {
  value       = tls_locally_signed_cert.root.cert_pem
  sensitive   = true
  description = "VPN certificate"
}

output "vpn_client_key" {
  value       = tls_private_key.root.private_key_pem
  sensitive   = true
  description = "VPN key"
}

output "natgw_ids" {
  value       = module.egress_vpc.natgw_ids
  description = "List of NAT Gateway IDs"
}
