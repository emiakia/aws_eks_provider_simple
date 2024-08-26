
resource "aws_lb_target_group_attachment" "web_tg_attachment" {
  count            = length(var.lbtgatt_count_instance)
  target_group_arn = var.lbtgatt_target_group_arn
  target_id        = var.lbtgatt_count_instance[count.index]
  port             = var.lbtgatt_port
}


# resource "aws_lb_target_group_attachment" "web_tg_attachment" {
#   count            = var.lbtgatt_count_instance
#   target_group_arn = var.lbtgatt_target_group_arn
#   target_id        = var.lbtgatt_target_id
#   port             = var.lbtgatt_port
# }
