terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project_id
}

module "vpc_1" {
  source      = "./modules/vpc"
  project_id  = var.project_id
  region      = var.region_1
  vpc_name    = var.vpc_1_name
  subnet_name = "${var.vpc_1_name}-subnet"
  ip_cidr_range = "10.0.1.0/24"
}

module "vm_1" {
  source        = "./modules/vm"
  project_id    = var.project_id
  zone          = "${var.region_1}-a"
  vm_name       = var.vm_1_name
  machine_type  = "e2-medium"
  network_name  = module.vpc_1.network_name
  subnet_name   = module.vpc_1.subnet_name
  image         = "debian-cloud/debian-11"
}

module "vpc_2" {
  source      = "./modules/vpc"
  project_id  = var.project_id
  region      = var.region_2
  vpc_name    = var.vpc_2_name
  subnet_name = "${var.vpc_2_name}-subnet"
  ip_cidr_range = "10.0.2.0/24"
}

module "vm_2" {
  source        = "./modules/vm"
  project_id    = var.project_id
  zone          = "${var.region_2}-a"
  vm_name       = var.vm_2_name
  machine_type  = "e2-medium"
  network_name  = module.vpc_2.network_name
  subnet_name   = module.vpc_2.subnet_name
  image         = "debian-cloud/debian-11"
}

module "peering_1_to_2" {
  source           = "./modules/peering"
  project_id       = var.project_id
  local_network    = module.vpc_1.network_self_link
  peer_network     = module.vpc_2.network_self_link
  peering_name     = "${var.vpc_1_name}-to-${var.vpc_2_name}"
}

module "peering_2_to_1" {
  source           = "./modules/peering"
  project_id       = var.project_id
  local_network    = module.vpc_2.network_self_link
  peer_network     = module.vpc_1.network_self_link
  peering_name     = "${var.vpc_2_name}-to-${var.vpc_1_name}"
}
