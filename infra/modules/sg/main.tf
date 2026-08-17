resource "aws_security_group" "alb" {
  name        = "alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_1" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = var.cidr_ipv4
  from_port   = var.alb_ingress_port[0]
  ip_protocol = var.protocol
  to_port     = var.alb_ingress_port[0]
}

resource "aws_vpc_security_group_ingress_rule" "alb_2" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = var.cidr_ipv4
  from_port   = var.alb_ingress_port[1]
  ip_protocol = var.protocol
  to_port     = var.alb_ingress_port[1]
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.tasks.id

  from_port   = var.container_port
  ip_protocol = var.protocol
  to_port     = var.container_port
}

resource "aws_security_group" "tasks" {
  name        = "ecs-tasks-sg"
  description = "Security group for ECS Tasks"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-tasks-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tasks" {
  security_group_id = aws_security_group.tasks.id

  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.container_port
  ip_protocol                  = var.protocol
  to_port                      = var.container_port
}

resource "aws_vpc_security_group_egress_rule" "tasks" {
  security_group_id = aws_security_group.tasks.id

  cidr_ipv4   = var.cidr_ipv4
  from_port   = var.tasks_egress_port
  ip_protocol = var.protocol
  to_port     = var.tasks_egress_port
}

resource "aws_security_group" "fargate" {
  name        = "ecs-fargate-sg"
  description = "Security group for ECS Fargate"
  vpc_id      = var.vpc_id

  tags = {
    Name = "ecs-fargate-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "fargate" {
  security_group_id = aws_security_group.fargate.id

  referenced_security_group_id = aws_security_group.tasks.id
  from_port                    = var.fargate_ingress_port
  ip_protocol                  = var.protocol
  to_port                      = var.fargate_ingress_port
}