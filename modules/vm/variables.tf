variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "zone" {
  description = "Zone for the VM instance."
  type        = string
}

variable "vm_name" {
  description = "Name for the VM instance."
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM instance."
  type        = string
  default     = "e2-medium"
}

variable "network_name" {
  description = "The name of the VPC network to attach the VM to."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnetwork to attach the VM to."
  type        = string
}

variable "image" {
  description = "The image to use for the boot disk."
  type        = string
  default     = "debian-cloud/debian-11"
}
