resource "aws_lb" "alb" {
  name               = "alb-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Environment = "alb-ecs"
  }
}

resource "aws_lb_target_group" "ecs" {
  name                 = "tg-ecs-tasks"
  port                 = var.container_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    enabled             = true
    healthy_threshold   = 3
    path                = "/health"
    interval            = 30
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = 200
    port                = "traffic-port"
  }

  tags = {
    Name = "tg-ecs-tasks"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }
}

resource "aws_route53_record" "ecs" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}