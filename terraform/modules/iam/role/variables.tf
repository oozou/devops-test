variable "name" {
  description = "https://www.terraform.io/docs/providers/aws/r/iam_role.html#name"
  type        = string
}
variable "assume_role_policy" {
  default     = "{}"
  description = "https://www.terraform.io/docs/providers/aws/r/iam_role.html#assume_role_policy"
  type        = any
}
variable "path" {
  default     = "/"
  description = "https://www.terraform.io/docs/providers/aws/r/iam_role.html#path"
  type        = string
}
variable "external_role" {
  default     = ""
  description = "Pass an external role to be attached to a policy"
  type        = string
}
variable "attached_policies" {
  default     = []
  description = "A list of policies to attach"
  type        = list(string)
}
variable "description" {
  default     = ""
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#description"
  type        = string
}
variable "create_instance_profile" {
  default     = false
  description = "Whether to create an instance profile from the role"
  type        = bool
}
variable "tags" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#tags"
  type        = map(string)
  default = {
    "Excluded" = "false"
  }
}
