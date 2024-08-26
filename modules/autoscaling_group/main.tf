resource "aws_autoscaling_group" "asg" {
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  min_size            = var.asg_min_size
  vpc_zone_identifier = var.asg_vpc_zone_identifier

  launch_template {
    id      = var.asg_launch_template_id
    version = var.asg_launch_template_version
  }

  tag {
    key                 = "Name"
    value               = var.asg_tag_name
    propagate_at_launch = true
  }
  health_check_type         = var.asg_health_check_type
  health_check_grace_period = var.asg_health_check_grace_period

  target_group_arns = var.asg_target_group_arns

  lifecycle {
    create_before_destroy = true
  }
}