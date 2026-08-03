variable "vpc_id" {
  description = "Cross module reference for VPC ID"
  type        = string
}

variable "alb_ingress_port" {
  description = "Ingress port for alb"
  type        = list(number)
}

variable "protocol" {
  description = "Transport protocol"
  type        = string
}

variable "cidr_ipv4" {
  description = "CIDR ipv4 for ingress/egress  rules"
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
