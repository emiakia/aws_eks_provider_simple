resource "aws_iam_role" "iam_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = var.policy_version
    Statement = [{
      Action = var.policy_action
      Effect = var.policy_effect
      Principal = {
        Service = var.assume_role_service
      }
    }]
  })
}
