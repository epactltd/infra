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
  description = "Allowed origins for CORS (e.g., https://*.envelope.host,https://admin.envelope.host)"
  type        = string
  default     = "*"

  validation {
    condition     = var.cors_allowed_origins != "*"
    error_message = "cors_allowed_origins must not be a standalone wildcard '*'. Use specific domains like 'https://*.envelope.host'."
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
  type = list(object({
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
  description = "S3 bucket name for ALB access logs (optional, leave empty to disable)."
  type        = string
  default     = ""
}

variable "alb_web_acl_arn" {
  description = "WAFv2 Web ACL ARN to associate with the public ALB (optional, leave empty to disable)."
  type        = string
  default     = ""
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

variable "api_host" {
  description = "Host header value for API routing (e.g., api.envelope.host)"
  type        = string
}

# Reverb / WebSocket Configuration
variable "reverb_host" {
  description = "Host header value for Reverb WebSocket routing (e.g., wss.envelope.host)"
  type        = string
}

variable "reverb_app_id" {
  description = "Reverb application ID"
  type        = string
}

variable "reverb_app_key" {
  description = "Reverb application key"
  type        = string
}

variable "reverb_app_secret" {
  description = "Reverb application secret"
  type        = string
  sensitive   = true
}

variable "reverb_public_host" {
  description = "Public host for Reverb WebSocket connections (e.g., wss.envelope.host)"
  type        = string
}

# Application Configuration
variable "app_url" {
  description = "The application URL for Laravel (e.g., https://api.envelope.host)"
  type        = string
}

variable "tenant_primary_domain" {
  description = "Primary domain for tenants (e.g., envelope.host for *.envelope.host)"
  type        = string
}

# -----------------------------------------------------------------------------
# CI/CD Configuration (Separate pipelines per repository)
# -----------------------------------------------------------------------------

variable "enable_cicd" {
  description = "Enable CI/CD infrastructure (CodePipeline + CodeBuild)"
  type        = bool
  default     = false
}

variable "api_github_repository" {
  description = "GitHub repository for API in format owner/repo (e.g., my-org/envelope-api)"
  type        = string
  default     = ""
}

variable "tenant_github_repository" {
  description = "GitHub repository for Tenant in format owner/repo (e.g., my-org/envelope-tenant)"
  type        = string
  default     = ""
}

variable "hq_github_repository" {
  description = "GitHub repository for HQ in format owner/repo (e.g., my-org/envelope-hq)"
  type        = string
  default     = ""
}

variable "github_branch" {
  description = "GitHub branch to monitor for releases"
  type        = string
  default     = "main"
}

variable "cicd_kms_key_arn" {
  description = "KMS key ARN for encrypting CI/CD artifacts"
  type        = string
  default     = ""
}

variable "app_key_secret_arn" {
  description = "Secrets Manager ARN for Laravel APP_KEY (used for API migrations)"
  type        = string
  default     = ""
}

variable "cicd_require_manual_approval" {
  description = "Require manual approval before deployment (recommended for production)"
  type        = bool
  default     = true
}

variable "cicd_approval_sns_topic_arn" {
  description = "SNS topic ARN for deployment approval notifications"
  type        = string
  default     = ""
}

# ============================================================================
# Tenant Provisioning (EventBridge + Lambda)
# ============================================================================

variable "provisioner_callback_token" {
  description = "Secret token for provisioner Lambda to authenticate with API"
  type        = string
  sensitive   = true
}
