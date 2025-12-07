output "db_endpoint" {
  value = aws_db_instance.main.endpoint
}

output "db_name" {
  value = aws_db_instance.main.db_name
}

output "db_username" {
  value = aws_db_instance.main.username
}

output "db_password_secret_arn" {
  value = var.manage_master_user_password && length(aws_db_instance.main.master_user_secret) > 0 ? aws_db_instance.main.master_user_secret[0].secret_arn : (
    var.db_password_secret_arn_override != "" ? var.db_password_secret_arn_override : aws_secretsmanager_secret.db_password[0].arn
  )
}
