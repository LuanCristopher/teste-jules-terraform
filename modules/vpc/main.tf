resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet" {
  project                  = var.project_id
  name                     = var.subnet_name
  ip_cidr_range            = var.ip_cidr_range
  region                   = var.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true
}

resource "google_compute_firewall" "allow_icmp_internal" {
  project = var.project_id
  name    = "${var.vpc_name}-allow-icmp-internal"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "icmp"
  }
  source_ranges = ["0.0.0.0/0"] # Allows ICMP from any source within the VPC and peered VPCs
}

resource "google_compute_firewall" "allow_ssh" {
  project = var.project_id
  name    = "${var.vpc_name}-allow-ssh"
  network = google_compute_network.vpc.self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # Allows SSH from any source, adjust as needed for security
}
