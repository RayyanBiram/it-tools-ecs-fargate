output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.ecs.id
}

output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = [aws_subnet.public-2a-ecs.id, aws_subnet.public-2b-ecs.id]
}

output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = [aws_subnet.private-2a-ecs.id, aws_subnet.private-2b-ecs.id]
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public-ecs.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private-ecs.id
}