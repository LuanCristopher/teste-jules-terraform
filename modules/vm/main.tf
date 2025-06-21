resource "google_compute_instance" "vm" {
  project      = var.project_id
  zone         = var.zone
  name         = var.vm_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network    = var.network_name
    subnetwork = var.subnet_name
  }

  // Enabling metadata allows scripts to be run on startup, if needed
  metadata_startup_script = "#!/bin/bash\n# Placeholder for startup scripts"

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}
