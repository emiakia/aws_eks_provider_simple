variable "iam_role_name" {
  description = "The name of the IAM role."
  type        = string
  default     = "ecs_task_execution_role"
}

variable "assume_role_service" {
  description = "The service that assumes the IAM role."
  type        = string
  default     = "ecs-tasks.amazonaws.com"
}

variable "policy_version" {
  description = "The version of the policy."
  type        = string
  default     = "2012-10-17"
}

variable "policy_action" {
  description = "The action allowed by the policy."
  type        = string
  default     = "sts:AssumeRole"
}

variable "policy_effect" {
  description = "The effect of the policy."
  type        = string
  default     = "Allow"
}

variable "iam_role_description" {
  description = "The description of the role."
  type        = string
  default     = "Amazon EKS - Cluster role"
}

