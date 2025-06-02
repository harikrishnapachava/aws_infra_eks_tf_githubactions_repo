output "vpc_id" {
  value       = module.eks.vpc_id
  description = "ID of the created VPC"
}

output "vpc_cidr_block" {
  value       = module.eks.vpc_cidr_block
  description = "CIDR block of the VPC"
}

output "public_subnet_ids" {
  value       = module.eks.public_subnet_ids
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = module.eks.private_subnet_ids
  description = "List of private subnet IDs"
}

output "availability_zones" {
  value       = module.eks.availability_zones
  description = "List of Availability Zones used for subnets"
}

output "internet_gateway_id" {
  value       = module.eks.internet_gateway_id
  description = "Internet Gateway ID"
}

output "public_route_table_id" {
  value       = module.eks.public_route_table_id
  description = "Route Table ID for public subnets"
}

output "private_route_table_ids" {
  value       = module.eks.private_route_table_ids
  description = "List of private route table IDs"
}

output "nat_gateway_ids" {
  value       = module.eks.nat_gateway_ids
  description = "List of NAT Gateway IDs (1 per AZ)"
}

output "nat_gateway_ips" {
  value       = module.eks.nat_gateway_ips
  description = "List of Elastic IPs for NAT Gateways"
}

output "eks_security_group_id" {
  value       = module.eks.eks_security_group_id
  description = "Security group ID used by EKS cluster"
}
