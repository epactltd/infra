# **Technical Requirements Specification: ISO 27001 Compliant Multi-Tenant SaaS**

Version: 3.0 (Final Production Spec)  
Date: November 23, 2025  
Compliance Standard: ISO/IEC 27001:2022  
Target Architecture: AWS Fargate (Docker) on ARM64 (Always-On)

## **1\. Executive Summary**

This document defines the technical architecture for a multi-tenant SaaS application (Nuxt.js \+ Laravel). The architecture is designed for **ISO 27001 Compliance** with a specific focus on minimizing operational overhead for a small engineering team.

**Strategic Decision:** We utilize an **"Always-On" Pure Fargate architecture**. This eliminates OS patch management (a major ISO burden) while maintaining high availability. We explicitly reject "Scale-to-Zero" strategies to ensure professional grade global availability.

### **Key Architectural Decisions**

1. **Compute:** **AWS Fargate (Serverless)** for ALL workloads.  
   * *Rationale:* Transfers OS patching responsibility to AWS (ISO Control A.12.6).  
2. **Availability:** **Always-On (Min Replicas \= 2).**  
   * *Rationale:* Eliminates "Cold Start" latency and scaling lag.  
3. **Isolation:** Per-tenant S3 buckets with "Default Deny" policies.  
4. **Traffic Flow:** "Backend-for-Frontend" (BFF) pattern.  
   * *Rule:* Laravel is **never** exposed to the public internet. All traffic routes via Nuxt.

## **2\. Architecture Overview**

### **2.1 Traffic Flow Diagrams**

**A. Standard User Traffic (Browser)**

sequenceDiagram  
    participant User as Browser  
    participant CF as Cloudflare WAF  
    participant ALB as Public ALB  
    participant Nuxt as Nuxt (Fargate)  
    participant Laravel as Laravel (Fargate)  
    participant DB as RDS/Redis

    User-\>\>CF: HTTPS Request (app.domain.com / admin.domain.com)  
    CF-\>\>ALB: Forward Request  
    ALB-\>\>Nuxt: Route to Tenant or HQ Service (Based on Host)  
    Note right of Nuxt: SSR Rendering (Tenant or HQ)  
    Nuxt-\>\>Laravel: Internal HTTP Call (internal.local)  
    Laravel-\>\>DB: Query Data  
    Laravel--\>\>Nuxt: JSON Response  
    Nuxt--\>\>User: HTML/JSON Response

## **3\. AWS Infrastructure Requirements (Terraform)**

All infrastructure must be provisioned via Terraform (IaC).

### **3.1 Network Topology (VPC)**

* **Subnets:**  
  * Public Subnet A/B: Load Balancers, NAT Gateway.  
  * Private Subnet A/B: Fargate Tasks (Nuxt, Laravel, Workers).  
  * Data Subnet A/B: RDS, Redis.  
* **Gateways:**  
  * 1x **NAT Gateway** per AZ (Zone A & B). *Decision: Prioritize High Availability over cost savings.*  
  * **VPC Endpoints:** S3 (Gateway), ECR, CloudWatch, SSM. *Critical: Keeps S3 traffic off the NAT Gateway to reduce data transfer costs.*

### **3.2 Compute Services (AWS Fargate \- ARM64)**

All services run on **Graviton (ARM64)**.

| Service Name | Role | Specs | Scaling |
| :---- | :---- | :---- | :---- |
| **nuxt-tenant** | Client Frontend | 0.5 vCPU / 1GB | Min: 2, Max: 10 |
| **nuxt-hq** | Admin Frontend | 0.5 vCPU / 1GB | Fixed: 1 (Non-Scalable) |
| **laravel-api** | Backend (Octane) | 0.5 vCPU / 1GB | Min: 2, Max: 10 |
| **laravel-worker** | Queue Worker | 0.25 vCPU / 0.5GB | Min: 1, Max: 5 (Spot Allowed) |
| **laravel-scheduler** | Cron Replacement | 0.25 vCPU / 0.5GB | Fixed: 1 |

* **Reverb (WebSockets):** Run as a separate process within the laravel-api task or a dedicated service depending on load.

### **3.3 Data Layer**

* **Database:** AWS RDS MariaDB (db.t4g.small). Multi-AZ Enabled. Storage Encrypted (KMS).  
* **Cache:** AWS ElastiCache Redis (cache.t4g.micro). Multi-AZ Enabled. Auth Token Required.  
* **Storage:** S3 (Per-Tenant Buckets).  
  * **Lifecycle:** Transition to GLACIER after 90 days.  
  * **Versioning:** Enabled.

## **4\. Application Development Requirements**

### **4.1 Nuxt.js (Frontend) Changes**

1. **Proxy Configuration:**  
   * Configure Nitro to proxy /api/\* to https://internal-api.yourdomain.com/\*.  
   * **Must** forward Cookie, Authorization, and X-Forwarded-For headers.  
2. **Malware Awareness:**  
   * UI must handle "Pending Scan" state for file uploads.  
   * *Logic:* If file is uploaded but not yet marked "Clean", show a "Scanning..." spinner instead of the download link.

### **4.2 Laravel (Backend) Changes**

1. **Trusted Proxies:**  
   * Trust the internal ALB CIDR range to correctly resolve client IPs.  
2. **Octane Compatibility:**  
   * Ensure no state leaks between requests (use Octane::bind for singletons).  
3. **Pre-Signed URLs:**  
   * **Upload:** POST /files/upload-url \-\> returns S3 PUT URL.  
   * **Download:** GET /files/download-url \-\> returns S3 GET URL (only if ScanStatus=Clean).

## **5\. Security & Compliance Controls (ISO 27001\)**

### **5.1 Malware Scanning (A.12.2)**

* **Workflow:** S3 Event \-\> Lambda (ClamAV) \-\> Tag Object.  
* **Policy:** Bucket Policy explicitly denies GetObject unless tag ScanStatus=Clean exists.

### **5.2 Operational Security (A.12.1)**

* **SSH:** Disabled.  
* **Database Access:** STRICTLY via **AWS SSM Session Manager** port forwarding. No public access.  
* **Logging:** All app logs to stdout. Fargate routes to CloudWatch.

## **6\. Cost Estimate (Realistic Monthly)**

*Estimates for eu-west-2 (London) including support services.*

| Resource | Configuration | Est. Cost |
| :---- | :---- | :---- |
| **Fargate Compute** | Tenant (2x), HQ (1x), API (2x) \+ Workers | \~$50.00 |
| **Load Balancers** | 1 Public \+ 1 Internal ALB | \~$45.00 |
| **Database** | RDS MariaDB (t4g.small, Multi-AZ) | \~$68.00 |
| **Redis** | ElastiCache (t4g.micro, Multi-AZ) | \~$24.00 |
| **Networking** | 2 NAT Gateways \+ Data Transfer | \~$90.00 |
| **Security Edge** | Cloudflare (Pro) \+ AWS WAF | \~$30.00 |
| **Storage/Logs** | S3 \+ CloudWatch Ingestion | \~$20.00 |
| **Total** |  | \*\*\~$327.00 / month\*\* |

## **7\. Strategic "Escape Hatch" (Capacity Management)**

*ISO 27001 A.12.1.3 (Capacity Management) requires planning for future growth.*

**Trigger:** If monthly Fargate costs exceed **$1,500** (approx. 50x current traffic), or if Nuxt SSR CPU latency becomes unmanageable.

**Migration Plan:**

1. **Nuxt:** Move nuxt-ssr-service from Fargate to **EC2 Auto Scaling Group** (t4g.medium instances).  
2. **No Refactor:** The architecture remains identical (ALB \-\> Target Group). Only the *compute target* changes from "IP" (Fargate) to "Instance" (EC2).  
3. **Result:** This proves we are not "locked in" to Fargate's pricing model forever, satisfying risk management requirements.