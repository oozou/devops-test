locals {
  environment         = "non-production"
  vpc_cidr_ingress    = "192.168.0.0/21"
  vpc_cidr_egress     = "192.168.8.0/21"
  vpc_cidr_inspection = "192.168.16.0/21"
  cidr_range_workload = "10.0.0.0/8"
  azs                 = 2
  high_availability   = false

  ram_principals = [
    # Workload non-production accounts
    "arn:aws:organizations::950843137290:ou/o-xzw4k796as/ou-oimq-vv7rtylz",
    # Deployment accounts
    "arn:aws:organizations::950843137290:ou/o-xzw4k796as/ou-oimq-eu1amjra",
  ]
  workload_attachments = {
    # Add the attachment after the creation of the workload VPC
    non-production-workload = {
      vpc_cidr                      = "10.2.0.0/16"
      transit_gateway_attachment_id = "tgw-attach-09f7845a34cd20d1f"
    }
    # # Add the attachment after the creation of the deployment VPC
    deployment = {
      vpc_cidr                      = "10.129.0.0/23"
      transit_gateway_attachment_id = "tgw-attach-067d281b167273c16"
    }
  }
}

module "network" {
  source = "../../../modules/vpc_ingress_egress_inspection"

  environment                  = local.environment
  vpc_cidr_ingress             = local.vpc_cidr_ingress
  vpc_cidr_egress              = local.vpc_cidr_egress
  vpc_cidr_inspection          = local.vpc_cidr_inspection
  cidr_range_workload          = local.cidr_range_workload
  azs                          = local.azs
  ram_principals               = local.ram_principals
  workload_attachments         = local.workload_attachments
  enable_nat_high_availability = local.high_availability

  enable_vpn_high_availability = false
}
