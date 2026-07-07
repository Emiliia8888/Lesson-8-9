output "vpc_id" {
  value       = module.aws_vpc.vpc_id
  description = "The ID of the created VPC"
}

output "private_subnets" {
  value       = module.aws_vpc.private_subnets
  description = "List of IDs of private subnets"
}
