resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

# IAM Roles
resource "aws_iam_role" "execution_role" {
  name = "${var.project_name}-${var.environment}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_policy" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "secrets_access" {
  name = "${var.project_name}-${var.environment}-ecs-secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = [
          var.db_password_arn,
          var.redis_auth_token_arn,
          var.provisioner_token_secret_arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "execution_role_secrets" {
  role       = aws_iam_role.execution_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

resource "aws_iam_role" "task_role" {
  name = "${var.project_name}-${var.environment}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_role_ssm" {
  role       = aws_iam_role.task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "task_role_eventbridge" {
  role       = aws_iam_role.task_role.name
  policy_arn = var.eventbridge_publisher_policy_arn
}

resource "aws_iam_role_policy_attachment" "task_role_s3_data" {
  role       = aws_iam_role.task_role.name
  policy_arn = var.tenant_bucket_data_access_policy_arn
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "api" {
  name              = "/ecs/${var.project_name}-${var.environment}-api"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "worker" {
  name              = "/ecs/${var.project_name}-${var.environment}-worker"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "scheduler" {
  name              = "/ecs/${var.project_name}-${var.environment}-scheduler"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "reverb" {
  name              = "/ecs/${var.project_name}-${var.environment}-reverb"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "tenant" {
  name              = "/ecs/${var.project_name}-${var.environment}-tenant"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "hq" {
  name              = "/ecs/${var.project_name}-${var.environment}-hq"
  retention_in_days = 30
}

# Task Definitions

# Laravel API
resource "aws_ecs_task_definition" "api" {
  family                   = "${var.project_name}-${var.environment}-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512  # 0.5 vCPU
  memory                   = 1024 # 1 GB
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name  = "api"
      image = "${var.api_repo_url}:${var.api_image_tag}"
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "APP_ENV", value = var.environment },
        { name = "APP_KEY", value = var.app_key },
        { name = "APP_URL", value = var.app_url },
        { name = "DB_CONNECTION", value = "mysql" },
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_PORT", value = "3306" },
        { name = "DB_DATABASE", value = var.db_name },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "REDIS_HOST", value = var.redis_host },
        { name = "REDIS_PORT", value = tostring(var.redis_port) },
        { name = "REDIS_SCHEME", value = "tls" },
        { name = "QUEUE_CONNECTION", value = "redis" },
        { name = "CORS_ALLOWED_ORIGINS", value = var.cors_allowed_origins },
        { name = "APP_DEBUG", value = var.app_debug },
        { name = "OCTANE_SERVER", value = var.octane_server },
        { name = "SANCTUM_STATEFUL_DOMAINS", value = var.sanctum_stateful_domains },
        { name = "SESSION_DOMAIN", value = var.session_domain },
        { name = "TENANT_PRIMARY_DOMAIN", value = var.tenant_primary_domain },
        { name = "SKIP_MIGRATIONS", value = "true" },
        { name = "REVERB_APP_ID", value = var.reverb_app_id },
        { name = "REVERB_APP_KEY", value = var.reverb_app_key },
        { name = "REVERB_APP_SECRET", value = var.reverb_app_secret },
        { name = "REVERB_HOST", value = "0.0.0.0" },
        { name = "REVERB_PORT", value = "8080" }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = "${var.db_password_arn}:password::" },
        { name = "REDIS_PASSWORD", valueFrom = var.redis_auth_token_arn },
        { name = "PROVISIONER_CALLBACK_TOKEN", valueFrom = "${var.provisioner_token_secret_arn}:token::" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.api.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      extraHosts = var.extra_hosts
    }
  ])
}

# Laravel Worker
resource "aws_ecs_task_definition" "worker" {
  family                   = "${var.project_name}-${var.environment}-worker"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256 # 0.25 vCPU
  memory                   = 512 # 0.5 GB
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name    = "worker"
      image   = "${var.api_repo_url}:${var.api_image_tag}"
      command = ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/worker.conf"]
      environment = [
        { name = "APP_ENV", value = var.environment },
        { name = "APP_KEY", value = var.app_key },
        { name = "APP_URL", value = var.app_url },
        { name = "DB_CONNECTION", value = "mysql" },
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_PORT", value = "3306" },
        { name = "DB_DATABASE", value = var.db_name },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "REDIS_HOST", value = var.redis_host },
        { name = "REDIS_PORT", value = tostring(var.redis_port) },
        { name = "REDIS_SCHEME", value = "tls" },
        { name = "QUEUE_CONNECTION", value = "redis" },
        { name = "AWS_EVENTBRIDGE_BUS", value = var.eventbridge_bus_name },
        { name = "CORS_ALLOWED_ORIGINS", value = var.cors_allowed_origins },
        { name = "SANCTUM_STATEFUL_DOMAINS", value = var.sanctum_stateful_domains },
        { name = "SESSION_DOMAIN", value = var.session_domain },
        { name = "TENANT_PRIMARY_DOMAIN", value = var.tenant_primary_domain },
        { name = "SKIP_MIGRATIONS", value = "true" }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = "${var.db_password_arn}:password::" },
        { name = "REDIS_PASSWORD", valueFrom = var.redis_auth_token_arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.worker.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      extraHosts = var.extra_hosts
    }
  ])
}

# Nuxt Tenant
resource "aws_ecs_task_definition" "tenant" {
  family                   = "${var.project_name}-${var.environment}-tenant"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512  # 0.5 vCPU
  memory                   = 1024 # 1 GB
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"  # x86 for CodeBuild MEDIUM compatibility
  }

  container_definitions = jsonencode([
    {
      name  = "tenant"
      image = "${var.tenant_repo_url}:${var.tenant_image_tag}"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "NUXT_PUBLIC_BASE_URL", value = var.nuxt_api_base_server },
        { name = "NUXT_API_BASE_SERVER", value = var.nuxt_api_base_server },
        { name = "NUXT_PUBLIC_API_BASE_CLIENT", value = "${var.nuxt_public_api_protocol}://${var.public_alb_dns_name}${var.nuxt_public_api_port}/api/v1" },
        { name = "NODE_TLS_REJECT_UNAUTHORIZED", value = var.node_tls_reject_unauthorized },
        { name = "NUXT_PUBLIC_TENANT_PRIMARY_DOMAIN", value = var.tenant_primary_domain },
        { name = "NUXT_PUBLIC_REVERB_APP_KEY", value = var.reverb_app_key },
        { name = "NUXT_PUBLIC_REVERB_HOST", value = var.reverb_public_host },
        { name = "NUXT_PUBLIC_REVERB_PORT", value = "443" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.tenant.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      extraHosts = var.extra_hosts
    }
  ])
}

# Nuxt HQ
resource "aws_ecs_task_definition" "hq" {
  family                   = "${var.project_name}-${var.environment}-hq"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512  # 0.5 vCPU
  memory                   = 1024 # 1 GB
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"  # x86 for CodeBuild MEDIUM compatibility
  }

  container_definitions = jsonencode([
    {
      name  = "hq"
      image = "${var.hq_repo_url}:${var.hq_image_tag}"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "NUXT_PUBLIC_APP_ENV", value = var.environment },
        { name = "NUXT_PUBLIC_BASE_URL", value = "http://${var.internal_alb_dns_name}" },
        { name = "NUXT_API_BASE_SERVER", value = "http://${var.internal_alb_dns_name}" },
        { name = "NUXT_PUBLIC_API_BASE_CLIENT", value = "${var.nuxt_public_api_protocol}://${var.public_alb_dns_name}${var.nuxt_public_api_port}/api/v1" },
        { name = "NODE_TLS_REJECT_UNAUTHORIZED", value = var.node_tls_reject_unauthorized },
        { name = "NUXT_PUBLIC_TENANT_PRIMARY_DOMAIN", value = var.tenant_primary_domain },
        { name = "NUXT_PUBLIC_REVERB_APP_KEY", value = var.reverb_app_key },
        { name = "NUXT_PUBLIC_REVERB_HOST", value = var.reverb_public_host },
        { name = "NUXT_PUBLIC_REVERB_PORT", value = "443" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.hq.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Laravel Scheduler
resource "aws_ecs_task_definition" "scheduler" {
  family                   = "${var.project_name}-${var.environment}-scheduler"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256 # 0.25 vCPU
  memory                   = 512 # 0.5 GB
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name    = "scheduler"
      image   = "${var.api_repo_url}:${var.api_image_tag}"
      command = ["php", "artisan", "schedule:work"]
      environment = [
        { name = "APP_ENV", value = var.environment },
        { name = "APP_KEY", value = var.app_key },
        { name = "APP_URL", value = var.app_url },
        { name = "DB_CONNECTION", value = "mysql" },
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_PORT", value = "3306" },
        { name = "DB_DATABASE", value = var.db_name },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "REDIS_HOST", value = var.redis_host },
        { name = "REDIS_PORT", value = tostring(var.redis_port) },
        { name = "REDIS_SCHEME", value = "tls" },
        { name = "QUEUE_CONNECTION", value = "redis" },
        { name = "SANCTUM_STATEFUL_DOMAINS", value = var.sanctum_stateful_domains },
        { name = "SESSION_DOMAIN", value = var.session_domain },
        { name = "TENANT_PRIMARY_DOMAIN", value = var.tenant_primary_domain },
        { name = "SKIP_MIGRATIONS", value = "true" }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = "${var.db_password_arn}:password::" },
        { name = "REDIS_PASSWORD", valueFrom = var.redis_auth_token_arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.scheduler.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# Laravel Reverb (WebSocket)
resource "aws_ecs_task_definition" "reverb" {
  family                   = "${var.project_name}-${var.environment}-reverb"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256 # 0.25 vCPU
  memory                   = 512 # 0.5 GB
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name    = "reverb"
      image   = "${var.api_repo_url}:${var.api_image_tag}"
      command = ["php", "artisan", "reverb:start", "--host=0.0.0.0", "--port=8080"]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "APP_ENV", value = var.environment },
        { name = "APP_KEY", value = var.app_key },
        { name = "APP_URL", value = var.app_url },
        { name = "DB_CONNECTION", value = "mysql" },
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_PORT", value = "3306" },
        { name = "DB_DATABASE", value = var.db_name },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "REDIS_HOST", value = var.redis_host },
        { name = "REDIS_PORT", value = tostring(var.redis_port) },
        { name = "REDIS_SCHEME", value = "tls" },
        { name = "QUEUE_CONNECTION", value = "redis" },
        { name = "REVERB_APP_ID", value = var.reverb_app_id },
        { name = "REVERB_APP_KEY", value = var.reverb_app_key },
        { name = "REVERB_APP_SECRET", value = var.reverb_app_secret },
        { name = "REVERB_HOST", value = "0.0.0.0" },
        { name = "REVERB_PORT", value = "8080" }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = "${var.db_password_arn}:password::" },
        { name = "REDIS_PASSWORD", valueFrom = var.redis_auth_token_arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.reverb.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}
