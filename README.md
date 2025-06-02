
# EKS Infrastructure on AWS using Terraform

This repository provisions an Amazon EKS cluster on AWS using Terraform. The infrastructure includes:
- A highly available VPC
- Private and public subnets across 3 Availability Zones
- NAT Gateway, Internet Gateway, and Route Tables
- An EKS cluster with managed node groups (worker nodes)
- IAM roles and policies
- GitHub Actions for automated deployment
