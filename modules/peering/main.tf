resource "google_compute_network_peering" "peering" {
  project                  = var.project_id
  name                     = var.peering_name
  network                  = var.local_network // This is the self_link of the local VPC
  peer_network             = var.peer_network  // This is the self_link of the peer VPC
  export_custom_routes     = true
  import_custom_routes     = true
}
