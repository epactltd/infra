resource "aws_ecs_service" "tenant" {
  name            = "${var.project_name}-${var.environment}-tenant"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.tenant.arn
  desired_count   = 2
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 100
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.nuxt_sg_id]
  }

  load_balancer {
    target_group_arn = var.tenant_tg_arn
    container_name   = "tenant"
    container_port   = 3000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  health_check_grace_period_seconds = 60
}

resource "aws_ecs_service" "hq" {
  name            = "${var.project_name}-${var.environment}-hq"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.hq.arn
  desired_count   = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.nuxt_sg_id]
  }

  load_balancer {
    target_group_arn = var.hq_tg_arn
    container_name   = "hq"
    container_port   = 3000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  health_check_grace_period_seconds = 60
}

resource "aws_ecs_service" "api" {
  name            = "${var.project_name}-${var.environment}-api"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api.arn
  desired_count   = 2
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 100
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.laravel_sg_id]
  }

  load_balancer {
    target_group_arn = var.api_tg_arn
    container_name   = "api"
    container_port   = 8000
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  health_check_grace_period_seconds = 60
}

resource "aws_ecs_service" "worker" {
  name            = "${var.project_name}-${var.environment}-worker"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.worker.arn
  desired_count   = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.laravel_sg_id]
  }
}

resource "aws_ecs_service" "scheduler" {
  name            = "${var.project_name}-${var.environment}-scheduler"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.scheduler.arn
  desired_count   = 1
  enable_execute_command = true

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    base              = 1
    weight            = 1
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.laravel_sg_id]
  }
}

# Auto Scaling (Simple example for Tenant and API)
resource "aws_appautoscaling_target" "tenant" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.tenant.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "tenant_cpu" {
  name               = "tenant-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.tenant.resource_id
  scalable_dimension = aws_appautoscaling_target.tenant.scalable_dimension
  service_namespace  = aws_appautoscaling_target.tenant.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_appautoscaling_target" "api" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "api_cpu" {
  name               = "api-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.api.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

# Scheduled scaling to lower capacity off-hours (times in UTC; aligns to 20:00-06:00 UK roughly)
resource "aws_appautoscaling_scheduled_action" "tenant_off_hours" {
  scheduled_action_name = "tenant-off-hours"
  service_namespace     = aws_appautoscaling_target.tenant.service_namespace
  resource_id           = aws_appautoscaling_target.tenant.resource_id
  scalable_dimension    = aws_appautoscaling_target.tenant.scalable_dimension
  schedule              = "cron(0 20 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = 1
    max_capacity = 4
  }
}

resource "aws_appautoscaling_scheduled_action" "tenant_business_hours" {
  scheduled_action_name = "tenant-business-hours"
  service_namespace     = aws_appautoscaling_target.tenant.service_namespace
  resource_id           = aws_appautoscaling_target.tenant.resource_id
  scalable_dimension    = aws_appautoscaling_target.tenant.scalable_dimension
  schedule              = "cron(0 6 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = 2
    max_capacity = 10
  }
}

resource "aws_appautoscaling_scheduled_action" "api_off_hours" {
  scheduled_action_name = "api-off-hours"
  service_namespace     = aws_appautoscaling_target.api.service_namespace
  resource_id           = aws_appautoscaling_target.api.resource_id
  scalable_dimension    = aws_appautoscaling_target.api.scalable_dimension
  schedule              = "cron(0 20 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = 1
    max_capacity = 4
  }
}

resource "aws_appautoscaling_scheduled_action" "api_business_hours" {
  scheduled_action_name = "api-business-hours"
  service_namespace     = aws_appautoscaling_target.api.service_namespace
  resource_id           = aws_appautoscaling_target.api.resource_id
  scalable_dimension    = aws_appautoscaling_target.api.scalable_dimension
  schedule              = "cron(0 6 ? * MON-FRI *)"

  scalable_target_action {
    min_capacity = 2
    max_capacity = 10
  }
}

# Worker autoscaling (keeps min 1, scales on CPU)
resource "aws_appautoscaling_target" "worker" {
  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.worker.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "worker_cpu" {
  name               = "worker-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.worker.resource_id
  scalable_dimension = aws_appautoscaling_target.worker.scalable_dimension
  service_namespace  = aws_appautoscaling_target.worker.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
