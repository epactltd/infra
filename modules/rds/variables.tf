variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "envelope"
}

variable "manage_master_user_password" {
  description = "Let RDS store and rotate the password in Secrets Manager"
  type        = bool
  default     = true
}

variable "db_password" {
  description = "Explicit password to use when manage_master_user_password is false (e.g. LocalStack)"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_password_secret_arn_override" {
  description = "Optional secret ARN to expose when manage_master_user_password is false"
  type        = string
  default     = ""
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "Sun:03:00-Sun:04:00"
}

variable "deletion_protection" {
  description = "Protect the database from accidental deletion"
  type        = bool
  default     = true
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling"
  type        = number
  default     = 200
}
