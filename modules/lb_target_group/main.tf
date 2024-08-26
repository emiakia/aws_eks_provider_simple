resource "aws_lb_target_group" "web_tg" {
  name     = var.lbtg_name
  port     = var.lbtg_port
  protocol = var.lbtg_protocol
  vpc_id   = var.lbtg_vpc_id

  health_check {
    path                = var.lbtg_health_check_path
    protocol            = var.lbtg_health_check_protocol
    matcher             = var.lbtg_health_check_matcher
    interval            = var.lbtg_health_check_interval
    timeout             = var.lbtg_health_check_timeout
    healthy_threshold   = var.lbtg_healthy_threshold
    unhealthy_threshold = var.lbtg_unhealthy_threshold
  }

  tags = var.lbtg_tags
}
