resource "aws_ecs_cluster" "ecs" {
  name = "ecs-cluster"

  tags = {
    Name = "ecs-cluster"
  }
}

resource "aws_ecs_task_definition" "ecs" {
  family                   = "ecs-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "ecs-task-definition"
      image = "${var.repository_url}:${var.image_tag}"
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = var.protocol
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-create-group"  = "true"
          "awslogs-group"         = "/ecs/ecs-task-definition"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "ecs-task-definition"
  }
}

resource "aws_ecs_service" "ecs" {
  name                          = "ecs-task-definition-service"
  cluster                       = aws_ecs_cluster.ecs.id
  task_definition               = aws_ecs_task_definition.ecs.arn
  launch_type                   = "FARGATE"
  desired_count                 = 2
  availability_zone_rebalancing = "ENABLED"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "ecs-task-definition"
    container_port   = var.container_port
  }

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.ecs_tasks_sg_id]
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  tags = {
    Name = "ecs-task-definition-service"
  }
}

resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.ecs.name}/${aws_ecs_service.ecs.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs" {
  name               = "ecs-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 75
    scale_in_cooldown  = 180
    scale_out_cooldown = 120
  }
}