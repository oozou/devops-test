variable "create_private_key" {
  type        = bool
  default     = "false"
  description = "Only enable this when you perform a test installation on your local environment"
}

variable "aws_secretsmanager_flux_private_key" {
  type        = string
  default     = ""
  description = "Name of an AWS secretsmanager which flux private key"
}

variable "aws_secretsmanager_flux_public_key" {
  type        = string
  default     = ""
  description = "Name of an AWS secretsmanager which contains flux public key"
}

variable "aws_secretsmanager_flux_github_token" {
  type        = string
  description = "Name of an AWS secretsmanager which contains github token"
}

variable "github_org" {
  type        = string
  description = "This is the target GitHub organization or individual user account to manage. For example, torvalds and github are valid owners. It is optional to provide this value and it can also be sourced from the GITHUB_OWNER environment variable. When not provided and a token is available, the individual user account owning the token will be used. When not provided and no token is available, the provider may not function correctly."
}

variable "github_repository" {
  type        = string
  description = "(Required) Name of the GitHub repository."
}

variable "github_branch" {
  type        = string
  default     = "main"
  description = "Branch in repository to reconcile from"
}

variable "cluster_name" {
  type        = string
  description = "An EKS cluster name"
}

variable "flux_version" {
  type        = string
  default     = "v2.0.0-rc.5"
  description = "Flux version"
}

variable "flux_path" {
  type        = string
  description = "Path relative to the repository root, when specified the cluster sync will be scoped to this path"
}

variable "flux_components_extra" {
  type        = list(string)
  default     = []
  description = "List of extra components to include in the install manifests."
}

variable "kustomization_override" {
  type        = string
  default     = null
  description = "Kustomization to override configuration set by default."
}

variable "deploy_key_name" {
  type        = string
  description = "Name of the deploy key to be created"
}

variable "network_policy" {
  type        = bool
  description = "(Boolean) Deny ingress access to the toolkit controllers from other namespaces using network policies"
  default     = true
}
