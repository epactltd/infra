resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-${var.environment}-db"
  engine            = "mariadb"
  engine_version    = "10.11"
  instance_class    = "db.t4g.small"
  allocated_storage = 20
  storage_type      = "gp3"

  username                    = var.db_username
  db_name                     = var.db_name
  manage_master_user_password = var.manage_master_user_password
  password                    = var.manage_master_user_password ? null : coalesce(var.db_password, random_password.fallback[0].result)
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.preferred_backup_window
  maintenance_window          = var.preferred_maintenance_window
  deletion_protection         = var.deletion_protection
  copy_tags_to_snapshot       = true
  max_allocated_storage       = var.max_allocated_storage
  auto_minor_version_upgrade  = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  multi_az            = true
  storage_encrypted   = true
  skip_final_snapshot = false

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}

resource "random_password" "fallback" {
  count            = var.manage_master_user_password ? 0 : 1
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_password" {
  count                   = var.manage_master_user_password ? 0 : 1
  name                    = "/${var.project_name}/${var.environment}/db_password"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-${var.environment}-db-password"
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  count         = var.manage_master_user_password ? 0 : 1
  secret_id     = aws_secretsmanager_secret.db_password[0].id
  secret_string = coalesce(var.db_password, random_password.fallback[0].result)
}
