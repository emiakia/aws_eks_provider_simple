output "iam_role_id" {
  description = "The ID of the IAM role."
  value       = aws_iam_role.iam_role.id
}

output "iam_role_name" {
  description = "The name of the IAM role."
  value       = aws_iam_role.iam_role.name
}

output "iam_role_arn" {
  description = "The ARN of the IAM role."
  value       = aws_iam_role.iam_role.arn
}
