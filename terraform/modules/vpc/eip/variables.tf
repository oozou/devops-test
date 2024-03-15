variable "vpc" {
  default     = true
  description = "https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/eip.html#vpc"
  type        = bool
}
variable "name" {
  default     = ""
  description = "Name of the IP"
  type        = string
}
variable "instance" {
  default     = null
  description = "https://registry.terraform.io/providers/hashicorp/aws/4.67.0/docs/resources/eip#instance"
  type        = string
}
