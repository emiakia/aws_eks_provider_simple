# ECS Cluster with Fargate and EC2 Instances

## Overview

This Terraform configuration sets up an Amazon ECS (Elastic Container Service) environment with both Fargate and EC2 launch types. It includes:

- **ECS Cluster**: Named `MyECSCluster`.
- **Auto Scaling Group**: Manages EC2 instances with a maximum of 3 instances, on-demand provisioning.
- **EC2 Instances**: Uses Amazon Linux 2 (kernel 5.10) with `t2.micro` instance type.
- **Task Definition**: Configured for both Fargate and EC2 launch types.
- **Service**: Uses AWS Fargate with a specified deployment configuration.
- **Application Load Balancer (ALB)**: Distributes traffic to ECS services with health checks.

## Components

1. **ECS Cluster**
   - Creates an ECS Cluster named `MyECSCluster`.
   - Supports both Fargate and EC2 launch types.

2. **Auto Scaling Group**
   - Configures an Auto Scaling Group with:
     - Desired capacity: 0
     - Minimum capacity: 0
     - Maximum capacity: 3
   - Uses an Amazon Linux 2 AMI with `t2.micro` instances.
   - Configures the ECS agent on EC2 instances to join the `MyECSCluster`.

3. **EC2 Launch Configuration**
   - Uses Amazon Linux 2 (kernel 5.10).
   - `t2.micro` instance type.
   - Attaches a security group allowing inbound HTTP traffic on port 80.

4. **Task Definition**
   - Family name: `nginxdemos-hello`.
   - Supports both Fargate and EC2 launch types.
   - Container: `nginxdemos/hello`.
   - CPU: 0.5 vCPU allocated, with a limit of 1 vCPU.
   - Memory: 3GB allocated, with a limit of 3GB.

5. **ECS Service**
   - Launch type: Fargate.
   - Platform version: `LATEST`.
   - Deployment configuration: Replica with 1 desired task.
   - Connects to the ALB with a target group.

6. **Application Load Balancer (ALB)**
   - Name: `albForECS`.
   - Listens on port 80 with HTTP protocol.
   - Forward requests to the ECS service.
   - Health checks on path `/` with a delay of 300 seconds.

## How It Works

- **ECS Cluster**: Serves as the logical grouping for the services and tasks.
- **Auto Scaling Group**: Ensures there are up to 3 EC2 instances available for running tasks if required. It uses a Launch Configuration to define instance settings.
- **Task Definition**: Defines how tasks should run, including CPU and memory limits, and the container image to use.
- **ECS Service**: Manages the desired number of running tasks based on the task definition.
- **Application Load Balancer**: Routes incoming HTTP traffic to the ECS service and performs health checks to ensure traffic is only routed to healthy instances.

## Usage

1. **Initialize Terraform**

   Navigate to the directory containing your Terraform configuration and run:

   ```bash
   terraform init
   terraform plan
   terraform apply -auto-approve
