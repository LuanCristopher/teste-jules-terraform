variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region_1" {
  description = "Region for the first VPC and VM."
  type        = string
  default     = "us-west1"
}

variable "vpc_1_name" {
  description = "Name for the first VPC."
  type        = string
  default     = "luan-vpc-1"
}

variable "vm_1_name" {
  description = "Name for the first VM."
  type        = string
  default     = "vm-1"
}

variable "region_2" {
  description = "Region for the second VPC and VM."
  type        = string
  default     = "us-east1"
}

variable "vpc_2_name" {
  description = "Name for the second VPC."
  type        = string
  default     = "luan-vpc-2"
}

variable "vm_2_name" {
  description = "Name for the second VM."
  type        = string
  default     = "vm-2"
}
