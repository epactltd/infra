output "api_repo_url" {
  value = aws_ecr_repository.api.repository_url
}

output "tenant_repo_url" {
  value = aws_ecr_repository.tenant.repository_url
}

output "hq_repo_url" {
  value = aws_ecr_repository.hq.repository_url
}
