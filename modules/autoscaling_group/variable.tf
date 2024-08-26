variable "asg_desired_capacity" {
  type        = number
  description = "The desired number of instances in the Auto Scaling group."
}

variable "asg_max_size" {
  type        = number
  description = "The maximum size of the Auto Scaling group."
}

variable "asg_min_size" {
  type        = number
  description = "The minimum size of the Auto Scaling group."
}

variable "asg_vpc_zone_identifier" {
  type        = list(string)
  description = "A list of subnet IDs for the VPC."
}

variable "asg_launch_template_id" {
  type        = string
  description = "The ID of the launch template."
}

variable "asg_launch_template_version" {
  type        = string
  description = "The version of the launch template."
}

variable "asg_tag_name" {
  type        = string
  description = "The Name tag for instances launched in the ASG."
}

variable "asg_health_check_type" {
  type        = string
  default     = "EC2"
  description = "The type of health check to use for the ASG."
}

variable "asg_health_check_grace_period" {
  type        = number
  default     = 300
  description = "The time to wait before checking the health of the instance."
}

variable "asg_target_group_arns" {
  type        = list(string)
  description = "A list of target group ARNs."
}
