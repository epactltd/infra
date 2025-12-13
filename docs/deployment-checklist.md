# Envelope Deployment Checklist

Quick reference checklist for deploying Envelope to AWS. See `deployment-guide.md` for detailed instructions.

## Pre-Deployment Checklist

### AWS Setup
- [ ] AWS account created
- [ ] IAM user with admin access created
- [ ] AWS CLI configured (`aws configure`)
- [ ] Verified: `aws sts get-caller-identity`

### Terraform Backend
- [ ] S3 bucket for state created
- [ ] DynamoDB table for locking created
- [ ] `backend.hcl` file created (not committed)

### Pre-Terraform Resources
- [ ] KMS key created for CI/CD encryption
- [ ] ACM certificate requested
- [ ] ACM certificate DNS validation completed (status: ISSUED)
- [ ] APP_KEY stored in Secrets Manager
- [ ] Reverb credentials generated
- [ ] (Optional) SNS topic for approvals created

### Configuration
- [ ] `prod.tfvars` created from example
- [ ] All required values filled in:
  - [ ] `acm_certificate_arn`
  - [ ] `app_key`
  - [ ] `reverb_app_id`, `reverb_app_key`, `reverb_app_secret`
  - [ ] `api_github_repository`, `tenant_github_repository`, `hq_github_repository`
  - [ ] `cicd_kms_key_arn`
  - [ ] `app_key_secret_arn`

---

## Deployment Checklist

### Terraform
- [ ] `terraform init -backend-config=backend.hcl`
- [ ] `terraform plan -var-file=prod.tfvars` (review plan)
- [ ] `terraform apply -var-file=prod.tfvars`
- [ ] Outputs saved: `terraform output -json > terraform-outputs.json`

### Docker Images (First Time)
- [ ] Logged into ECR
- [ ] API image built and pushed
- [ ] Tenant image built and pushed
- [ ] HQ image built and pushed
- [ ] ECS services updated

### CI/CD
- [ ] GitHub connection authorized: `envelope-prod-github-api`
- [ ] GitHub connection authorized: `envelope-prod-github-tenant`
- [ ] GitHub connection authorized: `envelope-prod-github-hq`
- [ ] All pipelines visible in CodePipeline console

### DNS
- [ ] ALB DNS name noted
- [ ] DNS records created:
  - [ ] `api.yourdomain.com` → ALB
  - [ ] `admin.yourdomain.com` → ALB
  - [ ] `wss.yourdomain.com` → ALB
  - [ ] `*.yourdomain.com` → ALB

---

## Post-Deployment Validation

### Services
- [ ] All ECS services running (`runningCount` = `desiredCount`)
- [ ] No stopped tasks with errors

### Health Checks
- [ ] API: `curl -I https://api.yourdomain.com/up` returns 200
- [ ] HQ: `curl -I https://admin.yourdomain.com/` returns 200
- [ ] Tenant: `curl -I https://demo.yourdomain.com/` returns 200

### Database
- [ ] Can run migrations: `php artisan migrate:status`
- [ ] Database tables created

### Logs
- [ ] No errors in `/ecs/envelope-prod-api`
- [ ] No errors in `/ecs/envelope-prod-worker`

---

## First Release

### API Release
- [ ] Create GitHub release with tag (e.g., `v1.0.0`)
- [ ] Pipeline triggered
- [ ] Build stage passed
- [ ] Approval received (if enabled)
- [ ] Migrations completed
- [ ] Deployment completed
- [ ] Health checks passing

### Tenant Release
- [ ] Create GitHub release
- [ ] Pipeline completed
- [ ] Health checks passing

### HQ Release
- [ ] Create GitHub release
- [ ] Pipeline completed
- [ ] Health checks passing

---

## Quick Commands Reference

```bash
# Check service status
aws ecs describe-services --cluster envelope-prod --services envelope-prod-api

# View logs
aws logs tail /ecs/envelope-prod-api --follow

# Force redeploy
aws ecs update-service --cluster envelope-prod --service envelope-prod-api --force-new-deployment

# Run artisan command
aws ecs execute-command --cluster envelope-prod --task TASK_ARN --container api --interactive --command "php artisan migrate:status"

# Get task ARN
aws ecs list-tasks --cluster envelope-prod --service-name envelope-prod-api --query 'taskArns[0]' --output text
```

---

## Troubleshooting Quick Reference

| Issue | Check |
|-------|-------|
| Pipeline stuck at Source | Authorize GitHub connection |
| Build fails | Check CodeBuild logs |
| Migration fails | Check VPC/security groups, DB credentials |
| ECS tasks failing | Check task stopped reason, container logs |
| Health checks failing | Verify health check paths, security groups |
| 502/503 errors | Check target group health, container ports |
