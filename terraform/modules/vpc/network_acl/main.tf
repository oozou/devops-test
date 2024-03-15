resource "aws_network_acl" "main" {
  vpc_id = var.vpc_id

  subnet_ids = var.subnet_ids

  dynamic "ingress" {
    for_each = var.ipv4_ingress_rules
    content {
      rule_no    = ingress.value.rule_no
      from_port  = ingress.value.from_port
      to_port    = ingress.value.to_port
      protocol   = ingress.value.protocol
      action     = ingress.value.action
      cidr_block = ingress.value.cidr
      icmp_code  = ingress.value.icmp_code
      icmp_type  = ingress.value.icmp_type
    }
  }

  dynamic "ingress" {
    for_each = var.ipv6_ingress_rules
    content {
      rule_no         = ingress.value.rule_no
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      action          = ingress.value.action
      ipv6_cidr_block = ingress.value.ipv6_cidr_block
      icmp_code       = ingress.value.icmp_code
      icmp_type       = ingress.value.icmp_type
    }
  }

  dynamic "egress" {
    for_each = var.ipv4_egress_rules
    content {
      rule_no    = egress.value.rule_no
      from_port  = egress.value.from_port
      to_port    = egress.value.to_port
      protocol   = egress.value.protocol
      action     = egress.value.action
      cidr_block = egress.value.cidr
      icmp_code  = egress.value.icmp_code
      icmp_type  = egress.value.icmp_type
    }
  }

  dynamic "egress" {
    for_each = var.ipv6_egress_rules
    content {
      rule_no         = egress.value.rule_no
      from_port       = egress.value.from_port
      to_port         = egress.value.to_port
      protocol        = egress.value.protocol
      action          = egress.value.action
      ipv6_cidr_block = egress.value.ipv6_cidr_block
      icmp_code       = egress.value.icmp_code
      icmp_type       = egress.value.icmp_type
    }
  }
}
