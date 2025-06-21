variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "peering_name" {
  description = "Name for the VPC peering connection."
  type        = string
}

variable "local_network" {
  description = "The self_link of the local VPC network for peering."
  type        = string
}

variable "peer_network" {
  description = "The self_link of the peer VPC network for peering."
  type        = string
}
