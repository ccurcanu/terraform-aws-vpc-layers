output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC id"
}

output "public_cidr_blocks" {
  value       = module.public-subnets.cidr_blocks
  description = "List of public subnet CIDR blocks"
}

output "private_cidr_blocks" {
  value       = module.private-subnets.cidr_blocks
  description = "List of private subnet CIDR blocks"
}

output "public_subnet_ids" {
  value       = module.public-subnets.ids
  description = "List of public subnet ids"
}

output "public_route_table_id" {
  value       = module.internet-gateway.route_table_id
  description = "Route table id associated with public subnets"
}

output "private_subnet_ids" {
  value       = module.private-subnets.ids
  description = "List of private subnet ids. None created if list is empty."
}

output "igw_id" {
  value       = module.internet-gateway.gateway_id
  description = "Internet gateway id"
}

output "bastion_ip" {
  value       = module.bastion-host.bastion_public_ip
  description = "Internet gateway id"
}
