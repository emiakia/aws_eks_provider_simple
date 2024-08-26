# Terraform EKS Cluster Configuration

This Terraform configuration sets up an Amazon EKS (Elastic Kubernetes Service) cluster with the following specifications:

- **Cluster Name:** `terraformEKS`
- **Kubernetes Version:** 1.30
- **Node Group Name:** `terraformEKSNodeGroup`
- **Node Instance Type:** `t2.micro`
- **Disk Size:** 10GB
- **AMI Type:** Amazon Linux 2 (AL2_x86_64)
- **Scaling Configuration:** Desired size 2, minimum size 2, maximum size 2
- **Add-ons:** CoreDNS, kube-proxy

## Features

- **IAM Roles:** Creates necessary IAM roles and attaches appropriate policies for the EKS cluster and node group.
- **EKS Cluster:** Configures an EKS cluster with public endpoint access and associated VPC and subnets.
- **Node Group:** Defines a node group with on-demand EC2 instances, using a specified AMI and scaling configuration.
- **Security Group:** Uses the default security group for the EKS nodes.
- **Add-ons:** Configures CoreDNS and kube-proxy add-ons compatible with Kubernetes 1.30.


### VPC and Subnets

The configuration uses the default VPC and retrieves subnets associated with a specified VPC ID (`vpc-0cc7e1e8d0e236d78`).

### IAM Roles and Policies

- **Cluster Role:** `eksClusterRole` with policies `AmazonEKSClusterPolicy` and `AmazonEKSVPCResourceController`.
- **Node Group Role:** `EKSNodeGroupRole` with policies `AmazonEC2ContainerRegistryReadOnly`, `AmazonEKS_CNI_Policy`, and `AmazonEKSWorkerNodePolicy`.

### EKS Cluster

- **Name:** `terraformEKS`
- **Version:** 1.30
- **Endpoint Access:** Public
- **Add-ons:**
  - **CoreDNS:** `v1.11.1-eksbuild.8`
  - **kube-proxy:** `v1.30.0-eksbuild.3`

### Node Group

- **Name:** `terraformEKSNodeGroup`
- **Instance Type:** `t2.micro`
- **AMI Type:** `AL2_x86_64`
- **Disk Size:** 10GB
- **Scaling Configuration:** Desired size 2, minimum size 2, maximum size 2
- **Update Configuration:** Maximum unavailable node set to 1

## Usage

1. **Clone the Repository**

   Clone the repository containing this Terraform configuration to your local machine.

   ```bash
   git clone https://github.com/yourusername/your-repository.git
   cd your-repository

2. **Initialize Terraform**

   Navigate to the directory containing your Terraform configuration and run:

   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
