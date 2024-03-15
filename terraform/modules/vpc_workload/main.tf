data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.azs_number)
}

module "workload_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "vpc-${var.environment}"
  cidr = var.vpc_cidr

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 3, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k + 8)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k + 24)]
  intra_subnets    = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 5, k + 28)]

  create_database_subnet_group = true
  create_igw                   = false

  enable_nat_gateway = false
  enable_vpn_gateway = false

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                                 = var.enable_flow_log
  create_flow_log_cloudwatch_log_group            = var.enable_flow_log
  create_flow_log_cloudwatch_iam_role             = var.enable_flow_log
  flow_log_max_aggregation_interval               = var.flow_log_max_aggregation_interval
  flow_log_cloudwatch_log_group_retention_in_days = var.flow_log_cloudwatch_log_group_retention_in_days
  flow_log_traffic_type                           = var.flow_log_traffic_type
  flow_log_cloudwatch_log_group_name_suffix       = var.flow_log_cloudwatch_log_group_name_suffix
  vpc_flow_log_tags = merge(
    {
      Name = "vpc-flow-logs-cloudwatch-logs-default"
    },
    var.vpc_flow_log_tags
  )

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = merge(
    var.tags,
  )
}

module "vpc_endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.0"

  vpc_id             = module.workload_vpc.vpc_id
  security_group_ids = [module.https_vpc_endpoint_sg.security_group_id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.workload_vpc.private_route_table_ids
      tags            = { Name = "s3-vpc-endpoint-${var.environment}" }
    },
  }

  tags = merge(
    var.tags,
  )
}

module "https_vpc_endpoint_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "vpc-endpoint-https-443-tcp"
  vpc_id = module.workload_vpc.vpc_id

  ingress_cidr_blocks = concat(module.workload_vpc.private_subnets_cidr_blocks, module.workload_vpc.intra_subnets_cidr_blocks)
  ingress_rules       = ["https-443-tcp"]
}
