output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "ecs_tasks_sg_id" {
  description = "ID of the Tasks security group"
  value       = aws_security_group.tasks.id
}

output "ecs_fargate_sg_id" {
  description = "ID of the Fargate security group"
  value       = aws_security_group.fargate.id
}