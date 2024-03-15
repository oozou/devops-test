variable "environment" {
  type        = string
  description = "Short name of the environment (qa, staging, production)"
}

variable "random_suffix" {
  type        = string
  description = "Random suffix to anonymize a project name"
}
