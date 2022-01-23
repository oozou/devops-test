variable "project_id" {
  type = string
  description = "The project ID to host the network in"
}

variable "region" {
  type = string
  description = "The region to use"
}

variable "compute_ip_cidr_range" {
  type = string
  description = "compute ip cidr range"
}
