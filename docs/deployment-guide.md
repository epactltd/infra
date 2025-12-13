# Envelope AWS Deployment Guide

This guide walks you through deploying the Envelope application to AWS using Terraform and setting up CI/CD pipelines for automated deployments.

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [AWS Account Setup](#2-aws-account-setup)
3. [Local Environment Setup](#3-local-environment-setup)
4. [Terraform Backend Setup](#4-terraform-backend-setup)
5. [Pre-Terraform AWS Resources](#5-pre-terraform-aws-resources)
6. [Configure Terraform Variables](#6-configure-terraform-variables)
7. [Deploy Infrastructure](#7-deploy-infrastructure)
8. [Build and Push Docker Images](#8-build-and-push-docker-images)
9. [Configure CI/CD Pipelines](#9-configure-cicd-pipelines)
10. [DNS and Domain Setup](#10-dns-and-domain-setup)
11. [Post-Deployment Validation](#11-post-deployment-validation)
12. [First Release Deployment](#12-first-release-deployment)
13. [Troubleshooting](#13-troubleshooting)

---

## 1. Prerequisites

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| AWS CLI | v2.x | AWS resource management |
| Terraform | >= 1.0 | Infrastructure as Code |
| Docker | Latest | Building container images |
| Git | Latest | Version control |

### Install Tools

```bash
# macOS (using Homebrew)
brew install awscli terraform docker git

# Verify installations
aws --version
terraform --version
docker --version
git --version
```

### Required Accounts

- [ ] AWS Account with admin access
- [ ] GitHub account with repositories for API, Tenant, and HQ
- [ ] Domain name (managed in Cloudflare or Route53)

---

## 2. AWS Account Setup

### 2.1 Create IAM User for Terraform

1. Go to AWS Console > IAM > Users > Create User
2. User name: `terraform-deployer`
3. Attach policies:
   - `AdministratorAccess` (for initial setup, reduce later)
4. Create access keys:
   - Go to Security credentials > Create access key
   - Choose "Command Line Interface (CLI)"
   - Download the CSV file

### 2.2 Configure AWS CLI

```bash
# Configure default profile
aws configure
# AWS Access Key ID: [from CSV]
# AWS Secret Access Key: [from CSV]
# Default region name: eu-west-2
# Default output format: json

# Verify configuration
aws sts get-caller-identity
```

### 2.3 (Optional) Use AWS SSO

For better security, use AWS SSO instead of long-lived credentials:

```bash
aws configure sso
# Follow the prompts to configure SSO

# Login before running Terraform
aws sso login --profile your-profile
export AWS_PROFILE=your-profile
```

---

## 3. Local Environment Setup

### 3.1 Clone Repositories

```bash
# Create workspace directory
mkdir -p ~/envelope && cd ~/envelope

# Clone your repositories (adjust URLs)
git clone git@github.com:epactlts/api.git api
git clone git@github.com:epactlts/tenant.git tenant
git clone git@github.com:epactlts/hq.git hq
git clone git@github.com:epactlts/infra.git infra
```

### 3.2 Navigate to Infrastructure

```bash
cd infra
```

---

## 4. Terraform Backend Setup

Terraform needs a remote backend to store state securely.

### 4.1 Create S3 Bucket for State

```bash
# Set variables
BUCKET_NAME="envelope-terraform-state-$(aws sts get-caller-identity --query Account --output text)"
REGION="eu-west-2"

# Create S3 bucket
aws s3api create-bucket \
  --bucket $BUCKET_NAME \
  --region $REGION \
  --create-bucket-configuration LocationConstraint=$REGION

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]
  }'

# Block public access
aws s3api put-public-access-block \
  --bucket $BUCKET_NAME \
  --public-access-block-configuration '{
    "BlockPublicAcls": true,
    "IgnorePublicAcls": true,
    "BlockPublicPolicy": true,
    "RestrictPublicBuckets": true
  }'

echo "Terraform state bucket: $BUCKET_NAME"
```

### 4.2 Create DynamoDB Table for State Locking

```bash
aws dynamodb create-table \
  --table-name envelope-terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region $REGION

echo "DynamoDB lock table: envelope-terraform-lock"
```

### 4.3 Create Backend Configuration

Create a file `backend.hcl` (do not commit this file):

```bash
cat > backend.hcl << 'EOF'
bucket         = "envelope-terraform-state-ACCOUNT_ID"  # Replace with your bucket name
key            = "prod/terraform.tfstate"
region         = "eu-west-2"
dynamodb_table = "envelope-terraform-lock"
encrypt        = true
EOF
```

---

## 5. Pre-Terraform AWS Resources

Some resources must be created before running Terraform.

### 5.1 Create KMS Key (for CI/CD encryption)

```bash
# Create KMS key
KMS_KEY=$(aws kms create-key \
  --description "Envelope CI/CD artifact encryption" \
  --tags TagKey=Project,TagValue=envelope TagKey=Environment,TagValue=prod \
  --query 'KeyMetadata.Arn' \
  --output text)

echo "KMS Key ARN: $KMS_KEY"

# Create alias for easier reference
aws kms create-alias \
  --alias-name alias/envelope-cicd \
  --target-key-id $KMS_KEY
```

### 5.2 Create ACM Certificate

You need an SSL certificate for your domains.

```bash
# Request certificate (replace with your domain)
CERT_ARN=$(aws acm request-certificate \
  --domain-name "*.envelope.host" \
  --subject-alternative-names "envelope.host" \
  --validation-method DNS \
  --query 'CertificateArn' \
  --output text \
  --region eu-west-2)

echo "Certificate ARN: $CERT_ARN"

# Get DNS validation records
aws acm describe-certificate \
  --certificate-arn $CERT_ARN \
  --query 'Certificate.DomainValidationOptions[0].ResourceRecord' \
  --region eu-west-2
```

**Important**: Add the DNS validation record to your domain's DNS (Cloudflare/Route53) and wait for validation:

```bash
# Check certificate status (should become ISSUED)
aws acm describe-certificate \
  --certificate-arn $CERT_ARN \
  --query 'Certificate.Status' \
  --region eu-west-2
```

### 5.3 Create Secrets in Secrets Manager

```bash
# Generate Laravel APP_KEY
APP_KEY=$(openssl rand -base64 32)
echo "Generated APP_KEY: base64:$APP_KEY"

# Store APP_KEY
APP_KEY_ARN=$(aws secretsmanager create-secret \
  --name "envelope/prod/app-key" \
  --description "Laravel APP_KEY for production" \
  --secret-string "base64:$APP_KEY" \
  --query 'ARN' \
  --output text)

echo "APP_KEY Secret ARN: $APP_KEY_ARN"

# Generate Reverb credentials
REVERB_APP_ID="envelope-prod"
REVERB_APP_KEY=$(openssl rand -hex 16)
REVERB_APP_SECRET=$(openssl rand -hex 32)

echo "Reverb App ID: $REVERB_APP_ID"
echo "Reverb App Key: $REVERB_APP_KEY"
echo "Reverb App Secret: $REVERB_APP_SECRET"
```

### 5.4 (Optional) Create SNS Topic for Approvals

```bash
# Create SNS topic
SNS_ARN=$(aws sns create-topic \
  --name envelope-deploy-approval \
  --query 'TopicArn' \
  --output text)

echo "SNS Topic ARN: $SNS_ARN"

# Subscribe your email
aws sns subscribe \
  --topic-arn $SNS_ARN \
  --protocol email \
  --notification-endpoint info@epact.app

echo "Check your email to confirm the subscription!"
```

---

## 6. Configure Terraform Variables

### 6.1 Create terraform.tfvars

Copy the example and fill in your values:

```bash
cp prod.tfvars.example prod.tfvars
```

Edit `prod.tfvars`:

```hcl
# =============================================================================
# Core Settings
# =============================================================================
project_name = "envelope"
environment  = "prod"
region       = "eu-west-2"
vpc_cidr     = "10.0.0.0/16"
availability_zones = ["eu-west-2a", "eu-west-2b"]

# =============================================================================
# Application Settings
# =============================================================================
cors_allowed_origins     = "https://app.envelope.host,https://admin.envelope.host"
app_debug                = "false"
octane_server            = "swoole"
sanctum_stateful_domains = "app.envelope.host,admin.envelope.host"
session_domain           = ".envelope.host"
nuxt_public_api_protocol = "https"
nuxt_public_api_port     = ""
app_url                  = "https://api.envelope.host"
app_key                  = "base64:YOUR_GENERATED_APP_KEY"  # From step 5.3

# =============================================================================
# Domain Configuration
# =============================================================================
hq_host               = "admin.envelope.host"
tenant_primary_domain = "envelope.host"

# Reverb / WebSocket
reverb_host        = "wss.envelope.host"
reverb_public_host = "wss.envelope.host"
reverb_app_id      = "envelope-prod"
reverb_app_key     = "YOUR_REVERB_KEY"      # From step 5.3
reverb_app_secret  = "YOUR_REVERB_SECRET"   # From step 5.3

# =============================================================================
# SSL/TLS
# =============================================================================
acm_certificate_arn = "arn:aws:acm:eu-west-2:ACCOUNT:certificate/XXX"  # From step 5.2

# =============================================================================
# Database
# =============================================================================
db_username             = "envelope_admin"
db_name                 = "envelope"
manage_db_password      = true   # Let RDS manage password
backup_retention_period = 7
rds_deletion_protection = true

# =============================================================================
# Security (Optional)
# =============================================================================
alb_access_logs_bucket         = ""  # Create S3 bucket for ALB logs if needed
alb_web_acl_arn                = ""  # Create WAF WebACL if needed
enable_alb_deletion_protection = true

# =============================================================================
# CI/CD Configuration
# =============================================================================
enable_cicd = true

# GitHub repositories
api_github_repository    = "your-org/envelope-api"
tenant_github_repository = "your-org/envelope-tenant"
hq_github_repository     = "your-org/envelope-hq"
github_branch            = "main"

# Security
cicd_kms_key_arn   = "arn:aws:kms:eu-west-2:ACCOUNT:key/XXX"  # From step 5.1
app_key_secret_arn = "arn:aws:secretsmanager:eu-west-2:ACCOUNT:secret:envelope/prod/app-key-XXX"  # From step 5.3

# Approval
cicd_require_manual_approval = true
cicd_approval_sns_topic_arn  = "arn:aws:sns:eu-west-2:ACCOUNT:envelope-deploy-approval"  # From step 5.4
```

---

## 7. Deploy Infrastructure

### 7.1 Initialize Terraform

```bash
terraform init -backend-config=backend.hcl
```

### 7.2 Plan Deployment

```bash
terraform plan -var-file=prod.tfvars -out=tfplan
```

Review the plan carefully. It will create:
- VPC with public, private, and data subnets
- RDS MariaDB instance
- ElastiCache Redis cluster
- ECR repositories
- ECS cluster and services
- Application Load Balancers
- S3 buckets
- CI/CD pipelines (if enabled)

### 7.3 Apply Deployment

```bash
terraform apply tfplan
```

This takes 15-30 minutes. Note the outputs:

```bash
# Save important outputs
terraform output -json > terraform-outputs.json
```

---

## 8. Build and Push Docker Images

Before CI/CD is working, you need to push initial images manually.

### 8.1 Get ECR Login

```bash
AWS_ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT}.dkr.ecr.eu-west-2.amazonaws.com"

aws ecr get-login-password --region eu-west-2 | \
  docker login --username AWS --password-stdin $ECR_REGISTRY
```

### 8.2 Build and Push API Image

```bash
cd ~/envelope/api

# Build image (ARM64 for Fargate)
docker build --platform linux/arm64 -t $ECR_REGISTRY/envelope-api:v0.1.0 .

# Push to ECR
docker push $ECR_REGISTRY/envelope-api:v0.1.0
docker tag $ECR_REGISTRY/envelope-api:v0.1.0 $ECR_REGISTRY/envelope-api:latest
docker push $ECR_REGISTRY/envelope-api:latest
```

### 8.3 Build and Push Tenant Image

```bash
cd ~/envelope/tenant

docker build --platform linux/arm64 -t $ECR_REGISTRY/envelope-tenant:v0.1.0 .
docker push $ECR_REGISTRY/envelope-tenant:v0.1.0
docker tag $ECR_REGISTRY/envelope-tenant:v0.1.0 $ECR_REGISTRY/envelope-tenant:latest
docker push $ECR_REGISTRY/envelope-tenant:latest
```

### 8.4 Build and Push HQ Image

```bash
cd ~/envelope/hq

docker build --platform linux/arm64 -t $ECR_REGISTRY/envelope-hq:v0.1.0 .
docker push $ECR_REGISTRY/envelope-hq:v0.1.0
docker tag $ECR_REGISTRY/envelope-hq:v0.1.0 $ECR_REGISTRY/envelope-hq:latest
docker push $ECR_REGISTRY/envelope-hq:latest
```

### 8.5 Force ECS Service Update

```bash
# Update services to use new images
for service in api worker scheduler reverb tenant hq; do
  aws ecs update-service \
    --cluster envelope-prod \
    --service envelope-prod-$service \
    --force-new-deployment
done
```

---

## 9. Configure CI/CD Pipelines

### 9.1 Authorize GitHub Connections

Each repository needs a separate GitHub connection authorization:

1. Go to **AWS Console** > **Developer Tools** > **Settings** > **Connections**
2. You'll see three pending connections:
   - `envelope-prod-github-api`
   - `envelope-prod-github-tenant`
   - `envelope-prod-github-hq`
3. For each connection:
   - Click the connection name
   - Click **"Update pending connection"**
   - Authorize access to your GitHub organization
   - Select the appropriate repository

### 9.2 Verify Pipelines

Go to **AWS Console** > **CodePipeline** and verify:

- `envelope-prod-api-pipeline`
- `envelope-prod-tenant-pipeline`
- `envelope-prod-hq-pipeline`

---

## 10. DNS and Domain Setup

### 10.1 Get ALB DNS Names

```bash
# Get public ALB DNS name
aws elbv2 describe-load-balancers \
  --names envelope-prod-public \
  --query 'LoadBalancers[0].DNSName' \
  --output text
```

### 10.2 Configure DNS Records

Add the following DNS records (in Cloudflare or Route53):

| Type | Name | Value | Proxy |
|------|------|-------|-------|
| CNAME | `api` | `envelope-prod-public-XXX.eu-west-2.elb.amazonaws.com` | Yes (Cloudflare) |
| CNAME | `admin` | `envelope-prod-public-XXX.eu-west-2.elb.amazonaws.com` | Yes |
| CNAME | `wss` | `envelope-prod-public-XXX.eu-west-2.elb.amazonaws.com` | No* |
| CNAME | `*` (wildcard) | `envelope-prod-public-XXX.eu-west-2.elb.amazonaws.com` | Yes |

*WebSocket connections should not be proxied if using Cloudflare (or use WebSocket support).

### 10.3 Cloudflare Configuration (if using)

1. **SSL/TLS**: Set to "Full (strict)"
2. **WebSockets**: Enable WebSockets under Network settings
3. **Firewall Rules**: Allow health check paths

---

## 11. Post-Deployment Validation

### 11.1 Check ECS Services

```bash
# List all services
aws ecs list-services --cluster envelope-prod

# Check service status
for service in api worker scheduler reverb tenant hq; do
  echo "=== $service ==="
  aws ecs describe-services \
    --cluster envelope-prod \
    --services envelope-prod-$service \
    --query 'services[0].{status:status,running:runningCount,desired:desiredCount}'
done
```

### 11.2 Check Health Endpoints

```bash
# API health check
curl -I https://api.envelope.host/up

# HQ health check
curl -I https://admin.envelope.host/

# Tenant health check (replace with actual tenant subdomain)
curl -I https://demo.envelope.host/
```

### 11.3 Check Database Connectivity

```bash
# Get a task ARN
TASK_ARN=$(aws ecs list-tasks \
  --cluster envelope-prod \
  --service-name envelope-prod-api \
  --query 'taskArns[0]' \
  --output text)

# Run artisan command to check DB
aws ecs execute-command \
  --cluster envelope-prod \
  --task $TASK_ARN \
  --container api \
  --interactive \
  --command "php artisan migrate:status"
```

### 11.4 Check Logs

```bash
# View API logs
aws logs tail /ecs/envelope-prod-api --follow

# View specific service logs
aws logs tail /ecs/envelope-prod-worker --follow
```

---

## 12. First Release Deployment

Now that everything is set up, create your first release.

### 12.1 Create API Release

1. Go to your API repository on GitHub
2. Click **Releases** > **Draft a new release**
3. Create tag: `v1.0.0`
4. Write release notes
5. Click **Publish release**

### 12.2 Monitor Pipeline

1. Go to **AWS Console** > **CodePipeline**
2. Click `envelope-prod-api-pipeline`
3. Watch the pipeline progress:
   - Source → Build → Approval → Migrate → Deploy
4. When prompted, approve the deployment

### 12.3 Repeat for Tenant and HQ

Create releases in Tenant and HQ repositories following the same process.

---

## 13. Troubleshooting

### Pipeline Fails at Source

**Problem**: GitHub connection not authorized

**Solution**:
1. Go to Developer Tools > Connections
2. Authorize the pending connection

### Pipeline Fails at Build

**Problem**: Docker build errors

**Solution**:
```bash
# Check CodeBuild logs
aws logs tail /codebuild/envelope-prod-api-build --follow
```

### Pipeline Fails at Migrate

**Problem**: Database connection or migration error

**Solution**:
```bash
# Check migration logs
aws logs tail /codebuild/envelope-prod-migration --follow

# Verify RDS security group allows CodeBuild
```

### ECS Tasks Keep Failing

**Problem**: Container crashes on startup

**Solution**:
```bash
# Check stopped task reason
aws ecs describe-tasks \
  --cluster envelope-prod \
  --tasks $(aws ecs list-tasks --cluster envelope-prod --service-name envelope-prod-api --desired-status STOPPED --query 'taskArns[0]' --output text)

# Check container logs
aws logs tail /ecs/envelope-prod-api --since 1h
```

### Health Checks Failing

**Problem**: ALB health checks return unhealthy

**Solution**:
1. Verify health check paths:
   - API: `/up`
   - HQ: `/`
   - Tenant: `/`
2. Check security groups allow ALB → ECS traffic
3. Verify container is listening on correct port

### Cannot Connect to Database

**Problem**: RDS connection refused

**Solution**:
1. Verify security group rules
2. Check RDS is in the same VPC
3. Verify credentials in Secrets Manager

---

## Quick Reference

### Important Commands

```bash
# Terraform
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
terraform output

# ECS
aws ecs list-services --cluster envelope-prod
aws ecs update-service --cluster envelope-prod --service SERVICE --force-new-deployment

# Logs
aws logs tail /ecs/envelope-prod-api --follow
aws logs tail /codebuild/envelope-prod-api-build --follow

# Execute command in container
aws ecs execute-command --cluster envelope-prod --task TASK_ARN --container api --interactive --command "/bin/sh"
```

### Important URLs

| Service | URL |
|---------|-----|
| AWS Console | https://console.aws.amazon.com |
| CodePipeline | https://eu-west-2.console.aws.amazon.com/codesuite/codepipeline/pipelines |
| ECS | https://eu-west-2.console.aws.amazon.com/ecs/home |
| CloudWatch Logs | https://eu-west-2.console.aws.amazon.com/cloudwatch/home#logsV2:log-groups |

### Support Contacts

- AWS Support: https://console.aws.amazon.com/support/home
- Terraform Issues: https://github.com/hashicorp/terraform/issues

---

## Appendix: Cost Estimate

| Resource | Monthly Cost (Estimate) |
|----------|------------------------|
| ECS Fargate (6 services) | ~$150-300 |
| RDS db.t3.medium | ~$50-70 |
| ElastiCache cache.t3.micro | ~$15-25 |
| ALB (2) | ~$35-50 |
| NAT Gateway (2) | ~$70-100 |
| S3, CloudWatch, etc. | ~$20-40 |
| **Total** | **~$340-585/month** |

*Costs vary based on usage and region.*
