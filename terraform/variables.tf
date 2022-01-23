variable "project_id" {
  type = string
  description = "The ID of the project to create resources in"
}

variable "region" {
  type = string
  description = "The region to use"
}

variable "main_zone" {
  type = string
  description = "The zone to use as primary"
}

variable "cluster_node_zones" {
  type = list(string)
  description = "The zones where Kubernetes cluster worker nodes should be located"
}

variable "credentials_file_path" {
  type = string
  description = "The credentials JSON file used to authenticate with GCP"
}

variable "service_account" {
  type = string
  description = "The GCP service account"
}

variable "master_ipv4_cidr_block" {
  type = string
  description = "The gke master_ipv4_cidr_block"
}

variable "pods_ip_cidr_range" {
  type = string
  description = "The gke pods_ip_cidr_range"
}

variable "services_ip_cidr_range" {
  type = string
  description = "The gke cluster_services_ip_cidr_range"
}

variable "compute_ip_cidr_range" {
  type = string
  description = "The compute_ip_cidr_range"
}

