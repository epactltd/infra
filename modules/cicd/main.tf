# CI/CD Infrastructure - AWS CodePipeline + CodeBuild
# Separate pipelines for API, Tenant, and HQ repositories
# Triggered by GitHub Release only

# -----------------------------------------------------------------------------
# CodeStar Connections for GitHub (one per repository)
# -----------------------------------------------------------------------------
resource "aws_codestarconnections_connection" "api" {
  name          = "${var.project_name}-${var.environment}-github-api"
  provider_type = "GitHub"

  tags = {
    Name = "${var.project_name}-${var.environment}-github-api"
  }
}

resource "aws_codestarconnections_connection" "tenant" {
  name          = "${var.project_name}-${var.environment}-github-tenant"
  provider_type = "GitHub"

  tags = {
    Name = "${var.project_name}-${var.environment}-github-tenant"
  }
}

resource "aws_codestarconnections_connection" "hq" {
  name          = "${var.project_name}-${var.environment}-github-hq"
  provider_type = "GitHub"

  tags = {
    Name = "${var.project_name}-${var.environment}-github-hq"
  }
}

# -----------------------------------------------------------------------------
# S3 Bucket for Pipeline Artifacts (shared)
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "${var.project_name}-${var.environment}-pipeline-artifacts"

  tags = {
    Name = "${var.project_name}-${var.environment}-pipeline-artifacts"
  }
}

resource "aws_s3_bucket_versioning" "pipeline_artifacts" {
  bucket = aws_s3_bucket.pipeline_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_artifacts" {
  bucket = aws_s3_bucket.pipeline_artifacts.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_key_arn
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline_artifacts" {
  bucket = aws_s3_bucket.pipeline_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------------------------------------------------------
# CloudWatch Log Groups for CodeBuild
# -----------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "api_build" {
  name              = "/codebuild/${var.project_name}-${var.environment}-api-build"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "tenant_build" {
  name              = "/codebuild/${var.project_name}-${var.environment}-tenant-build"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "hq_build" {
  name              = "/codebuild/${var.project_name}-${var.environment}-hq-build"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "migration" {
  name              = "/codebuild/${var.project_name}-${var.environment}-migration"
  retention_in_days = 30
}

# -----------------------------------------------------------------------------
# CodeBuild Projects
# -----------------------------------------------------------------------------

# API Build Project
resource "aws_codebuild_project" "api" {
  name          = "${var.project_name}-${var.environment}-api-build"
  description   = "Build Laravel API Docker image"
  build_timeout = 30
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-aarch64-standard:3.0"
    type                        = "ARM_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REGISTRY"
      value = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
    }

    environment_variable {
      name  = "REPO_NAME"
      value = var.api_repo_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.api_build.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-api-build"
  }
}

# Tenant Build Project
resource "aws_codebuild_project" "tenant" {
  name          = "${var.project_name}-${var.environment}-tenant-build"
  description   = "Build Nuxt Tenant Docker image"
  build_timeout = 30
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REGISTRY"
      value = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
    }

    environment_variable {
      name  = "REPO_NAME"
      value = var.tenant_repo_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.tenant_build.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tenant-build"
  }
}

# HQ Build Project
resource "aws_codebuild_project" "hq" {
  name          = "${var.project_name}-${var.environment}-hq-build"
  description   = "Build Nuxt HQ Docker image"
  build_timeout = 30
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_MEDIUM"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REGISTRY"
      value = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
    }

    environment_variable {
      name  = "REPO_NAME"
      value = var.hq_repo_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.hq_build.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-hq-build"
  }
}

# Migration Project - Runs database migrations before API deployment
resource "aws_codebuild_project" "migration" {
  name          = "${var.project_name}-${var.environment}-migration"
  description   = "Run Laravel database migrations"
  build_timeout = 15
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id             = var.vpc_id
    subnets            = var.private_subnet_ids
    security_group_ids = [aws_security_group.codebuild.id]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-aarch64-standard:3.0"
    type                        = "ARM_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REGISTRY"
      value = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com"
    }

    environment_variable {
      name  = "REPO_NAME"
      value = var.api_repo_name
    }

    environment_variable {
      name  = "DB_HOST"
      value = var.db_host
    }

    environment_variable {
      name  = "DB_DATABASE"
      value = var.db_name
    }

    environment_variable {
      name  = "DB_USERNAME"
      value = var.db_username
    }

    environment_variable {
      name  = "DB_PASSWORD"
      value = var.db_password_secret_arn
      type  = "SECRETS_MANAGER"
    }

    environment_variable {
      name  = "APP_KEY"
      value = var.app_key_secret_arn
      type  = "SECRETS_MANAGER"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.migration.name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec-migrate.yml"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-migration"
  }
}

# =============================================================================
# API PIPELINE (with migrations)
# =============================================================================
resource "aws_codepipeline" "api" {
  name     = "${var.project_name}-${var.environment}-api-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"

    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  # Stage 1: Source
  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.api.arn
        FullRepositoryId     = var.api_github_repository
        BranchName           = var.github_branch
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }
  }

  # Stage 2: Build
  stage {
    name = "Build"

    action {
      name             = "Build_API"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.api.name
      }
    }
  }

  # Stage 3: Manual Approval (Production only)
  dynamic "stage" {
    for_each = var.require_manual_approval ? [1] : []
    content {
      name = "Approval"

      action {
        name     = "Manual_Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          NotificationArn = var.approval_sns_topic_arn
          CustomData      = "Please review and approve the API deployment to ${var.environment}"
        }
      }
    }
  }

  # Stage 4: Migrate - Run database migrations
  stage {
    name = "Migrate"

    action {
      name            = "Run_Migrations"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source_output"]
      run_order       = 1

      configuration = {
        ProjectName = aws_codebuild_project.migration.name
      }
    }
  }

  # Stage 5: Deploy - Update ECS services
  stage {
    name = "Deploy"

    action {
      name            = "Deploy_API"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.api_service_name
        FileName    = "imagedefinitions-api.json"
      }
    }

    action {
      name            = "Deploy_Worker"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.worker_service_name
        FileName    = "imagedefinitions-worker.json"
      }
    }

    action {
      name            = "Deploy_Scheduler"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.scheduler_service_name
        FileName    = "imagedefinitions-scheduler.json"
      }
    }

    action {
      name            = "Deploy_Reverb"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.reverb_service_name
        FileName    = "imagedefinitions-reverb.json"
      }
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-api-pipeline"
  }
}

# =============================================================================
# TENANT PIPELINE (no migrations)
# =============================================================================
resource "aws_codepipeline" "tenant" {
  name     = "${var.project_name}-${var.environment}-tenant-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"

    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  # Stage 1: Source
  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.tenant.arn
        FullRepositoryId     = var.tenant_github_repository
        BranchName           = var.github_branch
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }
  }

  # Stage 2: Build
  stage {
    name = "Build"

    action {
      name             = "Build_Tenant"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.tenant.name
      }
    }
  }

  # Stage 3: Manual Approval (Production only)
  dynamic "stage" {
    for_each = var.require_manual_approval ? [1] : []
    content {
      name = "Approval"

      action {
        name     = "Manual_Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          NotificationArn = var.approval_sns_topic_arn
          CustomData      = "Please review and approve the Tenant deployment to ${var.environment}"
        }
      }
    }
  }

  # Stage 4: Deploy
  stage {
    name = "Deploy"

    action {
      name            = "Deploy_Tenant"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.tenant_service_name
        FileName    = "imagedefinitions.json"
      }
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tenant-pipeline"
  }
}

# =============================================================================
# HQ PIPELINE (no migrations)
# =============================================================================
resource "aws_codepipeline" "hq" {
  name     = "${var.project_name}-${var.environment}-hq-pipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"

    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  # Stage 1: Source
  stage {
    name = "Source"

    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn        = aws_codestarconnections_connection.hq.arn
        FullRepositoryId     = var.hq_github_repository
        BranchName           = var.github_branch
        OutputArtifactFormat = "CODEBUILD_CLONE_REF"
        DetectChanges        = false
      }
    }
  }

  # Stage 2: Build
  stage {
    name = "Build"

    action {
      name             = "Build_HQ"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.hq.name
      }
    }
  }

  # Stage 3: Manual Approval (Production only)
  dynamic "stage" {
    for_each = var.require_manual_approval ? [1] : []
    content {
      name = "Approval"

      action {
        name     = "Manual_Approval"
        category = "Approval"
        owner    = "AWS"
        provider = "Manual"
        version  = "1"

        configuration = {
          NotificationArn = var.approval_sns_topic_arn
          CustomData      = "Please review and approve the HQ deployment to ${var.environment}"
        }
      }
    }
  }

  # Stage 4: Deploy
  stage {
    name = "Deploy"

    action {
      name            = "Deploy_HQ"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]
      run_order       = 1

      configuration = {
        ClusterName = var.ecs_cluster_name
        ServiceName = var.hq_service_name
        FileName    = "imagedefinitions.json"
      }
    }
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-hq-pipeline"
  }
}
