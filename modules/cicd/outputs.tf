# Pipeline ARNs
output "api_pipeline_arn" {
  description = "ARN of the API CodePipeline"
  value       = aws_codepipeline.api.arn
}

output "tenant_pipeline_arn" {
  description = "ARN of the Tenant CodePipeline"
  value       = aws_codepipeline.tenant.arn
}

output "hq_pipeline_arn" {
  description = "ARN of the HQ CodePipeline"
  value       = aws_codepipeline.hq.arn
}

# Pipeline Names
output "api_pipeline_name" {
  description = "Name of the API CodePipeline"
  value       = aws_codepipeline.api.name
}

output "tenant_pipeline_name" {
  description = "Name of the Tenant CodePipeline"
  value       = aws_codepipeline.tenant.name
}

output "hq_pipeline_name" {
  description = "Name of the HQ CodePipeline"
  value       = aws_codepipeline.hq.name
}

# GitHub Connections
output "api_github_connection_arn" {
  description = "ARN of the API GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.api.arn
}

output "tenant_github_connection_arn" {
  description = "ARN of the Tenant GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.tenant.arn
}

output "hq_github_connection_arn" {
  description = "ARN of the HQ GitHub CodeStar connection"
  value       = aws_codestarconnections_connection.hq.arn
}

output "api_github_connection_status" {
  description = "Status of the API GitHub connection (must be AVAILABLE after manual approval)"
  value       = aws_codestarconnections_connection.api.connection_status
}

output "tenant_github_connection_status" {
  description = "Status of the Tenant GitHub connection"
  value       = aws_codestarconnections_connection.tenant.connection_status
}

output "hq_github_connection_status" {
  description = "Status of the HQ GitHub connection"
  value       = aws_codestarconnections_connection.hq.connection_status
}

# Shared Resources
output "artifacts_bucket_name" {
  description = "Name of the S3 bucket for pipeline artifacts"
  value       = aws_s3_bucket.pipeline_artifacts.bucket
}

output "artifacts_bucket_arn" {
  description = "ARN of the S3 bucket for pipeline artifacts"
  value       = aws_s3_bucket.pipeline_artifacts.arn
}

# CodeBuild Projects
output "api_build_project_name" {
  description = "Name of the API CodeBuild project"
  value       = aws_codebuild_project.api.name
}

output "tenant_build_project_name" {
  description = "Name of the Tenant CodeBuild project"
  value       = aws_codebuild_project.tenant.name
}

output "hq_build_project_name" {
  description = "Name of the HQ CodeBuild project"
  value       = aws_codebuild_project.hq.name
}

output "migration_project_name" {
  description = "Name of the Migration CodeBuild project"
  value       = aws_codebuild_project.migration.name
}

# IAM Roles
output "codebuild_role_arn" {
  description = "ARN of the CodeBuild IAM role"
  value       = aws_iam_role.codebuild.arn
}

output "codepipeline_role_arn" {
  description = "ARN of the CodePipeline IAM role"
  value       = aws_iam_role.codepipeline.arn
}

output "codebuild_security_group_id" {
  description = "Security group ID for CodeBuild VPC access"
  value       = aws_security_group.codebuild.id
}
