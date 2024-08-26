output "alb_arn" {
  description = "The ARN of the Load Balancer"
  value       = aws_alb.web_alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Load Balancer"
  value       = aws_alb.web_alb.dns_name
}
