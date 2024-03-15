module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name             = var.vpc.name
  cidr             = var.vpc.cidr
  azs              = data.aws_availability_zones.available.names
  private_subnets  = var.vpc.private_subnets
  public_subnets   = var.vpc.public_subnets
  database_subnets = try(var.vpc.database_subnets, [])
  intra_subnets    = try(var.vpc.intra_subnets, [])

  create_igw                   = var.vpc.create_igw
  create_database_subnet_group = var.vpc.create_database_subnet_group
  enable_dns_hostnames         = var.vpc.enable_dns_hostnames
  enable_dns_support           = var.vpc.enable_dns_support
  enable_nat_gateway           = var.vpc.enable_nat_gateway
}

module "vpc_endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 4.0"

  create             = var.create_vpc_endpoint
  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.https_vpc_endpoint_sg.security_group_id]
  endpoints          = var.endpoints
}

module "https_vpc_endpoint_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  create              = var.create_vpc_endpoint
  name                = "vpc-endpoint-https-443-tcp"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = concat(module.vpc.private_subnets_cidr_blocks, module.vpc.intra_subnets_cidr_blocks)
  ingress_rules       = ["https-443-tcp"]
}
