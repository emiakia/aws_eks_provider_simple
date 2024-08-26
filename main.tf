provider "aws" {
  region = "eu-central-1" 
}

# VPC Data
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow inbound access on port 80"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "MyECSCluster" {
  name = "MyECSCluster"  # Replace with variable if needed
}

# Data Source for Amazon Linux 2 AMI
data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Launch Configuration for Auto Scaling Group
resource "aws_launch_configuration" "ecs_launch_config" {
  name          = "ecs-launch-config"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = "t2.micro"  # Replace with variable if needed
  security_groups = [
    aws_security_group.ecs_sg.id
  ]

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.MyECSCluster.name} >> /etc/ecs/ecs.config
              EOF

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_role.name
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity     = 0
  max_size             = 3
  min_size             = 0
  launch_configuration = aws_launch_configuration.ecs_launch_config.id
  vpc_zone_identifier  = data.aws_subnets.default.ids

  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "nginxdemos_hello" {
  family                   = "nginxdemos-hello"
  cpu                      = "512"
  memory                   = "3072"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = jsonencode([{
    name  = "nginxdemos-hello"
    image = "nginxdemos/hello"
    cpu   = 512
    memory = 3072
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])
}

# ECS Service
resource "aws_ecs_service" "nginxdemos_hello_service" {
  name            = "nginxdemos-hello"
  cluster         = aws_ecs_cluster.MyECSCluster.id
  task_definition = aws_ecs_task_definition.nginxdemos_hello.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = "LATEST"
  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.tg_nginxdemos_hello.arn
    container_name   = "nginxdemos-hello"
    container_port   = 80
  }
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  depends_on = [aws_lb_listener.alb_listener]
}

# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "albForECS"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = data.aws_subnets.default.ids
}

# Load Balancer Listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_nginxdemos_hello.arn
  }
}

# Load Balancer Target Group
resource "aws_lb_target_group" "tg_nginxdemos_hello" {
  name     = "tg-nginxdemos-hello"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  target_type = "ip"  # Change target type to 'ip'

  health_check {
    protocol = "HTTP"
    path     = "/"
    interval = 300
  }
}

# IAM Roles for ECS
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs_task_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = "ecs-instance-role"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs_instance_role.name
}
