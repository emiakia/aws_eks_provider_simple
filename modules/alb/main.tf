resource "aws_alb" "web_alb" {
  name               = var.alb_name
  internal           = var.alb_internal
  load_balancer_type = var.alb_load_balancer_type
  security_groups    = var.alb_security_groups
  subnets            = var.alb_subnets

  enable_deletion_protection = var.alb_enable_deletion_protection

  tags = var.alb_tags
}