# CI/CD Setup Guide

This document describes how to set up the AWS CodePipeline CI/CD infrastructure for the Envelope application.

## Architecture Overview

The CI/CD system uses **separate pipelines** for each repository:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           API Pipeline (with migrations)                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  GitHub Release → Build → Approval → Migrate → Deploy (API, Worker,        │
│  (api repo)                                     Scheduler, Reverb)          │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           Tenant Pipeline                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│  GitHub Release → Build → Approval → Deploy (Tenant)                        │
│  (tenant repo)                                                               │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                           HQ Pipeline                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│  GitHub Release → Build → Approval → Deploy (HQ)                            │
│  (hq repo)                                                                   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Key Design Decisions

1. **Separate repositories**: Each service (API, Tenant, HQ) has its own repository and pipeline
2. **Release-triggered only**: Pipelines only run when a GitHub Release is published
3. **API migrations only**: Database migrations run only in the API pipeline (before deployment)
4. **Independent deployments**: Each service can be deployed independently
5. **Rollback-safe migrations**: Each migration must have a working `down()` method

## Prerequisites

### 1. KMS Key for Artifact Encryption

Create a KMS key for encrypting pipeline artifacts:

```bash
aws kms create-key \
  --description "Envelope CI/CD artifact encryption" \
  --tags TagKey=Project,TagValue=envelope TagKey=Environment,TagValue=prod

# Note the KeyId from the output
```

### 2. Secrets Manager Setup

#### Laravel APP_KEY

Store the Laravel APP_KEY in Secrets Manager (used for API migrations):

```bash
# Generate a new Laravel key
php artisan key:generate --show

# Store in Secrets Manager
aws secretsmanager create-secret \
  --name "envelope/prod/app-key" \
  --description "Laravel APP_KEY for production" \
  --secret-string "base64:YOUR_GENERATED_KEY_HERE"

# Note the ARN from the output
```

### 3. SNS Topic for Approvals (Recommended)

Create an SNS topic for deployment approval notifications:

```bash
aws sns create-topic --name envelope-deploy-approval

# Subscribe your email
aws sns subscribe \
  --topic-arn arn:aws:sns:eu-west-2:ACCOUNT_ID:envelope-deploy-approval \
  --protocol email \
  --notification-endpoint info@epact.app
```

### 4. GitHub Connections

After running `terraform apply`, you must manually authorize **each** GitHub connection:

1. Go to AWS Console > Developer Tools > Settings > Connections
2. Find the connections:
   - `envelope-prod-github-api`
   - `envelope-prod-github-tenant`
   - `envelope-prod-github-hq`
3. Click "Update pending connection" for each
4. Authorize the connection to your GitHub organization/repository

## Terraform Configuration

### Enable CI/CD

Update your `terraform.tfvars`:

```hcl
# Enable CI/CD
enable_cicd = true

# GitHub Repositories (separate repo per service)
api_github_repository    = "your-org/envelope-api"
tenant_github_repository = "your-org/envelope-tenant"
hq_github_repository     = "your-org/envelope-hq"
github_branch            = "main"

# Security
cicd_kms_key_arn   = "arn:aws:kms:eu-west-2:ACCOUNT_ID:key/KEY_ID"
app_key_secret_arn = "arn:aws:secretsmanager:eu-west-2:ACCOUNT_ID:secret:envelope/prod/app-key-XXXXXX"

# Approval (recommended for production)
cicd_require_manual_approval = true
cicd_approval_sns_topic_arn  = "arn:aws:sns:eu-west-2:ACCOUNT_ID:envelope-deploy-approval"
```

### Apply Configuration

```bash
terraform init
terraform plan
terraform apply
```

## Pipeline Stages

### API Pipeline

| Stage | Action | Description |
|-------|--------|-------------|
| Source | GitHub | Triggered by GitHub release on API repo |
| Build | CodeBuild | Build Laravel Docker image |
| Approval | Manual | Required for production |
| Migrate | CodeBuild | Run `php artisan migrate --force` |
| Deploy | ECS | Rolling update to API, Worker, Scheduler, Reverb |

### Tenant Pipeline

| Stage | Action | Description |
|-------|--------|-------------|
| Source | GitHub | Triggered by GitHub release on Tenant repo |
| Build | CodeBuild | Build Nuxt Tenant Docker image |
| Approval | Manual | Required for production |
| Deploy | ECS | Rolling update to Tenant service |

### HQ Pipeline

| Stage | Action | Description |
|-------|--------|-------------|
| Source | GitHub | Triggered by GitHub release on HQ repo |
| Build | CodeBuild | Build Nuxt HQ Docker image |
| Approval | Manual | Required for production |
| Deploy | ECS | Rolling update to HQ service |

## Creating a Release

Each repository is deployed independently:

### API Deployment

1. **Ensure all tests pass** on your API branch
2. **Create a GitHub Release** in the API repository:
   - Go to Releases > "Draft a new release"
   - Create a new tag (e.g., `v1.2.3`)
   - Write release notes
   - Publish release
3. **Monitor the pipeline**: AWS Console > CodePipeline > `envelope-prod-api-pipeline`
4. **Approve** when prompted

### Tenant/HQ Deployment

Same process, but in the respective repository.

## Rollback Procedures

### Automatic Rollback

ECS circuit breaker automatically rolls back if:
- Health checks fail repeatedly
- Container crashes during startup

### Manual Rollback

To rollback to a previous version:

```bash
# Re-run pipeline with previous release tag
# Or deploy specific image directly:
aws ecs update-service \
  --cluster envelope-prod \
  --service envelope-prod-api \
  --force-new-deployment
```

### Database Migration Rollback

If an API migration fails:

```bash
aws ecs execute-command \
  --cluster envelope-prod \
  --task TASK_ARN \
  --container api \
  --interactive \
  --command "php artisan migrate:rollback --step=1"
```

## Build Specifications

Each repository contains a `buildspec.yml` at the root:

| Repository | Buildspec | Description |
|------------|-----------|-------------|
| API | `buildspec.yml` | Build Laravel image |
| API | `buildspec-migrate.yml` | Run database migrations |
| Tenant | `buildspec.yml` | Build Nuxt Tenant image |
| HQ | `buildspec.yml` | Build Nuxt HQ image |

## Security Considerations (ISO 27001)

| Control | Implementation |
|---------|---------------|
| Secrets Management | AWS Secrets Manager for APP_KEY, DB password |
| Audit Logging | CloudTrail logs all CodePipeline/CodeBuild actions |
| Least Privilege | Minimal IAM permissions per role |
| Artifact Encryption | S3 artifacts encrypted with KMS |
| Manual Approval | Required gate for production deployments |
| Immutable Tags | Use release tags (not `latest`) in production |
| Separate Pipelines | Each service deployed independently |

## Troubleshooting

### GitHub Connection Pending

Each connection must be authorized separately:

1. Go to AWS Console > Developer Tools > Connections
2. Click on the pending connection
3. Click "Update pending connection"
4. Follow the GitHub authorization flow

### Build Failures

Check CodeBuild logs:

```bash
# API build logs
aws logs get-log-events \
  --log-group-name /codebuild/envelope-prod-api-build \
  --log-stream-name STREAM_NAME

# Tenant build logs
aws logs get-log-events \
  --log-group-name /codebuild/envelope-prod-tenant-build \
  --log-stream-name STREAM_NAME
```

### Migration Failures

1. Check CodeBuild migration logs:
   ```bash
   aws logs get-log-events \
     --log-group-name /codebuild/envelope-prod-migration \
     --log-stream-name STREAM_NAME
   ```
2. Verify VPC connectivity to RDS
3. Check security group rules allow CodeBuild -> RDS

### ECS Deployment Stuck

```bash
aws ecs describe-services \
  --cluster envelope-prod \
  --services envelope-prod-api
```

## Environment Variables Reference

### CodeBuild Environment Variables

| Variable | Source | Description |
|----------|--------|-------------|
| `AWS_REGION` | Built-in | eu-west-2 |
| `ECR_REGISTRY` | Computed | ECR registry URL |
| `REPO_NAME` | Terraform | ECR repository name for this service |
| `DB_PASSWORD` | Secrets Manager | For API migrations |
| `APP_KEY` | Secrets Manager | Laravel app key |

### Secrets Manager Paths

| Secret | Path | Used By |
|--------|------|---------|
| Laravel APP_KEY | `envelope/prod/app-key` | API migrations |
| RDS Password | Managed by RDS | API migrations |
