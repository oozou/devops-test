variable "repository_name" {
  description = "The name of the repository"
  type        = string
  default     = ""
}

variable "repository_read_write_access_arns" {
  description = "The ARNs of the IAM users/roles that have read/write access to the repository"
  type        = list(string)
  default     = []

}
variable "repository_read_access_arns" {
  description = "The ARNs of the IAM users/roles that have read access to the repository	"
  type        = list(string)
  default     = []
}

variable "repository_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: `MUTABLE` or `IMMUTABLE`. Defaults to `IMMUTABLE`"
  type        = string
  default     = "IMMUTABLE"
}

variable "repository_lifecycle_policy" {
  description = "The policy document. This is a JSON formatted string. See more details about [Policy Parameters](http://docs.aws.amazon.com/AmazonECR/latest/userguide/LifecyclePolicies.html#lifecycle_policy_parameters) in the official AWS docs"
  type        = string
  default     = ""
}


variable "repository_type" {
  description = "Defines if the repository is public or private"
  type        = string
  default     = "private"
}
