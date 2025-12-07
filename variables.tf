variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "envelope"
}

variable "environment" {
  description = "Environment (e.g., dev, prod)"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = string
  default     = "*"

  validation {
    condition     = !can(regex("\\*", var.cors_allowed_origins))
    error_message = "cors_allowed_origins must not be wildcard."
  }
}

variable "app_debug" {
  description = "Enable app debug mode"
  type        = string
  default     = "false"
}

variable "octane_server" {
  description = "Laravel Octane server"
  type        = string
  default     = "swoole"
}

variable "sanctum_stateful_domains" {
  description = "Sanctum stateful domains"
  type        = string
  default     = "localhost"
}

variable "session_domain" {
  description = "Session domain"
  type        = string
  default     = ".localhost"
}

variable "nuxt_public_api_protocol" {
  description = "Protocol for Nuxt public API client"
  type        = string
  default     = "https"
}

variable "nuxt_public_api_port" {
  description = "Port for Nuxt public API client"
  type        = string
  default     = ""
}

variable "extra_hosts" {
  description = "List of extra hosts to add to /etc/hosts"
  type        = list(object({
    hostname  = string
    ipAddress = string
  }))
  default = []
}

variable "nuxt_api_base_server" {
  description = "Base URL for Nuxt API server (internal)"
  type        = string
  default     = ""
}

variable "app_key" {
  description = "Laravel App Key"
  type        = string
  sensitive   = true
}

variable "node_tls_reject_unauthorized" {
  description = "Set to 0 to allow self-signed certificates (dev only). Default is 1 (secure)."
  type        = string
  default     = "1"
}

variable "availability_zones" {
  description = "Optional list of AZs to target (defaults to first two in region)"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the public ALB."
  type        = string

  validation {
    condition     = length(var.acm_certificate_arn) > 0
    error_message = "Provide a real ACM certificate ARN."
  }
}

variable "alb_access_logs_bucket" {
  description = "S3 bucket name for ALB access logs (optional)."
  type        = string
  default     = ""

  validation {
    condition     = length(var.alb_access_logs_bucket) > 0
    error_message = "Provide an ALB access log bucket."
  }
}

variable "alb_web_acl_arn" {
  description = "WAFv2 Web ACL ARN to associate with the public ALB (optional)."
  type        = string
  default     = ""

  validation {
    condition     = length(var.alb_web_acl_arn) > 0
    error_message = "Provide a WAF web ACL ARN."
  }
}

variable "enable_alb_deletion_protection" {
  description = "Enable deletion protection on ALBs"
  type        = bool
  default     = true
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

variable "manage_db_password" {
  description = "Let RDS manage and rotate the master password in Secrets Manager"
  type        = bool
  default     = true
}

variable "db_password" {
  description = "Explicit DB password when manage_db_password is false"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_password_secret_arn_override" {
  description = "Secret ARN to expose when manage_db_password is false"
  type        = string
  default     = ""
}

variable "backup_retention_period" {
  description = "Days to retain RDS backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "RDS backup window"
  type        = string
  default     = "02:00-03:00"
}

variable "preferred_maintenance_window" {
  description = "RDS maintenance window"
  type        = string
  default     = "Sun:03:00-Sun:04:00"
}

variable "rds_deletion_protection" {
  description = "Protect RDS from deletion"
  type        = bool
  default     = true
}

variable "rds_max_allocated_storage" {
  description = "Maximum storage for autoscaling"
  type        = number
  default     = 200
}

variable "api_image_tag" {
  description = "Container tag for API/worker/scheduler"
  type        = string
  default     = "latest"
}

variable "tenant_image_tag" {
  description = "Container tag for tenant app"
  type        = string
  default     = "latest"
}

variable "hq_image_tag" {
  description = "Container tag for HQ app"
  type        = string
  default     = "latest"
}

variable "hq_host" {
  description = "Host header value for HQ application routing"
  type        = string
}
