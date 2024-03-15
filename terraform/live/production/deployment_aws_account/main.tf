locals {
  environment = "production"

  vpcs = {
    non-production = {
      environment         = "non-production"
      vpc_cidr            = "10.129.0.0/23"
      availability_zones  = slice(data.aws_availability_zones.available.names, 0, 1)
      transit_gateway_id  = "tgw-0ae3248d0b3bd6847"
      ingress_cidr_blocks = "192.168.0.0/21"
    }
    production = {
      environment         = "production"
      vpc_cidr            = "10.129.2.0/23"
      availability_zones  = slice(data.aws_availability_zones.available.names, 0, 3)
      transit_gateway_id  = "tgw-09dd5ff3f4b321f22"
      ingress_cidr_blocks = "192.168.128.0/21"
    }
  }
}

module "vpc" {
  for_each = local.vpcs
  source   = "../../../modules/vpc"

  environment = each.value.environment
  vpc = {
    name = "vpc-${each.key}-deployment"
    cidr = each.value.vpc_cidr

    private_subnets = [
      for k, v in each.value.availability_zones :
      cidrsubnet(each.value.vpc_cidr, 3, k)
    ]
    public_subnets = [
      for k, v in each.value.availability_zones :
      cidrsubnet(each.value.vpc_cidr, 3, k + 4)
    ]

    create_database_subnet_group = false
    create_igw                   = false

    enable_nat_gateway   = false
    enable_vpn_gateway   = false
    enable_dns_hostnames = true
    enable_dns_support   = true
  }
}

module "vpc_attachment_network_aws_account" {
  source   = "../../../modules/transit_gateway/vpc_attachment"
  for_each = local.vpcs

  transit_gateway_id      = each.value.transit_gateway_id
  vpc_id                  = module.vpc[each.key].vpc_id
  subnet_ids              = module.vpc[each.key].private_subnets
  destination_cidr_blocks = ["0.0.0.0/0"]
  route_table_ids         = concat(module.vpc[each.key].public_route_table_ids, module.vpc[each.key].private_route_table_ids)
}
