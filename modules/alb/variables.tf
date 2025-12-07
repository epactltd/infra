variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_alb_sg_id" {
  type = string
}

variable "internal_alb_sg_id" {
  type = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the public ALB"
  type        = string
  default     = ""
}

variable "access_logs_bucket" {
  description = "Bucket to write ALB access logs to (optional)"
  type        = string
  default     = ""
}

variable "web_acl_arn" {
  description = "WAFv2 Web ACL ARN to associate with the public ALB (optional)"
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on the ALBs"
  type        = bool
  default     = true
}

variable "hq_host" {
  description = "Host header value for HQ application routing"
  type        = string
}
