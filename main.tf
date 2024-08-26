provider "aws" {
  region = "eu-central-1" # Replace with your desired region
}

# Data source to get specific VPC
data "aws_vpc" "specified_vpc" {
  id = "vpc-0cc7e1e8d0e236d78"
}

# Data source to get VPC subnets
data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.specified_vpc.id]
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eksClusterRole"
  description = "Amazon EKS - Cluster role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role     = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role     = aws_iam_role.eks_cluster_role.name
}

# IAM Role for Node Group
resource "aws_iam_role" "eks_node_group_role" {
  name = "EKSNodeGroupRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the EKS Node Group Role
resource "aws_iam_role_policy_attachment" "node_group_policies" {
  for_each = toset([
    "AmazonEC2ContainerRegistryReadOnly",
    "AmazonEKS_CNI_Policy",
    "AmazonEKSWorkerNodePolicy"
  ])
  
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
  role     = aws_iam_role.eks_node_group_role.name
}

# EKS Cluster
resource "aws_eks_cluster" "terraform_eks" {
  name     = "terraformEKS"
  role_arn  = aws_iam_role.eks_cluster_role.arn
  version   = "1.30"
  
  vpc_config {
    subnet_ids = data.aws_subnets.subnets.ids
    security_group_ids = [aws_security_group.default.id]
    endpoint_public_access = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_policy
  ]
}

# Node Group
resource "aws_eks_node_group" "terraform_eks_node_group" {
  cluster_name    = aws_eks_cluster.terraform_eks.name
  node_group_name = "terraformEKSNodeGroup"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = data.aws_subnets.subnets.ids
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }
  instance_types = ["t2.micro"]
  disk_size      = 10
  ami_type       = "AL2_x86_64"

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_group_policies
  ]
}

# Security Group for EKS Nodes (default security group)
resource "aws_security_group" "default" {
  vpc_id = data.aws_vpc.specified_vpc.id
}

# EKS Add-ons
resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.terraform_eks.name
  addon_name   = "coredns"
  addon_version = "v1.11.1-eksbuild.8"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.terraform_eks.name
  addon_name   = "kube-proxy"
  addon_version = "v1.30.0-eksbuild.3"
}
