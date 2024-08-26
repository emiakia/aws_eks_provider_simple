variable "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  type        = string
  default     = "MyECSCluster"
}

variable "desired_capacity" {
  description = "Desired capacity for the Auto Scaling Group"
  type        = number
  default     = 0
}

variable "min_capacity" {
  description = "Minimum capacity for the Auto Scaling Group"
  type        = number
  default     = 0
}

variable "max_capacity" {
  description = "Maximum capacity for the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}
