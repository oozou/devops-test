variable "description" {
  type        = string
  default     = ""
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key.html#description"
}
variable "is_enabled" {
  type        = bool
  default     = true
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key.html#is_enabled"
}
variable "enable_key_rotation" {
  type        = bool
  default     = false
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key.html#enable_key_rotation"
}
variable "tags" {
  type        = map(any)
  default     = {}
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key.html#tags"
}
variable "name" {
  type        = string
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias.html#name"
}
variable "policy" {
  type        = string
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#policy"
  default     = null
}
