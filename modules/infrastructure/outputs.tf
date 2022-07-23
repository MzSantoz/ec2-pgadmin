output "vpc_id" {
  description = "ID that identify the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "The private subnets list"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "The public subnets list"
  value       = module.vpc.public_subnets
}

output "database_subnets" {
  description = "The database subnets list"
  value       = module.vpc.database_subnets
}

output "database_subnet_group" {
  description = "The database subnet group name"
  value       = module.vpc.database_subnet_group
}

output "private_subnets_cidr_blocks" {
  description = "The list of CIDR blocks from private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
}