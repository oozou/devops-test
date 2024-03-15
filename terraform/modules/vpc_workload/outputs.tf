output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.workload_vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.workload_vpc.public_subnets
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = module.workload_vpc.public_route_table_ids
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.workload_vpc.private_subnets
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = module.workload_vpc.private_route_table_ids
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = module.workload_vpc.database_subnets
}

output "intra_subnets" {
  description = "List of IDs of intra subnets"
  value       = module.workload_vpc.intra_subnets
}

output "intra_route_table_ids" {
  description = "List of IDs of intra route tables"
  value       = module.workload_vpc.intra_route_table_ids
}

output "database_subnet_group_name" {
  description = "ID of database subnet group name"
  value       = module.workload_vpc.database_subnet_group
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = module.workload_vpc.private_subnets_cidr_blocks
}
