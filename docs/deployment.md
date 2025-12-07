# Deployment Guide

This document walks through deploying the Terraform-based multi-tenant infrastructure with all security hardening and operational improvements. It assumes you have access to the target AWS account and the remote state backend defined in `backend.tf`.

## Prerequisites
- Terraform v1.5 or newer (version constraint enforced in `backend.tf`)
- AWS CLI v2 configured with credentials that can manage:
  - S3 bucket + DynamoDB table used for remote state (`terraform-state-multi-tenant-prod`, `terraform-state-lock`) or your chosen backend
  - KMS key for state encryption (alias: `terraform-state-key`) - **must be created before init**
  - All AWS resources provisioned by the modules (VPC, EC2, RDS, Lambda, KMS, etc.)
- Python 3.11 (for Lambda packaging)
- `zip` utility (for the Lambda archive step)
- Optional: Git CLI (if cloning the repository)

## Pre-Deployment: Create State Encryption Key
Before running `terraform init`, create the KMS key for state encryption:
```bash
aws kms create-key --description "Terraform state encryption key"
aws kms create-alias --alias-name alias/terraform-state-key --target-key-id <KEY_ID_FROM_ABOVE>
```

## 1. Clone and Set Context
```bash
git clone <repository-url>
cd <repository-directory>
```

## 2. Configure Variables & Credentials
1. Export AWS credentials (environment variables, `~/.aws/credentials`, or AWS SSO) before running Terraform. The credentials must have access to the remote state backend.
2. Provide required Terraform variables via environment variables or a `terraform.tfvars` file. Example shell exports:
   ```bash
   export TF_VAR_environment="prod"
   export TF_VAR_project_name="multi-tenant-app"
   export TF_VAR_vpc_cidr="10.0.0.0/16"
   export TF_VAR_availability_zones='["eu-west-2a","eu-west-2b"]'
   export TF_VAR_app_domain="example.com"
   export TF_VAR_ami_id="ami-0123456789abcdef0"
   export TF_VAR_db_master_username="admin"
   export TF_VAR_sns_email_endpoint="ops@example.com"
   # Optional: reuse an existing Route53 zone
   # export TF_VAR_app_hosted_zone_id="Z123456ABCDEFG"
   ```
   The RDS master password is now managed automatically by AWS Secrets Manager. After deployment, fetch it via `aws secretsmanager get-secret-value --secret-id "$(terraform output -raw db_master_secret_arn)"`.
3. If using `terraform.tfvars`, ensure it is excluded from version control when containing secrets.

## 3. Initialise Terraform Backend & Providers
1. Verify the S3 bucket and DynamoDB table referenced in `backend.tf` exist, or override them with `-backend-config` flags.
2. Initialise Terraform and select/create the workspace that matches your deployment environment (state files are segmented automatically under `environments/<workspace>/terraform.tfstate`):
   ```bash
   terraform init -backend-config="bucket=terraform-state-multi-tenant-prod" -backend-config="region=eu-west-2"
   terraform workspace new prod || terraform workspace select prod
   ```

## 4. Format, Validate, and Plan
```bash
terraform fmt -recursive
terraform validate
terraform plan -var-file="terraform.tfvars" -out="tfplan"
```
Use `-var` flags instead of `-var-file` if you prefer passing values directly. Inspect the plan for any unintended changes.

## 5. Apply
```bash
terraform apply "tfplan"
```
Provisioning typically takes 15–20 minutes. Terraform will output key identifiers (ALB DNS name, ACM certificate ARN, etc.) after completion. Persist outputs if desired:
```bash
terraform output -json > outputs.json
```

## 6. Post-Deployment Tasks
- **ACM Validation**: If the wildcard certificate uses email validation, approve the validation email. When using Route53 DNS validation with `app_hosted_zone_id`, Terraform should complete automatically.
- **SNS Subscription**: Confirm the email subscription for the alerts topic (check inbox).
- **Verify WAF Association**: Check ALB in AWS Console → Integrated services → Confirm WAF is attached.
- **Test HTTP→HTTPS Redirect**: 
  ```bash
  curl -I http://<ALB_DNS_NAME>
  # Should return: HTTP/1.1 301 Moved Permanently, Location: https://...
  ```
- **Tenant Lambda Smoke Test**:
  ```bash
  aws lambda invoke \
    --function-name "${TF_VAR_project_name}-${TF_VAR_environment}-tenant-provisioner" \
    --payload '{"tenant_id": "test123", "tenant_name": "Test Tenant"}' \
    --region "${TF_VAR_aws_region:-eu-west-2}" \
    response.json
  cat response.json
  # Verify S3 bucket created with encryption, versioning, public access block
  ```
- **Verify Backup Plan**: Check AWS Backup Console → Backup plans → Confirm daily (5 AM) and weekly jobs scheduled.
- **Application Deployment**: Deploy the Laravel/Nuxt application artifacts (e.g., via CodeDeploy, SSM, or baked AMIs) and ensure the ALB health check endpoint (`/health`) aligns with the application.

## 7. Ongoing Operations
- Monitor the CloudWatch dashboard and alarms provisioned by the monitoring module.
- Review GuardDuty, Security Hub, and AWS Config findings regularly.
- Test AWS Backup restore procedures and document them in `docs/backup-restore-runbook.md`.
- Capture changes to Terraform variables and infrastructure decisions in version control to maintain reproducibility.

By following this guide, you can reproducibly deploy the infrastructure while maintaining compliance, observability, and automation assumptions described in `docs/readme.md`.
Prerequisites
AWS CLI v2 configured with appropriate credentials
Terraform v1.5+ installed
Python 3.11+ (for Lambda packaging)
IAM user/role with administrative permissions

Step 1: Initialize Terraform

# Clone repository
git clone <repository-url>
cd terraform

# Set environment
export TF_VAR_environment="prod"
export TF_VAR_db_master_username="admin"

# Initialize
terraform init -backend-config="bucket=terraform-state-multi-tenant-prod" \
               -backend-config="region=eu-west-2"
terraform workspace new prod || terraform workspace select prod

Step 2: Validate and Plan
# Format and validate
terraform fmt -recursive
terraform validate

# Create plan
terraform plan -out=tfplan -var-file="terraform.tfvars"

Step 3: Apply Infrastructure
# Deploy (approx. 15-20 minutes)
terraform apply tfplan

# Store outputs
terraform output -json > outputs.json


Step 4: Post-Deployment Configuration
Verify ACM Certificate: Check email for validation link if not using Route53
Confirm SNS Subscription: Check email and confirm SNS subscription
Test Lambda Function:

aws lambda invoke \
  --function-name multi-tenant-app-prod-tenant-provisioner \
  --payload '{"tenant_id": "test123", "tenant_name": "Test Tenant"}' \
  --region eu-west-2 \
  response.json

Step 5: Application Deployment
# Build your Laravel + Nuxt application
# Deploy to EC2 instances via CodeDeploy or S3
# Update ALB target group health check endpoint
