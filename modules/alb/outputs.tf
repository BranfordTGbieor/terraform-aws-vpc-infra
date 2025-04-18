output "alb_arn" {
  description = "ALB ARN"
  value       = aws_lb.alb.arn
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.app.arn
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.alb.dns_name
}

output "alb_security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}