resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = var.lblst_load_balancer_arn

  port     = var.lblst_port
  protocol = var.lblst_protocol

  default_action {
    type = var.lblst_default_action_type
    # target_group_arn = aws_lb_target_group.web_tg.arn
    target_group_arn = var.lblst_default_action_target_group_arn
  }
}
