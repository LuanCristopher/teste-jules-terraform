output "vm_1_ip" {
  description = "The internal IP address of vm-1."
  value       = module.vm_1.internal_ip
}

output "vm_2_ip" {
  description = "The internal IP address of vm-2."
  value       = module.vm_2.internal_ip
}

output "vpc_1_self_link" {
  description = "The self link of vpc_1."
  value       = module.vpc_1.network_self_link
}

output "vpc_2_self_link" {
  description = "The self link of vpc_2."
  value       = module.vpc_2.network_self_link
}
