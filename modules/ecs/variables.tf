variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "api_repo_url" {
  type = string
}

variable "api_image_tag" {
  type = string
}

variable "tenant_image_tag" {
  type = string
}

variable "hq_image_tag" {
  type = string
}



variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = string
}

variable "app_debug" {
  type = string
}

variable "octane_server" {
  type = string
}

variable "sanctum_stateful_domains" {
  type = string
}

variable "session_domain" {
  type = string
}

variable "nuxt_public_api_protocol" {
  type = string
}

variable "nuxt_public_api_port" {
  type = string
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
  type    = string
  default = ""
}

variable "app_key" {
  description = "The application key for Laravel"
  type        = string
  sensitive   = true
}

variable "node_tls_reject_unauthorized" {
  description = "Set to 0 to allow self-signed certificates (dev only). Default is 1 (secure)."
  type        = string
  default     = "1"
}

variable "tenant_repo_url" {
  type = string
}

variable "hq_repo_url" {
  type = string
}

variable "db_host" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password_arn" {
  type = string
}

variable "redis_host" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "redis_auth_token_arn" {
  type = string
}

variable "internal_alb_dns_name" {
  type = string
}

variable "public_alb_dns_name" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "nuxt_sg_id" {
  type = string
}

variable "laravel_sg_id" {
  type = string
}

variable "tenant_tg_arn" {
  type = string
}

variable "hq_tg_arn" {
  type = string
}

variable "api_tg_arn" {
  type = string
}

variable "tenant_bucket_provisioner_policy_arn" {
  description = "IAM policy ARN that allows the HQ app to provision per-tenant buckets"
  type        = string
}
