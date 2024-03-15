variable "vpc" {
  default     = {}
  type        = any
  description = "https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws?tab=inputs"
}

variable "environment" {
  type        = string
  description = "Name of the environment (staging, production)"
  default     = ""
}

variable "create_vpc_endpoint" {
  type        = bool
  description = "Determines whether vpc endpoint resources will be created"
  default     = false
}

variable "endpoints" {
  type        = any
  description = "https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/4.0.2/submodules/vpc-endpoints#input_endpoints"
  default     = {}
}
