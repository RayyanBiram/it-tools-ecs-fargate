output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.ecs.name
}