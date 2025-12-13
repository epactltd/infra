variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., prod, staging)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for CodeBuild projects that need VPC access"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for CodeBuild VPC configuration"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting pipeline artifacts"
  type        = string
}

# GitHub Configuration - Separate repositories
variable "api_github_repository" {
  description = "GitHub repository for API in format owner/repo"
  type        = string
}

variable "tenant_github_repository" {
  description = "GitHub repository for Tenant in format owner/repo"
  type        = string
}

variable "hq_github_repository" {
  description = "GitHub repository for HQ in format owner/repo"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch to monitor for releases"
  type        = string
  default     = "main"
}

# ECR Repository Names
variable "api_repo_name" {
  description = "ECR repository name for API"
  type        = string
}

variable "tenant_repo_name" {
  description = "ECR repository name for Tenant"
  type        = string
}

variable "hq_repo_name" {
  description = "ECR repository name for HQ"
  type        = string
}

# Database Configuration (for migrations - API only)
variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password_secret_arn" {
  description = "Secrets Manager ARN for database password"
  type        = string
}

variable "app_key_secret_arn" {
  description = "Secrets Manager ARN for Laravel APP_KEY"
  type        = string
}

# ECS Configuration
variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "api_service_name" {
  description = "ECS service name for API"
  type        = string
}

variable "tenant_service_name" {
  description = "ECS service name for Tenant"
  type        = string
}

variable "hq_service_name" {
  description = "ECS service name for HQ"
  type        = string
}

variable "worker_service_name" {
  description = "ECS service name for Worker"
  type        = string
}

variable "scheduler_service_name" {
  description = "ECS service name for Scheduler"
  type        = string
}

variable "reverb_service_name" {
  description = "ECS service name for Reverb"
  type        = string
}

# Approval Configuration
variable "require_manual_approval" {
  description = "Whether to require manual approval before deployment"
  type        = bool
  default     = true
}

variable "approval_sns_topic_arn" {
  description = "SNS topic ARN for approval notifications"
  type        = string
  default     = ""
}
