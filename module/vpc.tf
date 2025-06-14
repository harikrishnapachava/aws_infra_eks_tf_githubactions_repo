locals {
  cluster-name = var.cluster-name
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr-block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc-name
    Env  = var.env

  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name                                          = var.igw-name
    env                                           = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_subnet" "public-subnet" {
  count                   = var.pub-subnet-count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pub-cidr-block, count.index)
  availability_zone       = element(var.pub-availability-zone, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name                                          = "${var.pub-sub-name}-${count.index + 1}"
    Env                                           = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
    "kubernetes.io/role/elb"                      = "1"
  }

  depends_on = [aws_vpc.vpc,
  ]
}

resource "aws_subnet" "private-subnet" {
  count                   = var.pri-subnet-count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pri-cidr-block, count.index)
  availability_zone       = element(var.pri-availability-zone, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name                                          = "${var.pri-sub-name}-${count.index + 1}"
    Env                                           = var.env
    "kubernetes.io/cluster/${local.cluster-name}" = "owned"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  depends_on = [aws_vpc.vpc,
  ]
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public-rt-name
    env  = var.env
  }

  depends_on = [aws_vpc.vpc
  ]
}

resource "aws_route_table_association" "name" {
  count          = 3
  route_table_id = aws_route_table.public-rt.id
  subnet_id      = aws_subnet.public-subnet[count.index].id

  depends_on = [aws_vpc.vpc,
    aws_subnet.public-subnet
  ]
}

resource "aws_eip" "ngw-eip" {
  count  = length(var.pub-cidr-block)
  domain = "vpc"

  tags = {
    Name = "${var.eip-name}-${count.index + 1}"
  }

  depends_on = [aws_vpc.vpc]
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.pub-cidr-block)
  allocation_id = aws_eip.ngw-eip[count.index].id
  subnet_id     = aws_subnet.public-subnet[count.index].id

  tags = {
    Name = "${var.ngw-name}-${count.index + 1}"
  }

  depends_on = [aws_eip.ngw-eip]
}

resource "aws_route_table" "private-rt" {
  count  = length(var.pri-cidr-block)
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }

  tags = {
    Name = "${var.private-rt-name}-${count.index + 1}"
    env  = var.env
  }

  depends_on = [aws_nat_gateway.ngw]
}

resource "aws_route_table_association" "private-rt-association" {
  count          = length(var.pri-cidr-block)
  route_table_id = aws_route_table.private-rt[count.index].id
  subnet_id      = aws_subnet.private-subnet[count.index].id

  depends_on = [aws_route_table.private-rt]
}

resource "aws_security_group" "eks-cluster-sg" {
  name        = var.eks-sg
  description = "Allow 443 from Jump Server only"

  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // It should be specific IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.eks-sg
  }
}