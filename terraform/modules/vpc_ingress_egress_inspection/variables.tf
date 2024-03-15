variable "environment" {
  type        = string
  description = "Short name of the environment (staging, production)"
}

variable "vpc_cidr_ingress" {
  type        = string
  description = "CIDR range of the VPC (must be a /24)"
}

variable "customer_gateways_ingress" {
  description = "Maps of ingress Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  type        = map(map(any))
  default     = {}
}

variable "vpc_cidr_egress" {
  type        = string
  description = "CIDR range of the VPC (must be a /24)"
}

variable "vpc_cidr_inspection" {
  type        = string
  description = "CIDR range of the VPC (must be a /24)"
}

variable "cidr_range_workload" {
  type        = string
  description = "CIDR range of the VPC (must be a /8)"
}

variable "azs" {
  type        = number
  description = "Number of availability zone"
}

variable "ram_principals" {
  type        = list(string)
  description = "RAM"
}

variable "workload_attachments" {
  type = map(object({
    vpc_cidr                      = string
    transit_gateway_attachment_id = string
  }))
  description = "Transit gateway attachments"
}

variable "enable_nat_high_availability" {
  description = "Enable NAT Gateway high availability"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_vpn_high_availability" {
  description = "Enable VNP high availability"
  type        = bool
  default     = false
}
