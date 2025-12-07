variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "region" {
  type = string
}

variable "availability_zones" {
  description = "Optional list of AZ names to use; defaults to first two available"
  type        = list(string)
  default     = []
}
