variable "container_port" {
  description = "Docker container port"
  type        = number
}

variable "image_tag" {
  description = "Tag of the image stored in ECR"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  type        = list(string)
}

variable "ecs_tasks_sg_id" {
  description = "ID of the Tasks security group"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "repository_url" {
  description = "URL of the repository"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the execution role"
  type        = string
}

variable "protocol" {
  description = "Transport protocol"
  type        = string
}

variable "aws_region" {
  description = "Default AWS region used to create all resources"
  type        = string
}