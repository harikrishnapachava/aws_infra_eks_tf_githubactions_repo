
# 🚀 EKS Infrastructure on AWS using Terraform

This repository provisions an Amazon EKS cluster on AWS using Terraform. The infrastructure includes:
- A highly available VPC
- Private and public subnets across 3 Availability Zones
- NAT Gateway, Internet Gateway, and Route Tables
- An EKS cluster with managed node groups (worker nodes)
- IAM roles and policies
- GitHub Actions for automated deployment

---

## 🗂 Directory Structure

```
.
├── .github/workflows/aws-infra-eks.yml    # GitHub Actions CI/CD for Terraform
├── eks/
│   ├── backend.tf                         # Backend config for remote state (S3)
│   ├── main.tf                            # Invokes the reusable module with inputs
│   ├── prod.tfvars                        # Environment-specific variable values (production)
│   ├── variables.tf                       # Declares input variables for this environment
│   └── outputs.tf                         # Captures output variables after the environment is created
└── module/
    ├── eks.tf                             # Creates EKS control plane and managed node group
    ├── gather.tf                          # Outputs of resources
    ├── iam.tf                             # IAM roles and policies for EKS
    ├── vpc.tf                             # VPC, subnets, gateways, routing
    ├── variables.tf                       # Declares all variables required by the module
    └── outputs.tf                         # Declares the output variables to be displayed
```

---

## 📋 Prerequisites

- AWS Account with programmatic access
- Terraform v1.3 or above
- AWS CLI configured (`aws configure`)
- An existing S3 bucket for storing Terraform state
- GitHub repository secrets for GitHub Actions:

| Secret Name             | Description |
|-------------------------|-------------|
| `AWS_ACCESS_KEY_ID`     | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key |

---

## 🧪 Usage

### Step 1: Initialize Terraform Backend

```bash
cd eks
terraform init \
  -backend-config="bucket=<your-s3-bucket-name>" \
  -backend-config="key=eks/terraform.tfstate" \
  -backend-config="region=<aws-region>" \
  -backend-config="dynamodb_table=<your-lock-table>"
```

### Step 2: Plan Infrastructure

```bash
terraform plan -var-file="prod.tfvars"
```

### Step 3: Apply Infrastructure

```bash
terraform apply -var-file="prod.tfvars"
```

---

## 🌐 What Gets Created

- VPC with CIDR block and 6 subnets (3 private, 3 public) across **3 AZs**
- Internet Gateway for public subnets
- NAT Gateways for private subnets
- Route Tables with proper associations
- EKS control plane
- EKS managed node group in **3 Availability Zones**
- IAM roles and policies for EKS and autoscaling

---

## 🔁 GitHub Actions Workflow

File: `.github/workflows/aws-infra-eks.yml`

This GitHub Actions pipeline automates Terraform operations:

### 🧭 Workflow Steps

1. **Trigger**: On push to the `main` branch.
2. **Checkout Code**: Uses `actions/checkout@v2`
3. **Setup Terraform**: Uses `hashicorp/setup-terraform@v2`
4. **Terraform Init**: Initializes the Terraform backend.
5. **Terraform Format**: Ensures HCL files are properly formatted.
6. **Terraform Validate**: Validates syntax and configuration.
7. **Terraform Plan**: Generates an execution plan.
8. **Terraform Apply**: Applies the configuration **automatically** if `TF_AUTO_APPROVE` is set.

### ✅ Environment Variables

The following variables must be set in your repository's GitHub secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

You can optionally inject `TF_VAR_*` variables via GitHub secrets as well.

---

## 🧹 Destroy Infrastructure

To tear down all resources:

```bash
terraform destroy -var-file="prod.tfvars"
```

---

## Contributing

Contributions are welcome! Please submit pull requests to the repository: https://github.com/harikrishnapachava/aws_infra_eks_tf_githubactions_repo
