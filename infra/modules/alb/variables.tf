variable "vpc_id" {
  description = "Cross module reference for ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "Cross module reference for list of IDs of the public subnets"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Cross module reference for ID of the ALB security group"
  type        = string
}

variable "certificate_arn" {
  description = "Cross module reference for Certificate ARN"
  type        = string
}

variable "zone_id" {
  description = "Cross module reference for Route 53 Hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "Domain name"
  type        = string
}

variable "target_group_protocol" {
  description = "Target group health check protocol"
  type        = string
}

variable "container_port" {
  description = "Docker container port"
  type        = number
}