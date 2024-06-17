output "role_policy_attachment_id" {
  description = "The ID of the IAM role policy attachment."
  value       = aws_iam_role_policy_attachment.role_policy_attachment.id
}
