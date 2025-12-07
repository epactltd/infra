variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tenant_bucket_prefix_override" {
  description = "Override prefix for tenant buckets (default: <project>-<env>-tenant-)"
  type        = string
  default     = ""
}
