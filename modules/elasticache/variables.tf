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

variable "rotation_lambda_arn" {
  description = "Lambda ARN that rotates the Redis auth token (optional)"
  type        = string
  default     = ""
}
