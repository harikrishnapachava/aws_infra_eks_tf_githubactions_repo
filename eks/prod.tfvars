env                   = "prod"
aws-region            = "me-central-1"
vpc-cidr-block        = "10.16.0.0/16"
vpc-name              = "vpc"
igw-name              = "igw"
pub-subnet-count      = 3
pub-cidr-block        = ["10.16.0.0/20", "10.16.16.0/20", "10.16.32.0/20"]
pub-availability-zone = ["me-central-1a", "me-central-1b", "me-central-1c"]
pub-sub-name          = "subnet-public"
pri-subnet-count      = 3
pri-cidr-block        = ["10.16.128.0/20", "10.16.144.0/20", "10.16.160.0/20"]
pri-availability-zone = ["me-central-1a", "me-central-1b", "me-central-1c"]
pri-sub-name          = "subnet-private"
public-rt-name        = "public-route-table"
private-rt-name       = "private-route-table"
eip-name              = "elasticip-ngw"
ngw-name              = "ngw"
eks-sg                = "eks-sg"

# EKS
is-eks-cluster-enabled     = true
cluster-version            = "1.32"
cluster-name               = "eks-cluster"
endpoint-private-access    = true
endpoint-public-access     = false
ondemand_instance_types    = ["t3a.medium"]
desired_capacity_on_demand = "1"
min_capacity_on_demand     = "1"
max_capacity_on_demand     = "5"
addons = [
  {
    name    = "vpc-cni",
    version = "v1.19.5-eksbuild.3"
  },
  {
    name    = "coredns"
    version = "v1.11.4-eksbuild.14"
  },
  {
    name    = "kube-proxy"
    version = "v1.32.3-eksbuild.7"
  },
  {
    name    = "aws-ebs-csi-driver"
    version = "v1.44.0-eksbuild.1"
  }
  # Add more addons as needed
]