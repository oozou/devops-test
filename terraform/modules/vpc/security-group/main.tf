module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name                     = var.security_group.name
  vpc_id                   = var.security_group.vpc_id
  description              = lookup(var.security_group, "description", "Security Group managed by Terraform")
  ingress_rules            = lookup(var.security_group, "ingress_rules", [])
  ingress_cidr_blocks      = lookup(var.security_group, "ingress_cidr_blocks", [])
  ingress_with_self        = lookup(var.security_group, "ingress_with_self", [])
  ingress_prefix_list_ids  = lookup(var.security_group, "ingress_prefix_list_ids", [])
  ingress_with_cidr_blocks = lookup(var.security_group, "ingress_with_cidr_blocks", [])
  egress_rules             = lookup(var.security_group, "egress_rules", [])
  egress_cidr_blocks       = lookup(var.security_group, "egress_cidr_blocks", [])
  egress_with_self         = lookup(var.security_group, "egress_with_self", [])
  egress_prefix_list_ids   = lookup(var.security_group, "egress_prefix_list_ids", [])
  tags                     = lookup(var.security_group, "tags", {})
}
