variable "name" {
  description = "https://www.terraform.io/docs/providers/aws/r/iam_policy.html#name"
  type        = string
}
variable "policy" {
  default     = "{}"
  description = "https://www.terraform.io/docs/providers/aws/r/iam_policy.html#policy"
  type        = any
}
variable "path" {
  default     = "/"
  description = "https://www.terraform.io/docs/providers/aws/r/iam_role.html#path"
  type        = string
}
variable "description" {
  default     = ""
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy#description"
  type        = string
}
