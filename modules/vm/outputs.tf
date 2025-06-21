output "instance_name" {
  description = "The name of the VM instance."
  value       = google_compute_instance.vm.name
}

output "internal_ip" {
  description = "The internal IP address of the VM instance."
  value       = google_compute_instance.vm.network_interface[0].network_ip
}

output "external_ip" {
  description = "The external IP address of the VM instance (if configured)."
  value       = try(google_compute_instance.vm.network_interface[0].access_config[0].nat_ip, "N/A")
}
