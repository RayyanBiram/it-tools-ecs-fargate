variable "vpc_id" {
  description = "Cross module reference for VPC ID"
  type        = string
}

variable "aws_region" {
  description = "Default AWS region used to create all resources"
  type        = string
}

variable "private_subnet_ids" {
  description = "Cross module reference for Private subnet IDs"
  type        = list(string)
}

variable "private_route_table_id" {
  description = "Cross module reference for Private route table ID"
  type        = string
}

variable "ecs_fargate_sg_id" {
  description = "Cross module reference for Fargate security ID"
  type        = string
}