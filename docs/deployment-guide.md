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
9. [Run Database Migrations](#9-run-database-migrations)
10. [Configure CI/CD Pipelines](#10-configure-cicd-pipelines)
11. [DNS and Domain Setup](#11-dns-and-domain-setup)
12. [Post-Deployment Validation](#12-post-deployment-validation)
13. [First Release Deployment](#13-first-release-deployment)
14. [Security Configuration](#14-security-configuration)
15. [Troubleshooting](#15-troubleshooting)

---

## 1. Prerequisites

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| AWS CLI | v2.x | AWS resource management |
| Terraform | >= 1.0 | Infrastructure as Code |
| Docker | Latest | Building container images |
| Git | Latest | Version control |
| Session Manager Plugin | Latest | ECS execute-command support |

### Install Tools

```bash
# macOS (using Homebrew)
brew install awscli terraform docker git

# Install AWS Session Manager Plugin (required for ECS exec)
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac_arm64/sessionmanager-bundle.zip" -o "/tmp/sessionmanager-bundle.zip"
cd /tmp && unzip -o sessionmanager-bundle.zip
sudo /tmp/sessionmanager-bundle/install -i /usr/local/sessionmanagerplugin -b /usr/local/bin/session-manager-plugin

# Verify installations
aws --version
terraform --version
docker --version
git --version
session-manager-plugin --version
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
# Configure a named profile (recommended)
aws configure --profile envelope
# AWS Access Key ID: [from CSV]
# AWS Secret Access Key: [from CSV]
# Default region name: eu-west-2
# Default output format: json

# Set as default profile
export AWS_PROFILE=envelope

# Verify configuration
aws sts get-caller-identity
```

> **Important**: Ensure there are no trailing spaces or tabs in your `~/.aws/credentials` file, as this can cause authentication errors.

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
git clone git@github.com:epactltd/api.git api
git clone git@github.com:epactltd/tenant.git tenant
git clone git@github.com:epactltd/hq.git hq
git clone git@github.com:epactltd/infra.git infra
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
# Get your account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

cat > backend.hcl << EOF
bucket         = "envelope-terraform-state-${ACCOUNT_ID}"
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
cors_allowed_origins     = "https://*.envelope.host,https://admin.envelope.host"
app_debug                = "false"
octane_server            = "swoole"
sanctum_stateful_domains = "*.envelope.host,admin.envelope.host"
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
api_host              = "api.envelope.host"

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
db_username             = "appuser"
db_name                 = "envelope"
manage_db_password      = true   # Let RDS manage password (recommended)
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

# GitHub repositories (format: org/repo)
api_github_repository    = "epactltd/api"
tenant_github_repository = "epactltd/tenant"
hq_github_repository     = "epactltd/hq"
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

> If you get a backend configuration error, run `terraform init -backend-config=backend.hcl -reconfigure`

### 7.2 Plan Deployment

```bash
terraform plan -var-file=prod.tfvars -out=tfplan
```

Review the plan carefully. It will create:
- VPC with public, private, and data subnets
- RDS MariaDB instance (with managed password)
- ElastiCache Redis cluster (with TLS enabled)
- ECR repositories
- ECS cluster and services
- Application Load Balancers (public and internal)
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

# Build image
docker build -t $ECR_REGISTRY/envelope-api:latest .

# Push to ECR
docker push $ECR_REGISTRY/envelope-api:latest
```

### 8.3 Build and Push Tenant Image

```bash
cd ~/envelope/tenant

docker build -t $ECR_REGISTRY/envelope-tenant:latest .
docker push $ECR_REGISTRY/envelope-tenant:latest
```

### 8.4 Build and Push HQ Image

```bash
cd ~/envelope/hq

docker build -t $ECR_REGISTRY/envelope-hq:latest .
docker push $ECR_REGISTRY/envelope-hq:latest
```

### 8.5 Force ECS Service Update

```bash
# Update services to use new images
for service in api worker scheduler reverb tenant hq; do
  aws ecs update-service \
    --cluster envelope-prod-cluster \
    --service envelope-prod-$service \
    --force-new-deployment \
    --query 'service.serviceName' \
    --output text
done
```

---

## 9. Run Database Migrations

### 9.1 Run Initial Migration

After pushing the API image and starting the service, run migrations using ECS run-task:

```bash
# Get the latest API task definition
TASK_DEF=$(aws ecs describe-services \
  --cluster envelope-prod-cluster \
  --services envelope-prod-api \
  --query 'services[0].taskDefinition' \
  --output text)

# Get private subnet and security group
SUBNET=$(aws ec2 describe-subnets \
  --filters "Name=tag:Name,Values=*envelope*private*" \
  --query 'Subnets[0].SubnetId' \
  --output text)

SG=$(aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=*envelope*laravel*" \
  --query 'SecurityGroups[0].GroupId' \
  --output text)

# Run migration task
aws ecs run-task \
  --cluster envelope-prod-cluster \
  --task-definition $TASK_DEF \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[$SUBNET],securityGroups=[$SG],assignPublicIp=DISABLED}" \
  --overrides '{
    "containerOverrides": [{
      "name": "api",
      "command": ["php", "artisan", "migrate", "--force"]
    }]
  }' \
  --query 'tasks[0].taskArn' \
  --output text
```

### 9.2 Monitor Migration Task

```bash
# Replace with your task ARN
TASK_ARN="arn:aws:ecs:eu-west-2:ACCOUNT:task/envelope-prod-cluster/TASK_ID"

# Check task status
aws ecs describe-tasks \
  --cluster envelope-prod-cluster \
  --tasks $TASK_ARN \
  --query 'tasks[0].{Status:lastStatus,ExitCode:containers[0].exitCode}'

# View migration logs
TASK_ID=$(echo $TASK_ARN | cut -d'/' -f3)
aws logs get-log-events \
  --log-group-name /ecs/envelope-prod-api \
  --log-stream-name "ecs/api/$TASK_ID" \
  --query 'events[*].message' \
  --output text
```

---

## 10. Configure CI/CD Pipelines

### 10.1 Authorize GitHub Connections

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

### 10.2 Verify Pipelines

Go to **AWS Console** > **CodePipeline** and verify:

- `envelope-prod-api-pipeline`
- `envelope-prod-tenant-pipeline`
- `envelope-prod-hq-pipeline`

---

## 11. DNS and Domain Setup

### 11.1 Get ALB DNS Names

```bash
# Get public ALB DNS name
aws elbv2 describe-load-balancers \
  --names envelope-prod-public-alb \
  --query 'LoadBalancers[0].DNSName' \
  --output text
```

### 11.2 Configure DNS Records

Add the following DNS records (in Cloudflare or Route53):

| Type | Name | Value | Proxy |
|------|------|-------|-------|
| CNAME | `api` | `envelope-prod-public-alb-XXX.eu-west-2.elb.amazonaws.com` | Yes (Cloudflare) |
| CNAME | `admin` | `envelope-prod-public-alb-XXX.eu-west-2.elb.amazonaws.com` | Yes |
| CNAME | `wss` | `envelope-prod-public-alb-XXX.eu-west-2.elb.amazonaws.com` | No* |
| CNAME | `*` (wildcard) | `envelope-prod-public-alb-XXX.eu-west-2.elb.amazonaws.com` | Yes |

*WebSocket connections should not be proxied if using Cloudflare (or enable WebSocket support).

> **Important**: If you have existing specific subdomain records (e.g., `demo`), they will override the wildcard. Remove or update them to point to the new ALB.

### 11.3 Cloudflare Configuration (if using)

1. **SSL/TLS**: Set to "Full (strict)"
2. **WebSockets**: Enable WebSockets under Network settings
3. **Firewall Rules**: Allow health check paths

---

## 12. Post-Deployment Validation

### 12.1 Check ECS Services

```bash
# List all services
aws ecs list-services --cluster envelope-prod-cluster

# Check service status
for service in api worker scheduler reverb tenant hq; do
  echo "=== $service ==="
  aws ecs describe-services \
    --cluster envelope-prod-cluster \
    --services envelope-prod-$service \
    --query 'services[0].{status:status,running:runningCount,desired:desiredCount}' \
    --output table
done
```

### 12.2 Check Health Endpoints

```bash
# API health check (should return HTML with "Application up")
curl -s https://api.envelope.host/up | grep -o "Application up" && echo " ✓ API OK"

# HQ health check
curl -sI https://admin.envelope.host/ | head -1

# Tenant health check (replace with actual tenant subdomain)
curl -sI https://demo.envelope.host/ | head -1
```

### 12.3 Check Target Group Health

```bash
# Get all target groups
aws elbv2 describe-target-groups \
  --query 'TargetGroups[?contains(TargetGroupName, `envelope`)].{Name:TargetGroupName,ARN:TargetGroupArn}' \
  --output table

# Check health of specific target group
aws elbv2 describe-target-health \
  --target-group-arn TARGET_GROUP_ARN \
  --query 'TargetHealthDescriptions[*].{Target:Target.Id,Health:TargetHealth.State}' \
  --output table
```

### 12.4 Check Logs

```bash
# View API logs
aws logs tail /ecs/envelope-prod-api --follow

# View specific service logs
aws logs tail /ecs/envelope-prod-worker --follow
```

---

## 13. First Release Deployment

Now that everything is set up, create your first release.

### 13.1 Create API Release

1. Go to your API repository on GitHub
2. Click **Releases** > **Draft a new release**
3. Create tag: `v1.0.0`
4. Write release notes
5. Click **Publish release**

### 13.2 Monitor Pipeline

1. Go to **AWS Console** > **CodePipeline**
2. Click `envelope-prod-api-pipeline`
3. Watch the pipeline progress:
   - Source → Build → Approval → Migrate → Deploy
4. When prompted, approve the deployment

### 13.3 Repeat for Tenant and HQ

Create releases in Tenant and HQ repositories following the same process.

---

## 14. Security Configuration

### 14.1 Architecture Overview

The infrastructure follows these security principles:

| Component | Access |
|-----------|--------|
| RDS Database | Private only (no public access) |
| ElastiCache Redis | Private only (TLS enabled) |
| API containers | Private subnets, SG-restricted |
| HQ/Tenant → API | Internal ALB (private network) |
| Public access | Through Public ALB only |

### 14.2 IP Whitelisting for API

To restrict `api.envelope.host` to specific client IPs (for integrations):

**Option 1: Cloudflare WAF (Recommended)**

1. Go to **Cloudflare Dashboard** > **Security** > **WAF** > **Custom Rules**
2. Create a rule:
   - **If**: `(http.host eq "api.envelope.host") and (not ip.src in {WHITELIST_IPS})`
   - **Then**: Block

**Option 2: Cloudflare Access**

Use Cloudflare Access for more advanced authentication and access control.

### 14.3 Verify Database Security

```bash
# Confirm RDS is not publicly accessible
aws rds describe-db-instances \
  --db-instance-identifier envelope-prod-db \
  --query 'DBInstances[0].PubliclyAccessible'
# Should return: false

# Confirm security group only allows internal access
aws rds describe-db-instances \
  --db-instance-identifier envelope-prod-db \
  --query 'DBInstances[0].VpcSecurityGroups[*].VpcSecurityGroupId'
```

---

## 15. Troubleshooting

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

### Redis Connection Errors

**Problem**: `Class "Predis\Client" not found` or Redis connection refused

**Solution**: The infrastructure uses phpredis (not predis) with TLS. Ensure your Laravel config uses:
```php
'client' => env('REDIS_CLIENT', 'phpredis'),
```

And for TLS connections, the host should be prefixed with `tls://` or use the `REDIS_SCHEME=tls` environment variable.

### Database Connection Errors

**Problem**: `Access denied` or `Connection refused`

**Solution**:
1. Verify `DB_HOST` does not include port (should be hostname only)
2. Verify `DB_PORT` is set to `3306`
3. Verify `DB_CONNECTION` is set to `mysql`
4. For RDS managed passwords, ensure secret ARN includes `:password::` suffix to extract the password field

```bash
# Check task definition environment
aws ecs describe-task-definition \
  --task-definition envelope-prod-api \
  --query 'taskDefinition.containerDefinitions[0].environment[?starts_with(name, `DB_`)]' \
  --output table
```

### ECS Tasks Keep Failing

**Problem**: Container crashes on startup

**Solution**:
```bash
# Check stopped task reason
TASK=$(aws ecs list-tasks \
  --cluster envelope-prod-cluster \
  --service-name envelope-prod-api \
  --desired-status STOPPED \
  --query 'taskArns[0]' \
  --output text)

aws ecs describe-tasks \
  --cluster envelope-prod-cluster \
  --tasks $TASK \
  --query 'tasks[0].stoppedReason'

# Check container logs
aws logs tail /ecs/envelope-prod-api --since 1h
```

### Health Checks Failing

**Problem**: ALB health checks return unhealthy

**Solution**:
1. Verify health check paths:
   - API: `/up`
   - HQ: `/` (accepts 200 or 302)
   - Tenant: `/` (accepts 200 or 302)
2. Check security groups allow ALB → ECS traffic
3. Verify container is listening on correct port (8000 for API, 3000 for Nuxt)

```bash
# Update health check to accept redirects
aws elbv2 modify-target-group \
  --target-group-arn TARGET_GROUP_ARN \
  --matcher HttpCode=200,302
```

### Cannot Connect to Database

**Problem**: RDS connection refused

**Solution**:
1. Verify security group rules allow ECS tasks
2. Check RDS is in the same VPC
3. Verify credentials in Secrets Manager

### Tenant Provisioning Stuck

**Problem**: Tenant shows "pending" status for Database/Migration/Seeds

**Solution**:
1. Check if worker is running the latest task definition
2. Check failed jobs queue
3. Verify `QUEUE_CONNECTION=redis` is set

```bash
# Check failed jobs
aws ecs run-task --cluster envelope-prod-cluster \
  --task-definition TASK_DEF --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={...}" \
  --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","queue:failed"]}]}'

# Force update worker
aws ecs update-service --cluster envelope-prod-cluster \
  --service envelope-prod-worker --force-new-deployment
```

### S3 Bucket Creation Fails

**Problem**: Bucket flag shows error or stays pending

**Solution**:
1. Check Lambda logs for errors
2. Verify `AWS_EVENTBRIDGE_BUS` environment variable is set
3. Check EventBridge rule is properly configured

```bash
# Check Lambda logs
aws logs tail /aws/lambda/envelope-prod-tenant-provisioner --since 30m

# Verify EventBridge bus
aws events describe-event-bus --name envelope-prod-app-events

# Check rules
aws events list-rules --event-bus-name envelope-prod-app-events
```

### EventBridge Bus Name Not Configured

**Problem**: `RuntimeException: EventBridge bus name not configured`

**Solution**: 
1. Verify `AWS_EVENTBRIDGE_BUS` is in the worker task definition
2. Force redeploy worker service after Terraform apply

```bash
# Check worker env vars
aws ecs describe-task-definition \
  --task-definition envelope-prod-worker \
  --query 'taskDefinition.containerDefinitions[0].environment[?name==`AWS_EVENTBRIDGE_BUS`]'

# Force update
aws ecs update-service --cluster envelope-prod-cluster \
  --service envelope-prod-worker --force-new-deployment
```

---

## Quick Reference

### Important Commands

```bash
# Terraform
terraform plan -var-file=prod.tfvars
terraform apply -var-file=prod.tfvars
terraform output

# ECS
aws ecs list-services --cluster envelope-prod-cluster
aws ecs update-service --cluster envelope-prod-cluster --service SERVICE --force-new-deployment

# Run one-off command
aws ecs run-task --cluster envelope-prod-cluster --task-definition TASK_DEF \
  --launch-type FARGATE --network-configuration "..." \
  --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","COMMAND"]}]}'

# Logs
aws logs tail /ecs/envelope-prod-api --follow
aws logs tail /codebuild/envelope-prod-api-build --follow

# Execute command in container (requires Session Manager plugin)
aws ecs execute-command \
  --cluster envelope-prod-cluster \
  --task TASK_ARN \
  --container api \
  --interactive \
  --command "/bin/sh"
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

---

## Appendix: Configuration Notes

### Laravel Configuration Requirements

The API/Worker/Scheduler containers require these environment variables (automatically set by Terraform):

| Variable | Description |
|----------|-------------|
| `DB_CONNECTION` | Must be `mysql` |
| `DB_HOST` | RDS hostname (without port) |
| `DB_PORT` | `3306` |
| `REDIS_SCHEME` | `tls` (for ElastiCache with encryption) |
| `QUEUE_CONNECTION` | `redis` (uses ElastiCache) |
| `AWS_EVENTBRIDGE_BUS` | EventBridge bus name for tenant provisioning |
| `TENANT_PRIMARY_DOMAIN` | Primary domain for tenant validation (e.g., `envelope.host`) |
| `SKIP_MIGRATIONS` | `true` (prevents migrations on container startup) |

### Redis with TLS

ElastiCache is configured with transit encryption (TLS). The Laravel `config/database.php` must use:

```php
'redis' => [
    'client' => env('REDIS_CLIENT', 'phpredis'),
    'default' => [
        'host' => env('REDIS_SCHEME') === 'tls' 
            ? 'tls://' . env('REDIS_HOST') 
            : env('REDIS_HOST'),
        // ... other config
        'context' => env('REDIS_SCHEME') === 'tls' ? [
            'ssl' => ['verify_peer' => false, 'verify_peer_name' => false],
        ] : [],
    ],
],
```

### RDS Managed Passwords

When `manage_db_password = true`, RDS creates a secret in AWS Secrets Manager with JSON format:
```json
{"username": "appuser", "password": "actual-password"}
```

The ECS task definition extracts just the password using the ARN suffix `:password::`.

---

## Appendix: Tenant Provisioning Architecture

When a new tenant is created in HQ, the following automated provisioning flow occurs:

### Flow Diagram

```
Create Tenant (HQ)
       │
       ▼
┌──────────────────┐
│  Worker Queue    │
│                  │
│ 1. CreateDatabase│ ──► Database created (or skipped if exists)
│ 2. Migrate       │ ──► Tables created
│ 3. Seed          │ ──► Initial data populated
│ 4. PublishEvent  │ ──► EventBridge event sent
│ 5. Finalize      │ ──► Status updated
└──────────────────┘
       │
       ▼ (EventBridge)
┌──────────────────┐
│  Lambda          │
│  Provisioner     │
│                  │
│ - Create S3      │
│ - Configure      │
│ - Callback API   │
└──────────────────┘
       │
       ▼
┌──────────────────┐
│  API Callback    │
│                  │
│ - Update tenant  │
│   S3 configs     │
│ - Update bucket  │
│   flag to success│
└──────────────────┘
```

### Key Components

| Component | Purpose |
|-----------|---------|
| `CreateDatabaseIfNotExists` | Idempotent database creation (safe for retries) |
| `PublishTenantCreatedEvent` | Publishes event to EventBridge |
| `envelope-prod-tenant-provisioner` | Lambda that creates S3 buckets securely |
| `/api/internal/tenants/{id}/provisioning` | Callback endpoint for Lambda |
| `provisioner-token` secret | Authentication token for Lambda callbacks |

### Environment Variables

All Laravel services (API, Worker, Scheduler) require:

| Variable | Description |
|----------|-------------|
| `AWS_EVENTBRIDGE_BUS` | Name of the EventBridge bus (`envelope-prod-app-events`) |
| `PROVISIONER_CALLBACK_TOKEN` | Token for internal API callbacks (from Secrets Manager) |

### Idempotent Operations

The provisioning jobs are designed to be **retry-safe**:

1. **CreateDatabaseIfNotExists** - Catches `TenantDatabaseAlreadyExistsException` and continues
2. **UserSeeder** - Uses `updateOrCreate()` instead of direct inserts
3. **Lambda** - Checks if bucket exists before creating

### Troubleshooting Provisioning

```bash
# Check failed jobs
aws ecs run-task ... --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","queue:failed"]}]}'

# Check Lambda logs
aws logs tail /aws/lambda/envelope-prod-tenant-provisioner --follow

# Check EventBridge events
aws events describe-event-bus --name envelope-prod-app-events

# Retry failed jobs
aws ecs run-task ... --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","queue:retry","all"]}]}'
```

---

## Appendix: GitHub Actions Deployment

### Automated Deployments on Release

Each repository can trigger its CodePipeline automatically when a GitHub release is created.

### Setup GitHub Actions Workflow

Create `.github/workflows/deploy.yml` in each repository:

```yaml
name: Deploy to Production

on:
  release:
    types: [published]

permissions:
  id-token: write
  contents: read

jobs:
  trigger-pipeline:
    runs-on: ubuntu-latest
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: arn:aws:iam::ACCOUNT_ID:role/github-actions-role
          aws-region: eu-west-2

      - name: Trigger CodePipeline
        run: |
          aws codepipeline start-pipeline-execution \
            --name envelope-prod-api-pipeline
```

### Create IAM Role for GitHub Actions

```bash
# Create OIDC provider (one-time)
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1

# Create role with trust policy
cat > trust-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {
      "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
    },
    "Action": "sts:AssumeRoleWithWebIdentity",
    "Condition": {
      "StringEquals": {
        "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
      },
      "StringLike": {
        "token.actions.githubusercontent.com:sub": "repo:epactltd/*:*"
      }
    }
  }]
}
EOF

aws iam create-role \
  --role-name github-actions-role \
  --assume-role-policy-document file://trust-policy.json

# Attach policy for CodePipeline
aws iam put-role-policy \
  --role-name github-actions-role \
  --policy-name codepipeline-start \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": "codepipeline:StartPipelineExecution",
      "Resource": "arn:aws:codepipeline:eu-west-2:ACCOUNT_ID:envelope-prod-*"
    }]
  }'
```

---

## Appendix: Build Optimizations

### Docker Build Performance

The API Dockerfile uses several optimizations for faster builds:

1. **Multi-stage build** - Separates build dependencies from runtime
2. **BuildKit cache mounts** - Caches composer and apk downloads
3. **Layer caching** - Uses `--cache-from` to reuse previous layers

### buildspec.yml Configuration

```yaml
phases:
  pre_build:
    commands:
      # Pull previous image for cache
      - docker pull $ECR_REGISTRY/$REPO_NAME:latest || true

  build:
    commands:
      # Enable BuildKit with cache
      - export DOCKER_BUILDKIT=1
      - docker build --cache-from $ECR_REGISTRY/$REPO_NAME:latest \
          --build-arg BUILDKIT_INLINE_CACHE=1 \
          -t $IMAGE_URI -f Dockerfile .
```

### CodeBuild Compute Types

| Service | Compute Type | RAM | Notes |
|---------|--------------|-----|-------|
| API | BUILD_GENERAL1_MEDIUM | 7 GB | PHP compilation needs memory |
| Tenant | BUILD_GENERAL1_MEDIUM | 7 GB | Nuxt build needs memory |
| HQ | BUILD_GENERAL1_MEDIUM | 7 GB | Nuxt build needs memory |
| Migration | BUILD_GENERAL1_SMALL | 3 GB | Lightweight ECS task runner |
