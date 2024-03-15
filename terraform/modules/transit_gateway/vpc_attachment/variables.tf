variable "vpc_id" {
  description = "Identifier of EC2 VPC."
  type        = string
}

variable "subnet_ids" {
  description = "Identifiers of EC2 Subnets."
  type        = list(string)
}

variable "transit_gateway_id" {
  description = "Identifier of EC2 Transit Gateway."
  type        = string
}

variable "route_table_ids" {
  description = "The IDs of the routing tables."
  type        = list(string)
}

variable "destination_cidr_blocks" {
  description = "List of the destination CIDR block."
  type        = list(string)
}

variable "transit_gateway_default_route_table_association" {
  description = "(Optional) Boolean whether the VPC Attachment should be associated with the EC2 Transit Gateway association default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true."
  type        = bool
  default     = true
}

variable "transit_gateway_default_route_table_propagation" {
  description = "(Optional) Boolean whether the VPC Attachment should propagate routes with the EC2 Transit Gateway propagation default route table. This cannot be configured or perform drift detection with Resource Access Manager shared EC2 Transit Gateways. Default value: true."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Key-value tags for the EC2 Transit Gateway VPC Attachment. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = any
  default     = {}
}
