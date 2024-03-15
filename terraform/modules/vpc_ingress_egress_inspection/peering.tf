################################################################################
# Transit Gateway
################################################################################

resource "aws_ec2_transit_gateway" "default" {
  description = "${var.environment} TGW shared with several other AWS accounts"

  amazon_side_asn                 = 64532
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  auto_accept_shared_attachments  = "enable"
  multicast_support               = "disable"
  vpn_ecmp_support                = "disable"
  dns_support                     = "enable"

  tags = merge(
    var.tags,
    { Name = "${var.environment}-tgw-${replace(basename(path.cwd), "_", "-")}" },
  )
}

################################################################################
# VPC Attachment
################################################################################

resource "aws_ec2_transit_gateway_vpc_attachment" "ingress" {
  transit_gateway_id = aws_ec2_transit_gateway.default.id
  vpc_id             = module.ingress_vpc.vpc_id
  subnet_ids         = module.ingress_vpc.private_subnets

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ingress-tgw"
    }
  )
}

resource "aws_ec2_transit_gateway_vpc_attachment" "egress" {
  transit_gateway_id = aws_ec2_transit_gateway.default.id
  vpc_id             = module.egress_vpc.vpc_id
  subnet_ids         = module.egress_vpc.private_subnets

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-egress-tgw"
    }
  )
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "firewall" {
  transit_gateway_id = aws_ec2_transit_gateway.default.id

  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-ingress-tgw-firewall-rt"
    }
  )
}

resource "aws_ec2_transit_gateway_route" "firewall_ingress" {
  destination_cidr_block = module.ingress_vpc.vpc_cidr_block
  blackhole              = false

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
}

resource "aws_ec2_transit_gateway_route" "firewall_egress" {
  destination_cidr_block = "0.0.0.0/0"
  blackhole              = false

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
}

resource "aws_ec2_transit_gateway_route" "firewall_workload" {
  for_each = var.workload_attachments

  destination_cidr_block = each.value.vpc_cidr
  blackhole              = false

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall.id
  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
}

resource "aws_route" "ingress" {
  route_table_id         = module.ingress_vpc.public_route_table_ids[0]
  destination_cidr_block = var.cidr_range_workload
  transit_gateway_id     = aws_ec2_transit_gateway.default.id
}

resource "aws_route" "egress_public" {
  route_table_id         = module.egress_vpc.public_route_table_ids[0]
  destination_cidr_block = var.cidr_range_workload
  transit_gateway_id     = aws_ec2_transit_gateway.default.id
}

resource "aws_route" "egress_private" {
  count = var.enable_nat_high_availability == true ? length(local.azs) : 1

  route_table_id         = module.egress_vpc.private_route_table_ids[count.index]
  destination_cidr_block = var.cidr_range_workload
  transit_gateway_id     = aws_ec2_transit_gateway.default.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_ingress_rta" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.ingress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_egress_rta" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.egress.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tg_workload_rta" {
  for_each = var.workload_attachments

  transit_gateway_attachment_id  = each.value.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.firewall.id
}


################################################################################
# Resource Access Manager
################################################################################

resource "aws_ram_resource_share" "default" {
  name                      = "${var.environment}-tgw-${replace(basename(path.cwd), "_", "-")}"
  allow_external_principals = false

  tags = merge(
    var.tags,
    { Name = "${var.environment}-tgw-${replace(basename(path.cwd), "_", "-")}" },
  )
}

resource "aws_ram_resource_association" "default" {
  resource_arn       = aws_ec2_transit_gateway.default.arn
  resource_share_arn = aws_ram_resource_share.default.id
}

resource "aws_ram_principal_association" "default" {
  count              = length(var.ram_principals)
  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.default.arn
}
