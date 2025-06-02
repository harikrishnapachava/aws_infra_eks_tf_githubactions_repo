output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the created VPC"
}

output "vpc_cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "CIDR block of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public-subnet[*].id
  description = "List of public subnet IDs"
}

output "private_subnet_ids" {
  value       = aws_subnet.private-subnet[*].id
  description = "List of private subnet IDs"
}

output "availability_zones" {
  value       = aws_subnet.public-subnet[*].availability_zone
  description = "List of Availability Zones used for subnets"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "Internet Gateway ID"
}

output "public_route_table_id" {
  value       = aws_route_table.public-rt.id
  description = "Route Table ID for public subnets"
}

output "private_route_table_ids" {
  value       = aws_route_table.private-rt[*].id
  description = "List of private route table IDs"
}

output "nat_gateway_ids" {
  value       = aws_nat_gateway.ngw[*].id
  description = "List of NAT Gateway IDs (1 per AZ)"
}

output "nat_gateway_ips" {
  value       = aws_eip.ngw-eip[*].public_ip
  description = "List of Elastic IPs for NAT Gateways"
}

output "eks_security_group_id" {
  value       = aws_security_group.eks-cluster-sg.id
  description = "Security group ID used by EKS cluster"
}
