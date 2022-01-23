terraform {
  required_providers {
	google = {
	  source = "hashicorp/google"
	}
  }
}


provider "google" {
  credentials = file(var.credentials_file_path)
  project = var.project_id
  region  = var.region
  zone    = var.main_zone
}

module "google_networks" {
  source = "./modules/networks"

  project_id = var.project_id
  region     = var.region
  compute_ip_cidr_range = var.compute_ip_cidr_range
}

module "google_kubernetes_cluster" {
  source = "./modules/kubernetes_cluster"

  project_id                 = var.project_id
  region                     = var.region
  node_zones                 = var.cluster_node_zones
  service_account            = var.service_account
  network_name               = module.google_networks.network.name
  subnet_name                = module.google_networks.subnet.name
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  pods_ipv4_cidr_block       = var.pods_ip_cidr_range
  services_ipv4_cidr_block   = var.services_ip_cidr_range
  authorized_ipv4_cidr_block = "${module.bastion.ip}/32"
}


module "bastion" {
  source = "./modules/bastion"

  project_id   = var.project_id
  region       = var.region
  zone         = var.main_zone
  bastion_name = "app-cluster"
  network_name = module.google_networks.network.name
  subnet_name  = module.google_networks.subnet.name
}

resource "google_artifact_registry_repository" "my-repo" {
  provider = google-beta
  location = var.region
  repository_id = "my-repository"
  description = "example docker repository"
  format = "DOCKER"
}
