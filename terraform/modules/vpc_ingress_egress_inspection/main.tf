data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.azs)
}

module "ingress_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "ingress-vpc"
  cidr = var.vpc_cidr_ingress

  azs = local.azs
  private_subnets = [
    for k, v in local.azs : cidrsubnet(var.vpc_cidr_ingress, 3, k)
  ]
  public_subnets = [
    for k, v in local.azs : cidrsubnet(var.vpc_cidr_ingress, 3, k + 5)
  ]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  customer_gateways = var.customer_gateways_ingress

  tags = merge(
    var.tags,
  )
}

module "egress_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "egress-vpc"
  cidr = var.vpc_cidr_egress

  azs = local.azs
  private_subnets = [
    for k, v in local.azs : cidrsubnet(var.vpc_cidr_egress, 3, k)
  ]
  public_subnets = [
    for k, v in local.azs : cidrsubnet(var.vpc_cidr_egress, 3, k + 5)
  ]

  enable_nat_gateway     = true
  single_nat_gateway     = !var.enable_nat_high_availability
  one_nat_gateway_per_az = var.enable_nat_high_availability
  enable_vpn_gateway     = false

  tags = merge(
    var.tags,
  )
}

module "inspection_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "inspection-vpc"
  cidr = var.vpc_cidr_inspection

  azs = local.azs
  private_subnets = [
    for k, v in local.azs : cidrsubnet(var.vpc_cidr_inspection, 3, k)
  ]
  intra_subnets = [
    for k, v in local.azs : cidrsubnet(var.vpc_cidr_inspection, 3, k + 5)
  ]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = merge(
    var.tags,
  )
}
