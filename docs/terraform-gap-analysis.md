# Terraform Gap Analysis

**Document Version:** 1.1  
**Date:** December 2024  
**Purpose:** Comprehensive analysis of disconnects between the Envelope application architecture and the Terraform AWS infrastructure design.

> **Status Update (v1.1):** P0 and P1 Terraform fixes have been implemented. See [Implementation Summary](#implementation-summary) at the end of this document.

---

## Executive Summary

This document identifies gaps between:
- **Application Architecture** (defined in `docs/ARCHITECTURE.md` and `docker-compose.prod.yml`)
- **Terraform Infrastructure** (defined in `infra/modules/*` and `infra/main.tf`)
- **AWS Architecture Specification** (defined in `infra/aws-architecture.md`)

The analysis categorizes gaps by severity and provides remediation plans for each.

---

## Table of Contents

1. [Critical Gaps (P0)](#1-critical-gaps-p0)
2. [High Priority Gaps (P1)](#2-high-priority-gaps-p1)
3. [Medium Priority Gaps (P2)](#3-medium-priority-gaps-p2)
4. [Security/Compliance Gaps](#4-securitycompliance-gaps)
5. [Operational Gaps (P3)](#5-operational-gaps-p3)
6. [Remediation Priority Matrix](#6-remediation-priority-matrix)
7. [Implementation Checklist](#7-implementation-checklist)

---

## 1. Critical Gaps (P0)

These gaps will prevent the application from functioning correctly.

### 1.1 Missing Reverb/WebSocket Service

**Current State:**
- Application uses Laravel Reverb for WebSocket-based real-time features (port 8080)
- `docker-compose.prod.yml` defines a dedicated `reverb` service
- Real-time features include live notifications and broadcast events

**Terraform State:**
- No ECS task definition for Reverb
- No ECS service for Reverb
- No target group for WebSocket traffic
- No ALB listener or rule for port 8080

**Impact:** All real-time features will be unavailable.

**Remediation:**

1. Add Reverb task definition to `modules/ecs/main.tf`:
```hcl
resource "aws_ecs_task_definition" "reverb" {
  family                   = "${var.project_name}-${var.environment}-reverb"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.execution_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "ARM64"
  }

  container_definitions = jsonencode([
    {
      name    = "reverb"
      image   = "${var.api_repo_url}:${var.api_image_tag}"
      command = ["php", "artisan", "reverb:start", "--host=0.0.0.0", "--port=8080"]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "APP_ENV", value = var.environment },
        { name = "APP_KEY", value = var.app_key },
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_DATABASE", value = var.db_name },
        { name = "DB_USERNAME", value = var.db_username },
        { name = "REDIS_HOST", value = var.redis_host },
        { name = "REDIS_PORT", value = tostring(var.redis_port) },
        { name = "REVERB_HOST", value = "0.0.0.0" },
        { name = "REVERB_PORT", value = "8080" },
        { name = "REVERB_APP_KEY", value = var.reverb_app_key },
        { name = "REVERB_APP_SECRET", value = var.reverb_app_secret },
        { name = "REVERB_APP_ID", value = var.reverb_app_id }
      ]
      secrets = [
        { name = "DB_PASSWORD", valueFrom = var.db_password_arn },
        { name = "REDIS_PASSWORD", valueFrom = var.redis_auth_token_arn }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.reverb.name
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}
```

2. Add Reverb ECS service to `modules/ecs/services.tf`
3. Add Reverb target group and listener to `modules/alb/main.tf`
4. Add Reverb-related variables to `modules/ecs/variables.tf` and `variables.tf`

---

### 1.2 Environment Variable Mismatches

**Analysis:**

| Variable | docker-compose.prod.yml | Terraform ECS | Status |
|----------|-------------------------|---------------|--------|
| `BASE_URL` | `http://api:8000` | `NUXT_API_BASE_SERVER` | Different naming |
| `APP_URL` | Set on API | Missing | **Missing** |
| `TENANT_PRIMARY_DOMAIN` | Set on frontends | Missing | **Missing** |
| `BASE_DOMAIN` | Set on HQ | Missing | **Missing** |
| `REVERB_APP_KEY` | Set | Missing (no service) | **Missing** |
| `REVERB_APP_SECRET` | Set | Missing (no service) | **Missing** |
| `REVERB_APP_ID` | Set | Missing (no service) | **Missing** |
| `REVERB_HOST` (public) | Set on frontends | Missing | **Missing** |
| `REVERB_PORT` | Set on frontends | Missing | **Missing** |
| `RECAPTCHA_V2_SITEKEY` | Set on frontends | Missing | **Missing** |

**Impact:** 
- API URL generation will fail without `APP_URL`
- Frontend proxy will fail if `NUXT_API_BASE_SERVER` doesn't align with expected config
- WebSocket connections will fail without Reverb configuration

**Remediation:**

1. Update API task definition in `modules/ecs/main.tf`:
```hcl
environment = [
  # Existing vars...
  { name = "APP_URL", value = "https://${var.public_alb_dns_name}" },
]
```

2. Update Tenant task definition:
```hcl
environment = [
  # Existing vars...
  { name = "NUXT_PUBLIC_TENANT_PRIMARY_DOMAIN", value = var.tenant_primary_domain },
  { name = "NUXT_PUBLIC_REVERB_APP_KEY", value = var.reverb_app_key },
  { name = "NUXT_PUBLIC_REVERB_HOST", value = var.reverb_public_host },
  { name = "NUXT_PUBLIC_REVERB_PORT", value = "443" },
]
```

3. Update HQ task definition similarly.

---

### 1.3 S3 Architecture Mismatch (Bi-Directional Gap)

**Current Application Implementation:**

| Component | Implementation |
|-----------|----------------|
| Bucket Creation | `CreateTenantS3Bucket` job creates buckets directly via AWS SDK |
| File Uploads | `spatie/laravel-medialibrary` uploads directly to S3 |
| File Downloads | `getTemporaryUrl()` generates pre-signed URLs (works) |
| Malware Scanning | Not implemented |

**Terraform Design Expectation:**

| Component | Design |
|-----------|--------|
| Bucket Creation | EventBridge + Lambda on `tenant.created` event |
| File Uploads | Pre-signed PUT URLs from API endpoint |
| File Downloads | Only if `ScanStatus=Clean` tag exists |
| Malware Scanning | Lambda with ClamAV (currently stub) |

**Resolution Strategy:**

For MVP, we will:
1. **Keep the application's bucket creation approach** (direct via Laravel job)
2. **Add pre-signed URL endpoints** for uploads (security improvement)
3. **Update Lambda to fail-open** (tag as Clean without scanning)
4. **Document ClamAV as future work**

**Application Changes Required:**

1. **New Upload URL Endpoint** (`api/app/Http/Controllers/Tenant/FileController.php`):
```php
/**
 * Generate a pre-signed URL for S3 upload
 * POST /files/upload-url
 */
public function getUploadUrl(Request $request): JsonResponse
{
    $request->validate([
        'filename' => 'required|string|max:255',
        'content_type' => 'required|string',
    ]);

    $tenant = tenant();
    $bucket = $tenant->getS3Configs()['bucket'] ?? null;
    
    if (!$bucket) {
        return response()->json(['error' => 'Tenant S3 bucket not configured'], 400);
    }

    $key = sprintf(
        'uploads/%s/%s/%s',
        $tenant->getTenantKey(),
        Str::uuid(),
        $request->filename
    );

    $s3 = new S3Client([
        'version' => 'latest',
        'region' => config('filesystems.disks.s3.region'),
    ]);

    $command = $s3->getCommand('PutObject', [
        'Bucket' => $bucket,
        'Key' => $key,
        'ContentType' => $request->content_type,
    ]);

    $presignedRequest = $s3->createPresignedRequest($command, '+15 minutes');

    return response()->json([
        'upload_url' => (string) $presignedRequest->getUri(),
        'key' => $key,
        'expires_in' => 900, // 15 minutes
    ]);
}

/**
 * Generate a pre-signed URL for S3 download
 * GET /files/download-url/{document}
 */
public function getDownloadUrl(Request $request, Document $document): JsonResponse
{
    // For MVP: Skip scan check (fail-open)
    // Future: Check S3 object tag 'ScanStatus' === 'Clean'
    
    $url = $document->getTemporaryUrl(now()->addHours(1));
    
    return response()->json([
        'url' => $url,
        'expires_in' => 3600,
    ]);
}
```

2. **Frontend Changes** (both `tenant/` and `hq/`):
   - Modify file upload composables to request pre-signed URL first
   - PUT file directly to S3 using the pre-signed URL
   - Confirm upload by notifying backend

**Terraform Changes Required:**

1. **Update S3 Lambda to fail-open** (`modules/s3/main.tf`):
```python
# Replace the stub scanner with fail-open behavior
def lambda_handler(event, context):
    """
    MVP: Tag all uploaded files as Clean without scanning.
    TODO: Implement ClamAV scanning for production.
    """
    for record in event.get("Records", []):
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        
        s3.put_object_tagging(
            Bucket=bucket,
            Key=key,
            Tagging={'TagSet': [{'Key': 'ScanStatus', 'Value': 'Clean'}]}
        )
        print(f"Tagged s3://{bucket}/{key} as Clean (MVP: no actual scan)")
    
    return {"status": "success"}
```

2. **Add S3 data access IAM policy** (`modules/s3/main.tf`):
```hcl
resource "aws_iam_policy" "tenant_bucket_data_access" {
  name = "${var.project_name}-${var.environment}-tenant-bucket-data-access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:GetObjectTagging",
          "s3:PutObjectTagging"
        ],
        Resource = [
          "arn:aws:s3:::${local.tenant_bucket_prefix}*/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${local.tenant_bucket_prefix}*"
        ]
      }
    ]
  })
}
```

3. **Attach to ECS task role** (`modules/ecs/main.tf`):
```hcl
resource "aws_iam_role_policy_attachment" "task_role_s3_data" {
  role       = aws_iam_role.task_role.name
  policy_arn = var.tenant_bucket_data_access_policy_arn
}
```

---

## 2. High Priority Gaps (P1)

These gaps will cause failures during operation.

### 2.1 Health Check Endpoints May Not Exist

**Current Terraform Configuration:**

| Service | Health Check Path | Concern |
|---------|-------------------|---------|
| API | `/api/health` | Endpoint may not exist in Laravel |
| HQ | `/admin/` | May return 404 if route doesn't exist |
| Tenant | `/` | Should work |

**Verification Required:**
```bash
# Check if /api/health exists
docker exec envelope_api php artisan route:list | grep health

# Check available endpoints
docker exec envelope_api php artisan route:list --path=api
```

**Remediation:**

Option A: Add health endpoint to Laravel:
```php
// routes/api.php
Route::get('/health', function () {
    return response()->json(['status' => 'ok']);
});
```

Option B: Update Terraform to use existing endpoint:
```hcl
health_check {
  path = "/up"  # Laravel's default health endpoint
}
```

---

### 2.2 Worker Task Missing Environment Variables

**Missing Variables:**
- `SANCTUM_STATEFUL_DOMAINS`
- `SESSION_DOMAIN`
- `CORS_ALLOWED_ORIGINS`
- `APP_URL`

**Impact:** Queue jobs that interact with authentication or generate URLs may fail.

**Remediation:** Update worker task definition in `modules/ecs/main.tf`:
```hcl
environment = [
  # Existing vars...
  { name = "APP_URL", value = "https://${var.public_alb_dns_name}" },
  { name = "SANCTUM_STATEFUL_DOMAINS", value = var.sanctum_stateful_domains },
  { name = "SESSION_DOMAIN", value = var.session_domain },
  { name = "CORS_ALLOWED_ORIGINS", value = var.cors_allowed_origins },
]
```

---

### 2.3 Database Migration Strategy Undefined

**Current State:** No mechanism to run `php artisan migrate` on deployment.

**Options:**

1. **ECS Run Task (Recommended for simplicity):**
```bash
aws ecs run-task \
  --cluster envelope-prod-cluster \
  --task-definition envelope-prod-api \
  --network-configuration "..." \
  --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","migrate","--force"]}]}'
```

2. **Init Container Pattern:**
Add a sidecar container that runs migrations before the main container starts.

3. **CodeDeploy Hooks:**
Run migrations as a deployment lifecycle hook.

**Recommendation:** Use ECS run-task via CI/CD pipeline before updating the service.

---

## 3. Medium Priority Gaps (P2)

### 3.1 prod.tfvars.example Missing Variables

**Missing:**
- `hq_host` (required for ALB routing)
- `reverb_app_key`
- `reverb_app_secret`
- `reverb_app_id`
- `reverb_public_host`
- `tenant_primary_domain`

**Remediation:** Update `prod.tfvars.example` with all required variables.

---

### 3.2 Variable Validations Force Values for Optional Resources

**Issue:** `alb_web_acl_arn` and `alb_access_logs_bucket` have validations that require non-empty strings, but they're documented as optional.

**Current:**
```hcl
variable "alb_web_acl_arn" {
  validation {
    condition     = length(var.alb_web_acl_arn) > 0
    error_message = "Provide a WAF web ACL ARN."
  }
}
```

**Fix:**
```hcl
variable "alb_web_acl_arn" {
  description = "WAFv2 Web ACL ARN (optional)"
  type        = string
  default     = ""
  # Remove validation - make truly optional
}
```

---

### 3.3 Scheduler Uses Wrong Log Group

**Issue:** Scheduler reuses worker log group with different stream prefix.

**Fix:** Add dedicated log group:
```hcl
resource "aws_cloudwatch_log_group" "scheduler" {
  name              = "/ecs/${var.project_name}-${var.environment}-scheduler"
  retention_in_days = 30
}
```

---

## 4. Security/Compliance Gaps

### 4.1 Missing ISO 27001 Controls

Per `aws-architecture.md`, these controls are specified but not implemented in Terraform:

| Control | AWS Service | Status | ISO 27001 Reference |
|---------|-------------|--------|---------------------|
| Network Logging | VPC Flow Logs | **Missing** | A.12.4 |
| API Audit Trail | CloudTrail | **Missing** | A.12.4 |
| Threat Detection | GuardDuty | **Missing** | A.12.2 |
| Compliance Monitoring | AWS Config | **Missing** | A.18.2 |
| Security Posture | Security Hub | **Missing** | A.18.2 |
| Key Management | Customer-managed KMS | **Missing** | A.10.1 |
| Backup & Recovery | AWS Backup | **Missing** | A.12.3 |

**Remediation Priority:** P2 - Required for ISO 27001 certification but not for basic functionality.

**Implementation Outline:**

```hcl
# modules/security/compliance.tf

# VPC Flow Logs
resource "aws_flow_log" "main" {
  vpc_id          = var.vpc_id
  traffic_type    = "ALL"
  log_destination = aws_s3_bucket.flow_logs.arn
  # ...
}

# CloudTrail
resource "aws_cloudtrail" "main" {
  name           = "${var.project_name}-${var.environment}-trail"
  s3_bucket_name = aws_s3_bucket.cloudtrail.id
  # ...
}

# GuardDuty
resource "aws_guardduty_detector" "main" {
  enable = true
  # ...
}

# AWS Config
resource "aws_config_configuration_recorder" "main" {
  # ...
}

# Security Hub
resource "aws_securityhub_account" "main" {}
```

---

### 4.2 CloudWatch Alarms Not Defined

**Missing Alarms:**
- ALB 5xx error rate
- ECS CPU/Memory utilization
- RDS CPU utilization
- RDS storage space
- Redis memory utilization

**Remediation:**
```hcl
# modules/monitoring/alarms.tf

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.project_name}-${var.environment}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [aws_sns_topic.alerts.arn]
  # ...
}
```

---

## 5. Operational Gaps (P3)

### 5.1 No CI/CD Pipeline Definition

**Current State:** `deployment.md` references CodeDeploy but no Terraform provisions it.

**Recommendation:** Use GitHub Actions with:
1. Build Docker images on push to main
2. Push to ECR with immutable tags
3. Update ECS service with new task definition

---

### 5.2 ECR Image Tag Mutability

**Current:** `image_tag_mutability = "MUTABLE"`

**Recommendation for Production:** Use `IMMUTABLE` tags for reproducible deployments.

---

### 5.3 No Route53/DNS Configuration

**Current:** Manual DNS setup required.

**Recommendation:** Add Route53 module if domains are managed in AWS:
```hcl
resource "aws_route53_record" "tenant" {
  zone_id = var.hosted_zone_id
  name    = "*.${var.domain}"
  type    = "A"
  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
}
```

---

## 6. Remediation Priority Matrix

| Gap | Severity | Effort | Priority | Sprint |
|-----|----------|--------|----------|--------|
| Missing Reverb service | Critical | Medium | P0 | 1 |
| Environment variable mismatches | Critical | Low | P0 | 1 |
| S3 IAM policy for file operations | Critical | Low | P0 | 1 |
| S3 pre-signed URL workflow | Critical | Medium | P0 | 1 |
| Health check endpoints | High | Low | P1 | 1 |
| Worker environment variables | High | Low | P1 | 1 |
| Migration strategy | High | Medium | P1 | 1 |
| prod.tfvars.example updates | Medium | Low | P2 | 2 |
| Variable validation fixes | Medium | Low | P2 | 2 |
| Scheduler log group | Medium | Low | P2 | 2 |
| ISO 27001 controls | Medium | High | P2 | 2-3 |
| CloudWatch alarms | Medium | Medium | P2 | 2 |
| CI/CD pipeline | Low | High | P3 | 3 |
| ECR immutable tags | Low | Low | P3 | 3 |
| Route53 configuration | Low | Low | P3 | 3 |

---

## 7. Implementation Checklist

### Sprint 1: Critical & High Priority (P0/P1)

- [ ] **Reverb Service**
  - [ ] Add `aws_cloudwatch_log_group.reverb`
  - [ ] Add `aws_ecs_task_definition.reverb`
  - [ ] Add `aws_ecs_service.reverb`
  - [ ] Add `aws_lb_target_group.reverb`
  - [ ] Add ALB listener rule for WebSocket
  - [ ] Add Reverb variables to `variables.tf`
  - [ ] Update `prod.tfvars.example`

- [ ] **Environment Variables**
  - [ ] Add `APP_URL` to API task
  - [ ] Add `APP_URL` to Worker task
  - [ ] Add Reverb vars to API task
  - [ ] Add Reverb public vars to Tenant task
  - [ ] Add Reverb public vars to HQ task
  - [ ] Add `TENANT_PRIMARY_DOMAIN` to frontend tasks
  - [ ] Add missing vars to Worker task

- [ ] **S3 File Operations**
  - [ ] Create `tenant_bucket_data_access` IAM policy
  - [ ] Attach policy to ECS task role
  - [ ] Update Lambda to fail-open (tag as Clean)
  - [ ] Export policy ARN for ECS module

- [ ] **Health Checks**
  - [ ] Verify `/api/health` exists or add it
  - [ ] Update HQ health check path if needed

- [ ] **Migration Strategy**
  - [ ] Document ECS run-task approach
  - [ ] Add to deployment runbook

### Sprint 2: Medium Priority (P2)

- [ ] **Variable Fixes**
  - [ ] Remove/fix `alb_web_acl_arn` validation
  - [ ] Remove/fix `alb_access_logs_bucket` validation
  - [ ] Add `hq_host` to `prod.tfvars.example`

- [ ] **Logging**
  - [ ] Add dedicated scheduler log group

- [ ] **Monitoring**
  - [ ] Add SNS topic for alerts
  - [ ] Add ALB 5xx alarm
  - [ ] Add ECS CPU alarms
  - [ ] Add RDS alarms

### Sprint 3: Lower Priority (P2/P3)

- [ ] **ISO 27001 Controls**
  - [ ] Add VPC Flow Logs
  - [ ] Add CloudTrail
  - [ ] Add GuardDuty
  - [ ] Add AWS Config
  - [ ] Add Security Hub
  - [ ] Add customer-managed KMS keys
  - [ ] Add AWS Backup

- [ ] **Operational**
  - [ ] Set ECR to IMMUTABLE
  - [ ] Add Route53 records (if applicable)
  - [ ] Add CI/CD pipeline

---

## Appendix A: Files to Modify

| File | Changes |
|------|---------|
| `modules/ecs/main.tf` | Add Reverb task, fix env vars, add log group |
| `modules/ecs/services.tf` | Add Reverb ECS service |
| `modules/ecs/variables.tf` | Add Reverb variables, policy ARN variable |
| `modules/ecs/outputs.tf` | Export Reverb service details |
| `modules/alb/main.tf` | Add Reverb target group and listener |
| `modules/alb/variables.tf` | Add Reverb port variable |
| `modules/alb/outputs.tf` | Export Reverb target group ARN |
| `modules/s3/main.tf` | Add data access policy, update Lambda |
| `modules/s3/outputs.tf` | Export data access policy ARN |
| `main.tf` | Wire new variables and outputs |
| `variables.tf` | Add new variables, fix validations |
| `prod.tfvars.example` | Add all missing variables |

---

## Appendix B: Application Changes Required

| File | Changes |
|------|---------|
| `api/app/Http/Controllers/Tenant/FileController.php` | Add pre-signed URL endpoints |
| `api/routes/tenant.php` | Add routes for new endpoints |
| `tenant/composables/useFileUpload.ts` | Use pre-signed URL workflow |
| `hq/composables/useFileUpload.ts` | Use pre-signed URL workflow |

---

## Implementation Summary

The following P0/P1 fixes have been implemented in the Terraform configuration:

### Completed Terraform Changes

| Change | File(s) Modified | Status |
|--------|------------------|--------|
| **Reverb WebSocket Service** | `modules/ecs/main.tf`, `modules/ecs/services.tf` | Implemented |
| **Reverb Target Group & Listener** | `modules/alb/main.tf`, `modules/alb/outputs.tf` | Implemented |
| **Reverb Security Group** | `modules/security/main.tf`, `modules/security/outputs.tf` | Implemented |
| **Environment Variable Fixes** | `modules/ecs/main.tf` (all task definitions) | Implemented |
| **S3 Data Access IAM Policy** | `modules/s3/main.tf`, `modules/s3/outputs.tf` | Implemented |
| **S3 Lambda Fail-Open** | `modules/s3/main.tf` | Implemented |
| **Health Check Endpoint Fixes** | `modules/alb/main.tf` | Implemented |
| **Variable Validation Fixes** | `variables.tf` | Implemented |
| **Scheduler Log Group** | `modules/ecs/main.tf` | Implemented |
| **New Variables Added** | `variables.tf`, `modules/ecs/variables.tf`, `modules/alb/variables.tf` | Implemented |
| **prod.tfvars.example Updated** | `prod.tfvars.example` | Implemented |
| **AWS Provider Compatibility Fixes** | `modules/ecs/services.tf`, `modules/rds/main.tf` | Implemented |

### New Required Variables

The following new variables must be set in your `.tfvars` file:

```hcl
# Application
app_url               = "https://api.yourdomain.com"
tenant_primary_domain = "yourdomain.com"

# Reverb / WebSocket
reverb_host           = "wss.yourdomain.com"
reverb_public_host    = "wss.yourdomain.com"
reverb_app_id         = "your-reverb-app-id"
reverb_app_key        = "your-reverb-key"
reverb_app_secret     = "your-reverb-secret"
```

### Remaining Work (P2/P3)

1. **ISO 27001 Compliance Controls** - VPC Flow Logs, CloudTrail, GuardDuty, AWS Config, Security Hub
2. **CloudWatch Alarms** - ALB 5xx, ECS CPU, RDS metrics
3. **Application Changes** - Pre-signed URL upload workflow (see Appendix B)

### Validation

```bash
cd infra
terraform fmt -recursive
terraform validate
# Success! The configuration is valid.
```

---

*Document maintained by: Infrastructure Team*  
*Last updated: December 2024*
