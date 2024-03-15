variable "vpc_id" {
  description = "The ID of the VPC to create the network ACL"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets to attach to the network ACL"
  type        = list(string)
}

variable "ipv4_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    rule_no   = number
    from_port = number
    to_port   = number
    protocol  = string
    action    = string
    cidr      = string
    icmp_code = number
    icmp_type = number
  }))
  default = [{
    rule_no   = 4000
    from_port = 0
    to_port   = 0
    protocol  = -1
    action    = "deny"
    cidr      = "0.0.0.0/0"
    icmp_code = 0
    icmp_type = 0
  }]
}

variable "ipv6_ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    rule_no         = number
    from_port       = number
    to_port         = number
    protocol        = string
    action          = string
    ipv6_cidr_block = string
    icmp_code       = number
    icmp_type       = number
  }))
  default = [{
    rule_no         = 6000
    from_port       = 0
    to_port         = 0
    protocol        = -1
    action          = "deny"
    ipv6_cidr_block = "::/0"
    icmp_code       = 0
    icmp_type       = 0
  }]
}

variable "ipv4_egress_rules" {
  description = "List of egress rules"
  type = list(object({
    rule_no   = number
    from_port = number
    to_port   = number
    protocol  = string
    action    = string
    cidr      = string
    icmp_code = number
    icmp_type = number
  }))
  default = [{
    rule_no   = 4000
    from_port = 0
    to_port   = 0
    protocol  = -1
    action    = "deny"
    cidr      = "0.0.0.0/0"
    icmp_code = 0
    icmp_type = 0
  }]
}

variable "ipv6_egress_rules" {
  description = "List of egress rules"
  type = list(object({
    rule_no         = number
    from_port       = number
    to_port         = number
    protocol        = string
    action          = string
    ipv6_cidr_block = string
    icmp_code       = number
    icmp_type       = number
  }))
  default = [{
    rule_no         = 6000
    from_port       = 0
    to_port         = 0
    protocol        = -1
    action          = "deny"
    ipv6_cidr_block = "::/0"
    icmp_code       = 0
    icmp_type       = 0
  }]
}
