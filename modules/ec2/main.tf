
resource "aws_instance" "ec2" {
  count         = var.count_instance
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  # security_groups = var.security_groups
  vpc_security_group_ids = var.security_groups

  user_data = var.user_data
  # tags = var.tags
  tags = merge(
    var.tags,
    {
      Name = "${var.machine_name}-${count.index}"
    }
  )
}