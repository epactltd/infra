# Technical Requirements Specification: ISO 27001 Compliant Multi-Tenant SaaS

**Version:** 4.0 (Production Implementation)  
**Date:** December 2025  
**Compliance Standard:** ISO/IEC 27001:2022  
**Target Architecture:** AWS Fargate (Docker) on ARM64 (Always-On)

---

## 1. Executive Summary

This document defines the technical architecture for a multi-tenant SaaS application (Nuxt.js + Laravel). The architecture is designed for **ISO 27001 Compliance** with a specific focus on minimizing operational overhead for a small engineering team.

**Strategic Decision:** We utilize an **"Always-On" Pure Fargate architecture**. This eliminates OS patch management (a major ISO burden) while maintaining high availability. We explicitly reject "Scale-to-Zero" strategies to ensure professional grade global availability.

### Key Architectural Decisions

| Decision | Implementation | ISO Rationale |
|----------|---------------|---------------|
| **Compute** | AWS Fargate (Serverless) for ALL workloads | Transfers OS patching to AWS (A.12.6) |
| **Availability** | Always-On (Min Replicas = 2) | Eliminates cold start latency |
| **Isolation** | Per-tenant S3 buckets with "Default Deny" policies | Data segregation (A.8.3) |
| **Traffic Flow** | Backend-for-Frontend (BFF) pattern | Laravel never exposed publicly |
| **Secrets** | AWS Secrets Manager for all credentials | Secure credential management (A.9.4) |
| **Deployment** | Separate CI/CD pipelines per repository | Independent, auditable deployments |

---

## 2. Architecture Overview

### 2.1 High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Traffic Flow                                    │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   Users ──► Cloudflare ──► AWS WAF ──► Public ALB                           │
│                                            │                                 │
│                    ┌───────────────────────┼───────────────────────┐        │
│                    │                       │                       │        │
│                    ▼                       ▼                       ▼        │
│              Tenant (Nuxt)            HQ (Nuxt)              Reverb (WS)    │
│                    │                       │                                 │
│                    └───────────┬───────────┘                                 │
│                                │                                             │
│                         Internal ALB                                         │
│                                │                                             │
│                    ┌───────────┴───────────┐                                 │
│                    │                       │                                 │
│                    ▼                       ▼                                 │
│              API (Laravel)          Worker/Scheduler                         │
│                    │                       │                                 │
│                    └───────────┬───────────┘                                 │
│                                │                                             │
│                    ┌───────────┴───────────┐                                 │
│                    ▼                       ▼                                 │
│             RDS MariaDB            ElastiCache Redis                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Traffic Flow (Sequence)

```
Browser → Cloudflare WAF → Public ALB → Nuxt (SSR) → Internal ALB → Laravel API → RDS/Redis
                                  ↓
                            Reverb (WebSocket)
```

**Key Rules:**
- Laravel API is **never** exposed to the public internet
- All browser traffic routes through Nuxt (BFF pattern)
- WebSocket connections go directly to Reverb via Public ALB

---

## 3. AWS Infrastructure (Terraform)

All infrastructure is provisioned via Terraform. See `/infra/` for implementation.

### 3.1 Network Topology (VPC: 10.0.0.0/16)

| Subnet Type | CIDR (AZ-A) | CIDR (AZ-B) | Contains |
|-------------|-------------|-------------|----------|
| **Public** | 10.0.1.0/24 | 10.0.2.0/24 | NAT Gateway, Public ALB |
| **Private** | 10.0.11.0/24 | 10.0.12.0/24 | ECS Fargate tasks, Internal ALB |
| **Data** | 10.0.21.0/24 | 10.0.22.0/24 | RDS, ElastiCache |

**Network Components:**
- **NAT Gateways:** 2x (one per AZ for high availability)
- **VPC Endpoints:** S3 (Gateway), ECR, CloudWatch, SSM, Secrets Manager
- **Internet Gateway:** 1x (for public subnet egress)

### 3.2 Compute Services (ECS Fargate - ARM64)

All services run on **Graviton (ARM64)** for cost efficiency.

| Service | Container | Port | CPU/Memory | Scaling |
|---------|-----------|------|------------|---------|
| **Tenant** | Nuxt 3 SSR | 3000 | 0.5 vCPU / 1GB | 2-10 (CPU-based) |
| **HQ** | Nuxt 3 SSR | 3000 | 0.5 vCPU / 1GB | Fixed: 1 |
| **API** | Laravel Octane | 8000 | 0.5 vCPU / 1GB | 2-10 (CPU-based) |
| **Worker** | Laravel Queue | - | 0.25 vCPU / 0.5GB | 1-5 (Spot allowed) |
| **Scheduler** | Laravel Cron | - | 0.25 vCPU / 0.5GB | Fixed: 1 |
| **Reverb** | Laravel Reverb | 8080 | 0.25 vCPU / 0.5GB | Fixed: 1 |

### 3.3 Load Balancing

| ALB | Access | Listeners | Routing |
|-----|--------|-----------|---------|
| **Public** | Internet | HTTPS:443 | Host-based routing |
| **Internal** | VPC only | HTTP:80 | Path-based routing |

**Public ALB Routing Rules:**
- `Host: *.domain.com` → Tenant Target Group (port 3000)
- `Host: admin.domain.com` → HQ Target Group (port 3000)
- `Host: wss.domain.com` → Reverb Target Group (port 8080, sticky sessions)

### 3.4 Data Layer

| Service | Engine | Instance | Configuration |
|---------|--------|----------|---------------|
| **RDS** | MariaDB 10.11 | db.t3.medium | Multi-AZ, KMS encrypted, 7-day backups |
| **ElastiCache** | Redis 7 | cache.t3.micro | Multi-AZ, Auth token required |

### 3.5 Storage (S3)

| Bucket Pattern | Purpose | Security |
|----------------|---------|----------|
| `{project}-{env}-tenant-*` | Per-tenant files | KMS encryption, versioning, TLS-only |
| `{project}-{env}-pipeline-artifacts` | CI/CD artifacts | KMS encryption |

---

## 4. CI/CD Architecture

Three independent pipelines (one per repository) using AWS CodePipeline + CodeBuild.

### 4.1 Pipeline Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CI/CD Pipelines                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  API Repo ─────► Source → Build → Approval → Migrate → Deploy               │
│  (GitHub)                                        │         │                 │
│                                                  ▼         ▼                 │
│                                                 RDS    API, Worker,          │
│                                                        Scheduler, Reverb     │
│                                                                              │
│  Tenant Repo ──► Source → Build → Approval → Deploy → Tenant                │
│  (GitHub)                                                                    │
│                                                                              │
│  HQ Repo ──────► Source → Build → Approval → Deploy → HQ                    │
│  (GitHub)                                                                    │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Pipeline Stages

| Stage | API Pipeline | Tenant/HQ Pipeline |
|-------|--------------|-------------------|
| **Source** | GitHub Release trigger | GitHub Release trigger |
| **Build** | Docker image → ECR | Docker image → ECR |
| **Approval** | Manual (production) | Manual (production) |
| **Migrate** | `php artisan migrate --force` | N/A |
| **Deploy** | ECS rolling update | ECS rolling update |

### 4.3 Deployment Strategy

- **Rolling Deployment:** New tasks start before old tasks stop
- **Circuit Breaker:** Automatic rollback on health check failures
- **Image Tags:** Release tags (e.g., `v1.2.3`), not `latest`

---

## 5. Security & Compliance (ISO 27001)

### 5.1 Access Control (A.9)

| Control | Implementation |
|---------|---------------|
| A.9.1 Access Policy | IAM roles with least privilege |
| A.9.2 User Access | No SSH; use ECS Exec for debugging |
| A.9.4 Secrets | AWS Secrets Manager for all credentials |

### 5.2 Cryptography (A.10)

| Control | Implementation |
|---------|---------------|
| A.10.1 Encryption | KMS for S3, RDS, Redis, CI/CD artifacts |
| A.10.1 TLS | HTTPS only; TLS 1.2+ enforced |

### 5.3 Operations Security (A.12)

| Control | Implementation |
|---------|---------------|
| A.12.1 Procedures | Terraform IaC; CodePipeline automation |
| A.12.2 Malware | S3 event → Lambda scan → tag objects |
| A.12.4 Logging | CloudWatch Logs (90-day retention) |
| A.12.6 Patching | Fargate manages OS; ECR image scanning |

### 5.4 Malware Scanning Workflow

```
S3 Upload → EventBridge → Lambda (ClamAV) → Tag: ScanStatus=Clean
                                          ↓
                              Bucket Policy: Deny GET unless Clean
```

**Current Status:** MVP uses fail-open (auto-tag as Clean). Full ClamAV integration planned.

---

## 6. Application Requirements

### 6.1 Nuxt.js (Frontend)

1. **API Proxy:** Configure Nitro to proxy `/api/*` to Internal ALB
2. **Headers:** Forward `Cookie`, `Authorization`, `X-Forwarded-For`
3. **File Uploads:** Handle "Pending Scan" state with UI feedback
4. **WebSocket:** Connect to Reverb via `wss://wss.domain.com`

### 6.2 Laravel (Backend)

1. **Trusted Proxies:** Trust Internal ALB CIDR range
2. **Octane:** Ensure no state leaks (use `Octane::bind` for singletons)
3. **Pre-Signed URLs:**
   - Upload: `POST /files/upload-url` → S3 PUT URL
   - Download: `GET /files/download-url` → S3 GET URL (if `ScanStatus=Clean`)
4. **Reverb:** Configure for Redis broadcasting

---

## 7. Cost Estimate

*Estimates for eu-west-2 (London) region.*

| Resource | Configuration | Est. Monthly Cost |
|----------|---------------|-------------------|
| **Fargate Compute** | 6 services (Tenant x2, HQ, API x2, Worker, Scheduler, Reverb) | ~$150-200 |
| **Load Balancers** | 1 Public + 1 Internal ALB | ~$45-50 |
| **RDS MariaDB** | db.t3.medium, Multi-AZ | ~$70-90 |
| **ElastiCache Redis** | cache.t3.micro, Multi-AZ | ~$25-35 |
| **NAT Gateways** | 2x (one per AZ) + data transfer | ~$70-100 |
| **S3 + CloudWatch** | Storage, logs, metrics | ~$20-40 |
| **CI/CD** | CodePipeline, CodeBuild | ~$10-20 |
| **Total** | | **~$390-535 / month** |

---

## 8. Escape Hatch (Capacity Planning)

*ISO 27001 A.12.1.3 (Capacity Management) requires planning for growth.*

**Trigger:** Monthly Fargate costs exceed **$1,500** or SSR latency becomes unmanageable.

**Migration Path:**
1. Move Nuxt services from Fargate to **EC2 Auto Scaling Group** (Graviton instances)
2. No application refactor required (ALB Target Group change only)
3. Demonstrates we are not locked into Fargate pricing

---

## 9. Related Documentation

| Document | Description |
|----------|-------------|
| [Deployment Guide](./docs/deployment-guide.md) | Step-by-step AWS deployment |
| [Deployment Checklist](./docs/deployment-checklist.md) | Quick reference checklist |
| [CI/CD Setup](./docs/cicd-setup.md) | Pipeline configuration |
| [Infrastructure Diagrams](./docs/infrastructure.md) | Architecture diagrams |
| [Gap Analysis](./docs/terraform-gap-analysis.md) | Infrastructure improvements |

---

## 10. Revision History

| Version | Date | Changes |
|---------|------|---------|
| 4.0 | Dec 2025 | Added CI/CD pipelines, Reverb service, updated costs |
| 3.0 | Nov 2025 | Final production spec |
| 2.0 | Oct 2025 | Added Fargate architecture |
| 1.0 | Sep 2025 | Initial draft |
