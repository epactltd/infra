variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

variable "environment" {
  type        = string
  description = "Environment (prod, staging, dev)"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "api_callback_url" {
  type        = string
  description = "API endpoint URL for Lambda to update tenant configs"
}

variable "api_callback_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret containing the API callback token"
}

variable "tenant_bucket_prefix" {
  type        = string
  description = "Prefix for tenant S3 buckets"
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

