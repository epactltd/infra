# Terraform Runbook

This guide covers running the Terraform in this repo for AWS (production/staging).

## Prerequisites
- Terraform >= 1.0 installed.
- AWS CLI installed (for AWS auth and S3/DynamoDB setup).
- Access to this repo with the `infra` directory available.

## AWS (production/staging) workflow
1. Authenticate to AWS  
   - Export AWS credentials/profile with perms to create S3/DynamoDB (for backend), networking, RDS/ElastiCache, ECS, ALB, IAM, and ACM.
2. Create/identify remote state backend (recommended before first apply)  
   - S3 bucket (e.g., `envelope-tf-state`) and DynamoDB table (e.g., `envelope-tf-locks` with PK `LockID`).  
   - Initialize with backend config, for example:  
     ```
     terraform init \
       -backend-config="bucket=envelope-tf-state" \
       -backend-config="key=envelope/infra.tfstate" \
       -backend-config="region=eu-west-2" \
       -backend-config="dynamodb_table=envelope-tf-locks" \
       -reconfigure
     ```
3. Set required variables (examples)  
   - `project_name`, `environment` (e.g., `prod`/`staging`), `region`.  
   - Networking: `vpc_cidr`, optional `availability_zones` list.  
   - ALB/TLS/WAF: `acm_certificate_arn` (real cert), optional `alb_access_logs_bucket`, optional `alb_web_acl_arn`, `enable_alb_deletion_protection=true` (default).  
   - Database: `db_username`, `db_name`, `manage_db_password=true` (default), backup windows/retention, `rds_deletion_protection=true` (default), `rds_max_allocated_storage`.  
   - Container images: `api_image_tag`, `tenant_image_tag`, `hq_image_tag` (pin to immutable tags/digests).  
   - App settings: `cors_allowed_origins`, `sanctum_stateful_domains`, `session_domain`, `nuxt_public_api_protocol`, `nuxt_public_api_port`, `app_key`, `node_tls_reject_unauthorized`, etc.
4. Plan and apply  
   - `terraform plan -var-file=prod.tfvars`  
   - `terraform apply -var-file=prod.tfvars`
5. Validations post-apply  
   - ALB listeners: HTTPS with real ACM cert, HTTP -> HTTPS redirect.  
   - WAF associated if provided; ALB access logs flowing to bucket.  
   - RDS: deletion protection on, backups/maintenance windows set, Secrets Manager master secret present when `manage_db_password=true`.  
   - ElastiCache: Redis auth secret exists, rotation lambda wired if provided.  
   - ECS services healthy; API/Tenant autoscaling policies present; HQ intentionally has no autoscaling.

## Variable tips
- For production, avoid defaults: always set explicit values in a `*.tfvars` file (not committed).  
- CORS defaults to `*`; set a restricted list for real environments.  
- Set `api_image_tag`, `tenant_image_tag`, and `hq_image_tag` to immutable tags/digests for repeatable deploys and rollbacks.

## State hygiene
- Do not commit `terraform.tfstate*` or `.terraform/` (already ignored).  
- If migrating from local state to S3/DynamoDB, use `terraform state pull/push` carefully after configuring the backend.

## Updating the architecture after first deploy
1. Pull latest code and ensure remote state is configured (`terraform init -reconfigure ...` with your backend settings).
2. Create/update an environment tfvars file (e.g., `prod.tfvars`) with any new variables introduced by the change.
3. Run `terraform plan -var-file=prod.tfvars` and review:  
   - Look for resource replacements (especially RDS/ElastiCache/ALB); consider using `-target` only when necessary and understood.  
   - Confirm IAM changes are expected.  
   - For DB/Redis changes, ensure backups/maintenance windows are suitable before apply.
4. Apply once reviewed: `terraform apply -var-file=prod.tfvars`.
5. Post-apply checks:  
   - ECS services stable; deployments rolled successfully.  
   - ALB listeners/target groups healthy; WAF still attached.  
   - RDS/Redis secrets intact; connections OK.  
   - New resources tagged correctly (Project/Environment/ManagedBy).  
6. Rollback guidance: if a change causes issues, revert the tf config, run `terraform apply` to restore previous desired state, and redeploy application images if needed.
