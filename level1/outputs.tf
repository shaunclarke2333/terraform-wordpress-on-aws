# Output for main-vpc id
output "main-vpc-id" {
  description = "will be used by devices that depend on the vpc ID"
  value       = module.main-vpc.vpc_id
  sensitive   = true
}

# Output for all main public subnets id
output "main-public-subnet" {
  description = "will be used by devices that depend on public subnet ID"
  value       = module.main-vpc.public_subnets
  sensitive   = true
}

# Output for main-private subnet id
output "main-private-subnet" {
  description = "will be used by devices that depend on private subnet ID"
  value       = module.main-vpc.private_subnets
  sensitive   = true
}

# Output for main-private subnet cidr block
output "main-private-subnet-cidr-block" {
  description = "will be used by devices that depend on private subnet ID"
  value       = module.main-vpc.private_subnets_cidr_blocks
  sensitive   = true
}
