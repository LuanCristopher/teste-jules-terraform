variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "Region for the VPC."
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC."
  type        = string
}

variable "subnet_name" {
  description = "Name for the subnet."
  type        = string
}

variable "ip_cidr_range" {
  description = "IP CIDR range for the subnet."
  type        = string
}
