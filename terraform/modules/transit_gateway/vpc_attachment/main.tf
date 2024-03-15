locals {
  dest_cidr_block_and_route_table_combination = setproduct(var.route_table_ids, var.destination_cidr_blocks)
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids

  dns_support                                     = "enable"
  ipv6_support                                    = "disable"
  appliance_mode_support                          = "disable"
  transit_gateway_default_route_table_association = var.transit_gateway_default_route_table_association
  transit_gateway_default_route_table_propagation = var.transit_gateway_default_route_table_propagation

  tags = var.tags
}

resource "aws_route" "this" {
  count = length(local.dest_cidr_block_and_route_table_combination)

  route_table_id         = local.dest_cidr_block_and_route_table_combination[count.index][0]
  destination_cidr_block = local.dest_cidr_block_and_route_table_combination[count.index][1]
  transit_gateway_id     = var.transit_gateway_id
}
