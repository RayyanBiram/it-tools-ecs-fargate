variable "aws_region" {
  description = "Default AWS region used to create all resources"
  type        = string
}

variable "domain_name" {
  description = "Domain name used to host app"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
}

variable "availability_zone" {
  description = "Availability zones 2a and 2b"
  type        = list(string)
}

variable "public_subnet_cidr" {
  description = "Public CIDR for the subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "CIDR for the subnets"
  type        = list(string)
}

variable "route_cidr" {
  description = "CIDR for the route table"
  type        = string
}

variable "alb_ingress_port" {
  description = "ingress port for alb"
  type        = list(number)
}

variable "protocol" {
  description = "Transport protocol"
  type        = string
}

variable "cidr_ipv4" {
  description = "CIDR ipv4 for ingress/egress rules"
  type        = string
}

variable "container_port" {
  description = "Docker container port"
  type        = number
}

variable "tasks_egress_port" {
  description = "Egress port for tasks"
  type        = number
}

variable "fargate_ingress_port" {
  description = "Ingress port for fargate"
  type        = number
}

variable "target_group_protocol" {
  description = "Target group health check protocol"
  type        = string
}

variable "repository_name" {
  description = "Name of the repository"
  type        = string
}

variable "image_tag" {
  description = "Tag of the image stored in ECR"
  type        = string
}
