resource "aws_launch_template" "web_server_lt" {
  name_prefix = var.wslt_name_prefix

  image_id      = var.wslt_image_id
  instance_type = var.wslt_instance_type
  key_name      = var.wslt_key_name

  user_data = var.wslt_user_data

  network_interfaces {
    security_groups = var.wslt_security_group
  }

  lifecycle {
    create_before_destroy = true # or false, depending on your need
  }

  tags = var.wslt_tags
}