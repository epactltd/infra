resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-cache-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-cache-subnet-group"
  }
}

resource "random_password" "auth_token" {
  length           = 32
  special          = false # Redis auth token doesn't like some special chars sometimes, safer to be alphanumeric
}

resource "aws_secretsmanager_secret" "redis_auth" {
  name                    = "/${var.project_name}/${var.environment}/redis_auth_token"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-redis-auth-token"
  }
}

resource "aws_secretsmanager_secret_version" "redis_auth" {
  secret_id     = aws_secretsmanager_secret.redis_auth.id
  secret_string = random_password.auth_token.result
}

resource "aws_secretsmanager_secret_rotation" "redis_auth" {
  count             = var.rotation_lambda_arn == "" ? 0 : 1
  secret_id         = aws_secretsmanager_secret.redis_auth.id
  rotation_lambda_arn = var.rotation_lambda_arn
  rotation_rules {
    automatically_after_days = 30
  }
}

resource "aws_elasticache_replication_group" "main" {
  replication_group_id = "${var.project_name}-${var.environment}-redis"
  description          = "Redis replication group for ${var.project_name}"
  node_type            = "cache.t4g.micro"
  port                 = 6379
  parameter_group_name = "default.redis7"
  
  subnet_group_name    = aws_elasticache_subnet_group.main.name
  security_group_ids   = [var.security_group_id]

  automatic_failover_enabled = true
  multi_az_enabled           = true
  num_cache_clusters         = 2

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = aws_secretsmanager_secret_version.redis_auth.secret_string
  auth_token_update_strategy = var.rotation_lambda_arn == "" ? "SET" : "ROTATE"

  tags = {
    Name = "${var.project_name}-${var.environment}-redis"
  }
}
