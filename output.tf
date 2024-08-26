output "ecs_cluster_name" {
  description = "The name of the ECS Cluster"
  value       = aws_ecs_cluster.MyECSCluster.name
}

output "ecs_service_name" {
  description = "The name of the ECS Service"
  value       = aws_ecs_service.nginxdemos_hello_service.name
}

output "ecs_task_definition" {
  description = "The ECS Task Definition"
  value       = aws_ecs_task_definition.nginxdemos_hello.family
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}
