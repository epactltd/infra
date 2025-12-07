# Operations Security Policy

**EPACT LTD**  
Company Registration: 11977631  
International House, 36-38 Cornhill, London, England, EC3V 3NG

---

## Document Control

| **Version** | 1.0 |
|------------|-----|
| **Approved By** | Akam Rahimi, Managing Director |
| **Approval Date** | [TO BE COMPLETED] |
| **Effective Date** | [TO BE COMPLETED] |
| **Next Review Date** | [12 months from approval] |
| **Owner** | Senior Developer |
| **Reviewer** | Akam Rahimi, ISMS Lead |
| **Contact** | akam@epact.co.uk |
| **ISO 27001 Reference** | A.8.1, A.8.7, A.8.8, A.8.15, A.8.16, A.8.19 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy establishes requirements for the secure operation of EPACT LTD's information systems and infrastructure, ensuring reliable, secure, and compliant operations.

### 1.2 Scope
- All operational activities related to information systems
- AWS cloud infrastructure (VPC, EC2, RDS, S3, Lambda, etc.)
- Application systems and databases
- Terraform Infrastructure-as-Code management
- Development, staging, and production environments
- Monitoring, logging, and alerting systems
- Backup and recovery operations

---

## 2. Change Management

### 2.1 Change Categories

| **Type** | **Approval** | **Testing** | **Examples** |
|---------|-------------|------------|-------------|
| **Emergency** | ISMS Lead (verbal); documented post-change | Post-implementation | Security incident remediation, critical outage fix |
| **Standard** | Senior Developer | Dev/staging required | Application updates, minor config changes |
| **Major** | Managing Director + ISMS Lead | Full UAT required | Infrastructure changes, database schema, new services |
| **Normal** | Automated (CI/CD) | Automated tests pass | Application code deployments to non-production |

### 2.2 Change Request Process

**Step 1: Request Submission**
- Change request form completed
- Business justification documented
- Risk assessment performed (impact, rollback plan)
- Testing plan defined
- Implementation window proposed (maintenance window for major changes)

**Step 2: Review and Approval**
- Technical review by Senior Developer
- Security review by ISMS Lead (for infrastructure changes)
- Managing Director approval for major changes
- Change Advisory Board (CAB) for high-risk changes

**Step 3: Implementation**
- Pre-change backup (RDS snapshot, Terraform state snapshot)
- Implement during approved window
- Follow documented implementation plan
- Monitor for issues

**Step 4: Verification and Closure**
- Post-change testing
- Verify no unintended impacts
- Document actual vs. planned outcomes
- Update CMDB (configuration management database)
- Close change request

### 2.3 Terraform Infrastructure Changes

**Standard Workflow**:
```bash
# 1. Create feature branch
git checkout -b feature/add-cloudwatch-alarm

# 2. Make changes to Terraform code
vim modules/monitoring/main.tf

# 3. Validate locally
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan

# 4. Submit pull request (PR)
git commit -m "Add CloudWatch alarm for Lambda errors"
git push origin feature/add-cloudwatch-alarm

# 5. Peer review required (Senior Developer or ISMS Lead)
# - Review Terraform plan output
# - Check for security implications
# - Verify follows best practices

# 6. Approval and merge
# - Approver merges PR
# - CI/CD pipeline runs terraform plan

# 7. Production apply
# - Manual: terraform apply tfplan
# - Automated: After approval in CI/CD pipeline
# - ISMS Lead approval for major changes

# 8. Verify changes
terraform show
aws <service> describe-<resource>
# Check CloudWatch/logs for errors
```

**Prohibited Actions**:
- Direct production changes without Terraform
- Manual resource creation in production (must be in Terraform)
- `terraform destroy` in production (requires Managing Director approval)
- Force push to main branch

### 2.4 Emergency Changes
**Criteria**: System outage or active security incident

**Procedure**:
1. Verbal approval from ISMS Lead (or Managing Director if unreachable)
2. Implement minimum change to restore service
3. Document all actions taken
4. Post-implementation review within 24 hours
5. Retrospective change request created
6. Lessons learned documented

**Examples**:
- Security group rule to block active attack
- WAF rule to mitigate DDoS
- Rotate compromised credentials
- Restore from backup during outage

---

## 3. Environment Separation

### 3.1 Environment Definitions

| **Environment** | **Purpose** | **Data** | **Access** | **AWS Account** |
|----------------|-----------|---------|-----------|-----------------|
| **Production** | Live customer services | Real customer data (RESTRICTED) | ISMS Lead, Managing Director | epact-prod-xxxx |
| **Staging** | Pre-production testing | Pseudonymized data | Development team | epact-staging-xxxx |
| **Development** | Development and testing | Synthetic/test data only | All developers | epact-dev-xxxx |

### 3.2 Environment Isolation
- **Separate AWS accounts**: Recommended (or separate VPCs minimum)
- **No cross-environment access**: Developers cannot access production data
- **Network isolation**: Security groups prevent cross-environment traffic
- **Terraform workspaces**: Separate state files per environment
- **Naming conventions**: Resources tagged with Environment = dev/staging/prod

### 3.3 Data in Non-Production
**Prohibited**: Production personal data in development/staging

**Allowed**:
- Synthetic test data
- Pseudonymized data (PII removed or hashed)
- Anonymized data
- Explicit consent from data subjects (rare; documented)

**Production Data Refresh**:
- If needed, use pseudonymization tool
- Remove all PII before copy
- Document copies in data processing register
- Delete after testing complete (max 30 days)

---

## 4. Capacity and Performance Management

### 4.1 Capacity Planning
**Quarterly reviews** of:
- EC2 Auto Scaling Group utilization (min/max/desired capacity)
- RDS instance sizing (CPU, memory, storage, IOPS)
- S3 storage growth trends
- NAT Gateway throughput
- CloudWatch Logs storage

**Triggers for Scaling**:
- Sustained CPU >70% for 3 consecutive days
- RDS storage >80% utilized
- Expected business growth (customer onboarding)
- Performance degradation trends

**Actions**:
- Update Terraform variables (instance_type, max_size, etc.)
- Test in staging environment
- Schedule change during maintenance window
- Monitor post-change performance

### 4.2 Performance Monitoring
**CloudWatch Metrics Tracked**:
- ALB response time and request count
- EC2 CPU utilization (per instance and ASG aggregate)
- RDS CPU, IOPS, storage, connections
- Lambda duration and error rates
- S3 request metrics

**Performance Baselines**:
- ALB response time <200ms (p95)
- EC2 CPU utilization 40-70% (normal range)
- RDS CPU <60% (normal); alert at >80%
- Lambda duration <1000ms for tenant provisioning

**Alarms** (see monitoring module):
- ALB 5xx errors >10 in 5 minutes
- ASG CPU >80% (triggers scale-up)
- ASG CPU <30% (triggers scale-down after 3 periods)
- RDS CPU >80%
- Lambda errors >1

---

## 5. Malware Protection

### 5.1 EC2 Instance Protection
**Controls**:
- **AWS GuardDuty**: Malware detection on EBS volumes
- **OS-level antivirus**: [Specify if deployed - ClamAV, commercial solution]
- **Application whitelisting**: Only approved software installed
- **Immutable infrastructure**: Instances rebuilt from approved AMIs; not patched in place
- **No user file uploads**: To EC2 instances directly; use S3 instead

**AMI Hardening**:
- Based on CIS-hardened base images
- Minimal packages installed
- Unnecessary services disabled
- Latest security patches applied
- AMI re-built monthly with patches

### 5.2 S3 Malware Scanning
- **GuardDuty S3 Protection**: Enabled for malware detection
- **Upload scanning**: Consider S3 antivirus scanning Lambda (future enhancement)
- **File type restrictions**: Application enforces allowed file types
- **User-uploaded content**: Stored in isolated S3 buckets; scanned before processing

### 5.3 Application-Level Protection
- **Input validation**: All user input sanitized
- **Output encoding**: Prevent XSS attacks
- **Dependency scanning**: Automated checks for vulnerable libraries (npm audit, pip audit)
- **OWASP Top 10**: Developers trained and code reviewed
- **WAF**: Protects against common exploits

### 5.4 Incident Response
If malware detected:
1. Isolate affected instance (security group modification)
2. Alert via GuardDuty → SNS → ISMS Lead
3. Create snapshot for forensics
4. Terminate infected instance
5. Launch clean replacement from approved AMI
6. Investigate infection vector
7. Update detection rules
8. Assess if data breach occurred

---

## 6. Backup Management

### 6.1 Backup Strategy
**See also**: Backup and Restore Runbook (docs/backup-restore-runbook.md)

**Daily Backups** (05:00 UTC):
- RDS database: Via AWS Backup
- EC2 instances: Tagged with Backup=true
- Tenant S3 buckets: Tagged with Backup=true
- **Retention**: 30 days + 90-day copy

**Weekly Backups** (Sunday 06:00 UTC):
- Same resources as daily
- **Retention**: 365 days with cold storage transition after 30 days

**RDS Native Backups** (03:00-04:00 UTC):
- Automated daily snapshots
- **Retention**: 7 days
- **Purpose**: Quick restore for operational issues

### 6.2 Backup Verification
**Automated**:
- AWS Backup job status monitored
- CloudWatch alarms for backup failures
- SNS notifications for failed jobs

**Manual** (Quarterly):
- Random backup selected
- Restored to staging environment
- Data integrity verified
- Application smoke tests run
- Restoration time measured (verify meets RTO)
- Procedure documented in test log

### 6.3 Backup Security
- **Encryption**: All backups encrypted with KMS (backup_kms_key_arn)
- **Access control**: AWS Backup vault access restricted to ISMS Lead
- **Immutability**: Consider AWS Backup Vault Lock (prevents deletion)
- **Logging**: CloudTrail logs all backup vault access
- **Separation**: Backups in separate AWS Backup vault from production

### 6.4 Backup Retention
- Aligned with data retention policy
- Automated expiry per AWS Backup lifecycle rules
- Exception: Legal hold for litigation or investigations
- Secure deletion after retention period

---

## 7. Logging and Monitoring

### 7.1 Logging Requirements

**All systems must log**:
- Authentication attempts (success and failure)
- Authorization decisions (access granted/denied)
- System and application errors
- Configuration changes
- Administrative actions
- Data access (especially RESTRICTED data)

**Log Contents** (minimum):
- Timestamp (UTC)
- User identity (username, IAM role, IP address)
- Action performed
- Resource accessed
- Outcome (success/failure/error code)
- Source (IP, hostname, service)

### 7.2 AWS Logging Implementation

**CloudTrail** (API audit logging):
- **Scope**: All AWS API calls across all services
- **Retention**: 365 days in S3 (with lifecycle: 90d→Glacier)
- **Encryption**: KMS (security_kms_key)
- **Integrity**: Log file validation enabled
- **Alerts**: CloudWatch alarms for suspicious API calls (root usage, unauthorized access)

**VPC Flow Logs**:
- **Scope**: All network traffic in VPC
- **Retention**: 365 days (30d→IA→90d→Glacier→365d expire)
- **Format**: Standard fields + action (ACCEPT/REJECT)
- **Storage**: S3 bucket (flow_logs) with KMS encryption
- **Analysis**: Ad-hoc queries for incident investigation

**CloudWatch Logs**:
- **Application logs**: /aws/multi-tenant-app/{environment}/application (90-day retention)
- **Lambda logs**: /aws/lambda/{function-name} (90-day retention, KMS encrypted)
- **RDS logs**: Error, general, and slow-query logs (30-day retention)
- **Centralization**: All logs accessible via CloudWatch Logs Insights

**ALB Access Logs**:
- **Retention**: 365 days (30d→IA→90d→Glacier→365d expire)
- **Storage**: S3 bucket (alb_logs) with KMS encryption
- **Content**: Client IP, request, response code, latency
- **Analysis**: Periodic review for security patterns

### 7.3 Log Protection
- **Immutability**: S3 Object Lock for critical logs (CloudTrail)
- **Encryption**: KMS encryption for all logs
- **Access control**: Read-only access via IAM policies
- **Backup**: Logs included in S3 backup strategy
- **Retention**: Enforced via S3 lifecycle policies

### 7.4 Log Review
**Automated**:
- CloudWatch alarms for critical events
- GuardDuty threat detection
- Security Hub compliance findings

**Manual**:
- Weekly: GuardDuty and Security Hub findings review
- Monthly: CloudTrail review for privileged account activity
- Quarterly: Comprehensive log analysis and trend review
- Ad-hoc: Incident investigations

**Review Documentation**:
- Log review findings recorded
- Anomalies investigated
- Actions tracked to completion

---

## 8. Vulnerability Management

### 8.1 Vulnerability Scanning

**Infrastructure Scanning**:
- **AWS Inspector**: Monthly scans of EC2 instances (network + host assessments)
- **Security Hub**: Continuous compliance checks
- **AWS Config**: Configuration compliance monitoring
- **Manual reviews**: Quarterly security group and IAM policy audits

**Application Scanning**:
- **SAST (Static)**: Code analysis during development (SonarQube, Semgrep)
- **DAST (Dynamic)**: Running application testing (OWASP ZAP, Burp Suite)
- **Dependency scanning**: Automated (npm audit, pip audit, Dependabot)
- **Container scanning**: If using Docker (ECR image scanning)

**Infrastructure-as-Code Scanning**:
- **Terraform**: Checkov, tfsec, terraform validate
- **Pre-commit hooks**: Automated scanning before commit
- **CI/CD pipeline**: Fail build on critical vulnerabilities

**Frequency**:
- Automated scans: Continuous (CI/CD pipeline)
- AWS Inspector: Monthly
- Penetration testing: Annually (external firm)
- Internal vulnerability assessments: Quarterly

### 8.2 Vulnerability Remediation

**Severity Levels and Response Times**:

| **Severity** | **CVSS Score** | **Remediation Timeline** | **Approval** |
|-------------|---------------|-------------------------|-------------|
| **Critical** | 9.0 - 10.0 | 7 days | Emergency change (ISMS Lead) |
| **High** | 7.0 - 8.9 | 30 days | Standard change (Senior Developer) |
| **Medium** | 4.0 - 6.9 | 90 days | Standard change |
| **Low** | 0.1 - 3.9 | Next quarterly patch cycle | Bundled change |

**Exceptions**:
- No known exploit: May extend timeline with ISMS Lead approval
- Compensating controls: Reduce effective severity (e.g., WAF blocks exploit)
- Vendor patch not available: Document workaround; monitor for patch release

**Remediation Tracking**:
- Vulnerability register maintained (separate from risk register)
- Each vulnerability assigned owner and due date
- Progress reviewed in weekly operations meetings
- Overdue vulnerabilities escalated to Managing Director

### 8.3 Patch Management

**Operating System Patches** (EC2 instances):
- **Critical security patches**: Within 7 days of release
- **Standard updates**: Monthly patch cycle (second Tuesday)
- **Method**: Rebuild AMI with patches; rolling update via ASG
- **Testing**: New AMI tested in development/staging before production

**Application Dependencies**:
- **Monthly**: Review for updates
- **Security patches**: Within 7 days for critical vulnerabilities
- **Method**: Update package.json / requirements.txt; test; deploy
- **Testing**: Automated test suite must pass

**Database Patches** (RDS):
- **Auto minor version upgrade**: Enabled (during maintenance window)
- **Major version upgrades**: Tested in staging; scheduled change request
- **Maintenance window**: Sunday 02:00-03:00 UTC (low-traffic period)

**Infrastructure Services** (AWS-managed):
- Patching managed by AWS
- Review AWS security bulletins for action items
- Update Terraform if service versions need pinning

---

## 9. Configuration Management

### 9.1 Configuration Baselines
**Standard configurations** defined for:
- **AMIs**: CIS-hardened base images
- **Security groups**: Terraform-defined; no manual changes
- **IAM policies**: Least privilege templates
- **RDS parameters**: Optimized for security and performance
- **S3 bucket configurations**: Encryption, versioning, public access block, lifecycle

**Configuration Documentation**:
- Terraform code in Git (single source of truth)
- README files for each module
- Architecture diagrams (docs/infrastructure.md)
- Runbooks for operations

### 9.2 Configuration Compliance
**AWS Config Rules**:
- S3 buckets encrypted
- S3 public access blocked
- RDS encryption enabled
- CloudTrail enabled
- MFA enabled for IAM users
- Root account MFA enabled
- Security groups no unrestricted ingress (0.0.0.0/0 on high-risk ports)

**Non-Compliance Handling**:
1. AWS Config detects non-compliant resource
2. Security Hub aggregates finding
3. SNS alert sent to Support team
4. Investigation within 24 hours
5. Remediation or exception approval
6. Compliance verified

### 9.3 Configuration Change Control
- All production configuration changes via Terraform
- Configuration drift detected via Terraform plan
- Drift remediation: Revert to Terraform-defined state
- Manual changes: Prohibited except emergencies (must be documented and retro-fitted into Terraform)

---

## 10. Secure System Administration

### 10.1 Administrative Access
**Methods** (in order of preference):
1. **AWS Systems Manager Session Manager**: Browser-based or CLI access to EC2; no SSH keys; fully logged
2. **AWS Console**: With MFA; temporary credentials
3. **AWS CLI**: With MFA and temporary session tokens
4. **SSH**: Prohibited in production; development only with justification

**Administrative Actions Requiring MFA**:
- AWS console login
- Terraform apply to production
- RDS database access
- S3 bucket policy modifications
- IAM policy changes
- Security group modifications

### 10.2 Privileged Account Management
- Separate admin accounts (admin.firstname.lastname)
- Hardware MFA tokens for administrators
- Privileged sessions logged to CloudTrail and CloudWatch
- Session timeout: 15 minutes of inactivity
- Sudo/admin actions require justification in change request

### 10.3 Remote Administration
- VPN required for administration from external networks
- MFA enforced on VPN
- Admin actions from approved IP ranges only (CloudWatch alarm if violated)
- Screen sharing prohibited during admin sessions (security risk)

---

## 11. Protection Against Malware

### 11.1 Prevention
- **Email filtering**: Anti-spam and malware scanning at email gateway
- **Web filtering**: Block known malicious sites
- **Application whitelisting**: Only approved software on endpoints
- **Least privilege**: Limit ability to install unauthorized software
- **Security awareness**: Phishing training for all staff

### 11.2 Detection
- **AWS GuardDuty**: Detects EC2 malware, cryptocurrency mining, C2 communication
- **Endpoint protection**: [Specify if deployed - Windows Defender, CrowdStrike, etc.]
- **File integrity monitoring**: Detect unauthorized changes to critical files
- **Behavioral analysis**: GuardDuty machine learning detects anomalies

### 11.3 Response
See Incident Management Policy for malware incident procedures.

**Immediate actions**:
1. Isolate infected system
2. Alert ISMS Lead
3. Preserve evidence (snapshot)
4. Identify malware type and C2 servers
5. Block C2 IPs at WAF/security group
6. Terminate infected instance
7. Launch clean replacement
8. Scan for lateral movement
9. Root cause analysis

---

## 12. System and Application Hardening

### 12.1 EC2 Instance Hardening
**CIS Benchmark Compliance**:
- Disable unnecessary services
- Remove default accounts
- Configure secure SSH (if enabled): Key-only; no password authentication
- Enable OS firewall (iptables/firewalld)
- Regular security updates
- Auditd logging enabled
- File integrity monitoring (AIDE or Tripwire)

**EPACT Standards**:
- IMDSv2 enforced (http_tokens=required in launch template)
- EBS encryption enabled
- No public IP addresses (instances in private subnets)
- CloudWatch agent installed for detailed monitoring
- SSM agent installed for Session Manager access

### 12.2 RDS Database Hardening
- **Encryption**: At rest with KMS; in transit with TLS
- **Access**: Private subnet only; security group restricts to application tier
- **No public access**: publicly_accessible = false
- **Parameter group**: Custom settings for security:
  - slow_query_log = 1 (detect performance issues)
  - log_output = FILE
  - require_secure_transport = ON (TLS required)
- **Performance Insights**: Enabled with KMS encryption
- **Automated backups**: 7-day retention minimum

### 12.3 S3 Bucket Hardening
**Standard configuration** (enforced via Terraform):
- Encryption: Server-side with KMS
- Versioning: Enabled
- Public access: Blocked (all four settings)
- Bucket policy: TLS-only (deny aws:SecureTransport=false)
- Lifecycle policy: Defined per bucket purpose
- Access logging: Enabled for sensitive buckets
- Object Lock: For compliance-critical buckets (CloudTrail)

### 12.4 Application Security
- **HTTPS only**: HTTP redirects to HTTPS (ALB listener)
- **Security headers**: HSTS, X-Frame-Options, X-Content-Type-Options, CSP
- **Session management**: Secure, HttpOnly, SameSite cookies
- **CSRF protection**: Tokens for state-changing operations
- **SQL injection protection**: Parameterized queries, ORMs
- **XSS protection**: Output encoding, CSP
- **Authentication**: Bcrypt/Argon2 password hashing; MFA for admins

---

## 13. Network Security Operations

### 13.1 Security Group Management
**Principles**:
- **Default deny**: No rules = no traffic
- **Least privilege**: Only necessary ports/protocols
- **Source restriction**: Limit to specific security groups or CIDR blocks (not 0.0.0.0/0 except ALB)
- **Documentation**: Comments in Terraform for each rule justification

**Standard Security Groups**:
1. **ALB Security Group**:
   - Inbound: 443 (HTTPS), 80 (HTTP) from 0.0.0.0/0
   - Outbound: All (to application tier)

2. **Application Security Group**:
   - Inbound: 80, 443 from ALB security group only
   - Inbound: 22 (SSH) from 10.0.0.0/16 only (internal VPC; SSM Session Manager preferred)
   - Outbound: All (for NAT Gateway egress)

3. **RDS Security Group**:
   - Inbound: 3306 (MySQL) from application security group only
   - Outbound: None

**Security Group Changes**:
- Via Terraform only (no console changes)
- Peer review required
- Testing in non-production first
- Documentation updated

### 13.2 WAF Rule Management
**AWS WAF Rules**:
1. **AWS Managed Rules - Core Rule Set**: Blocks common exploits (SQLi, XSS)
2. **Rate Limiting**: 2000 requests per IP per 5 minutes
3. **Custom rules**: Added based on attack patterns

**WAF Tuning**:
- Review WAF logs weekly
- Adjust rate limits based on legitimate traffic patterns
- Add custom rules for observed attacks
- Test rule changes in staging WAF first

**Monitoring**:
- CloudWatch metrics for blocked requests
- Sample requests logged
- Monthly WAF effectiveness review

### 13.3 DDoS Protection
- **AWS Shield Standard**: Included with AWS; always active
- **Auto Scaling**: Handles legitimate traffic spikes
- **WAF rate limiting**: Blocks excessive requests per IP
- **CloudWatch alarms**: Detect abnormal traffic patterns
- **Incident response**: Escalate to AWS Support if large-scale attack

---

## 14. Data Loss Prevention (DLP)

### 14.1 Technical Controls
- **Encryption**: Prevents data exfiltration in clear text
- **S3 bucket policies**: TLS-only; prevent unauthorized access
- **IAM policies**: Restrict S3 downloads to authorized roles
- **GuardDuty**: Detects unusual S3 API activity (potential exfiltration)
- **VPC endpoints**: S3 access via private endpoint (future enhancement)

### 14.2 Monitoring for Data Exfiltration
**GuardDuty Findings**:
- Exfiltration:S3/ObjectRead.Unusual
- UnauthorizedAccess:S3/TorIPCaller
- Impact:S3/MaliciousIPCaller

**CloudWatch Metrics**:
- Large S3 downloads (>1GB)
- Bulk database exports
- Unusual API call volumes

**Response**: Incident investigation per Incident Management Policy

### 14.3 Data Handling Controls
- **Email DLP**: Scan outbound emails for sensitive data (if implemented)
- **USB restrictions**: Disabled on workstations; endpoint protection
- **Screen sharing**: Watermarks for confidential sessions
- **Print restrictions**: Confidential documents not printable or watermarked

---

## 15. Segregation of Duties

### 15.1 Critical Operations Requiring Separation

| **Operation** | **Requester** | **Approver** | **Implementer** | **Verifier** |
|--------------|--------------|-------------|----------------|-------------|
| Production infrastructure change | Developer | ISMS Lead | Senior Developer | Support team |
| IAM policy creation/modification | Requester | ISMS Lead | ISMS Lead | Managing Director (quarterly review) |
| Backup restoration | Support | ISMS Lead | ISMS Lead or Senior Developer | Senior Developer |
| User access provisioning (privileged) | Line manager | ISMS Lead | Support team | ISMS Lead (quarterly access review) |
| Security incident response | Detector | ISMS Lead (IRT Manager) | IRT Technical Lead | ISMS Lead (post-incident review) |

### 15.2 Enforcement
- Terraform state locking prevents concurrent changes
- AWS IAM policies prevent single-person critical actions
- Pull request reviews required (cannot approve own PR)
- Change management system enforces approvals

---

## 16. Resource Management

### 16.1 Compute Resources (EC2)
- **Auto Scaling**: Configured with min (2), max (10), desired (2)
- **Instance types**: Standardized (t3.medium default; t3.large for production)
- **AMI management**: Approved AMI list maintained; rebuilt monthly
- **Tagging**: All instances tagged (Environment, Project, ManagedBy, Backup)
- **Lifecycle**: Instances replaced monthly (immutable infrastructure)

### 16.2 Storage Resources (S3)
- **Bucket naming**: Follows convention (multi-tenant-app-{purpose}-{env}-{account-id})
- **Lifecycle policies**: Configured for cost optimization and retention compliance
- **Versioning**: Enabled for data protection
- **Monitoring**: S3 request metrics and CloudWatch alarms

### 16.3 Database Resources (RDS)
- **Instance sizing**: Based on capacity planning (quarterly reviews)
- **Storage**: Auto-scaling enabled; alert at 80% utilization
- **Read replicas**: Consider for read-heavy workloads
- **Maintenance window**: Sunday 02:00-03:00 UTC

### 16.4 Cost Management
- **Budget alerts**: CloudWatch billing alarms at 80%, 100%, 120% of monthly budget
- **Resource tagging**: Enables cost allocation reporting
- **Rightsizing**: Quarterly review of over/under-utilized resources
- **Reserved Instances**: Consider for predictable workloads

---

## 17. Operational Procedures

### 17.1 Standard Operating Procedures (SOPs)
Documented procedures for:
- Deploying infrastructure with Terraform
- Application deployment (see deployment.md)
- Backup and restoration (see backup-restore-runbook.md)
- Incident response (see Incident Management Policy)
- User account provisioning/de-provisioning
- Monitoring and alerting response
- DR testing (see disaster-recovery-test.md)

**SOP Requirements**:
- Step-by-step instructions
- Screenshots or command examples
- Expected outcomes
- Troubleshooting tips
- Approval and review dates
- Maintained in docs/ directory

### 17.2 Runbook Maintenance
- **Owner**: Senior Developer maintains runbooks
- **Review**: After each execution; update if procedures changed
- **Version control**: Runbooks in Git repository
- **Testing**: Procedures tested during DR exercises

---

## 18. Operational Monitoring

### 18.1 System Health Monitoring
**CloudWatch Dashboard** includes:
- ALB response time and request count
- EC2 CPU, memory, disk utilization
- RDS CPU, connections, IOPS, storage
- Lambda invocations, duration, errors
- S3 bucket request metrics

**Review**:
- Real-time: Support team monitors dashboard during business hours
- Daily: Health check review each morning
- Weekly: Trend analysis and capacity planning
- Monthly: Performance review with Development team

### 18.2 Security Monitoring
**Real-Time Alerts** (SNS to akam@epact.co.uk):
- GuardDuty high/critical findings
- Security Hub compliance failures
- CloudWatch alarms (ALB 5xx, CPU high, RDS CPU)
- Lambda errors
- Unauthorized API calls (CloudTrail alarms)

**Scheduled Reviews**:
- Daily: GuardDuty findings triage
- Weekly: Security Hub compliance review
- Monthly: CloudTrail privileged access review
- Quarterly: Comprehensive security posture assessment

---

## 19. Capacity and Availability Management

### 19.1 Capacity Thresholds
**Alert Thresholds**:
- EC2 CPU >80% average for 10 minutes → Scale up
- EC2 CPU <30% average for 15 minutes (3 periods) → Scale down
- RDS storage >80% → Alert and plan upgrade
- RDS connections >75% of max → Investigate connection pooling
- S3 storage growth >50% per month → Review with customer

### 19.2 Availability Targets
- **Production SLA**: 99.9% uptime (excludes scheduled maintenance)
- **Scheduled maintenance**: Maximum 4 hours per month; customer notification 7 days prior
- **RTO (Recovery Time Objective)**: 4 hours
- **RPO (Recovery Point Objective)**: 24 hours (maximum data loss)

### 19.3 Maintenance Windows
- **Preferred**: Sunday 02:00-06:00 UTC (low traffic)
- **Notification**: Customers notified 7 days in advance
- **Exception**: Emergency maintenance for security (immediate)

---

## 20. Third-Party Service Management

### 20.1 AWS Service Usage
**Approved Services**:
- Compute: EC2, Lambda, Auto Scaling
- Storage: S3, EBS
- Database: RDS (MySQL)
- Networking: VPC, Route53, CloudFront (if needed)
- Security: WAF, GuardDuty, Security Hub, CloudTrail, Config, KMS
- Monitoring: CloudWatch, SNS
- Backup: AWS Backup
- Integration: EventBridge

**New Service Adoption**:
- Security review by ISMS Lead
- Privacy impact assessment (if processing personal data)
- Cost-benefit analysis
- Testing in non-production
- Documentation updated
- Managing Director approval

### 20.2 Third-Party SaaS Tools
**Approval Required** for tools processing company/customer data:
- Security assessment questionnaire
- Privacy policy review
- DPA negotiation (if processing personal data)
- ISO 27001 or SOC 2 certification preferred
- Trial period in non-production
- Annual review of service provider security

---

## 21. Media Handling and Disposal

### 21.1 Digital Media
**Storage**:
- Encrypted at rest (KMS for AWS; BitLocker/FileVault for endpoints)
- Access controls (IAM, file permissions)
- Classified and labeled (Internal, Confidential, Restricted)

**Disposal**:
- **S3 objects**: Deleted with all versions (versioned bucket); wait for backup expiry
- **EBS volumes**: Encrypted; deletion via AWS (AWS wipes per DOD 5220.22-M standard)
- **RDS data**: Final snapshot before deletion; snapshot encrypted; deleted after retention
- **Backups**: Expired per retention policy; then deleted by AWS Backup

### 21.2 Physical Media
**Laptops/Workstations**:
- Full disk encryption required (FileVault, BitLocker)
- Disposal: Secure wipe (DBAN, vendor secure erase)
- Verification: Certificate of destruction from disposal service
- Tracking: Asset disposal register

**Portable Media** (USB drives):
- Prohibited for company data storage
- If necessary: Encrypted USB drives only; approved by ISMS Lead
- Disposal: Physical destruction

**Paper Documents**:
- Confidential waste bins
- Shredding service for confidential documents
- No personal data in general waste

---

## 22. Clock Synchronization

### 22.1 Time Standards
- **All systems synchronized** to UTC
- **AWS NTP**: EC2 instances use AWS NTP service (169.254.169.123)
- **Log timestamps**: UTC (convert to local time for analysis if needed)
- **Purpose**: Accurate incident timelines, log correlation, audit compliance

### 22.2 Time Drift Monitoring
- CloudWatch metric for NTP sync status
- Alarm if time drift >1 second
- Critical for CloudTrail log integrity

---

## 23. Compliance and Audit

### 23.1 Operational Compliance Monitoring
**Monthly Checks**:
- Backup job success rates
- Patch compliance (all systems current)
- Security group compliance (Config rules)
- Certificate expiry monitoring (ACM auto-renewal)

**Quarterly Checks**:
- Access reviews
- Vulnerability remediation status
- Configuration compliance (drift detection)
- SOP effectiveness reviews

### 23.2 Audit Evidence
Maintained for auditors:
- Change management records (all changes, approvals, outcomes)
- Patch management logs (AMI build logs, patch schedules)
- Backup verification test results
- Vulnerability scan reports and remediation evidence
- Configuration baseline documentation
- Monitoring and alerting configuration
- Incident response records

---

## 24. Continuous Improvement

### 24.1 Operational Metrics (Monthly)
- System availability (uptime %)
- Backup success rate (target: 100%)
- Mean time to detect incidents (MTTD)
- Mean time to resolve incidents (MTTR)
- Change success rate (changes without rollback)
- Vulnerability remediation time (average days)

### 24.2 Review and Improvement
- **Monthly**: Operations team reviews metrics and identifies improvements
- **Quarterly**: ISMS Lead reviews with Managing Director
- **Annually**: Comprehensive operations review; benchmark against industry
- **Post-incident**: Lessons learned implemented

---

## 25. Related Documents

- Information Security Policy
- Change Management Procedure
- Incident Management Policy
- Backup and Restore Runbook (docs/backup-restore-runbook.md)
- Deployment Guide (docs/deployment.md)
- Infrastructure Documentation (docs/readme.md, docs/infrastructure.md)
- Disaster Recovery Test Plan (docs/disaster-recovery-test.md)

---

## 26. Management Approval

**Approved by**:

**Name**: Akam Rahimi  
**Position**: Managing Director & ISMS Lead  
**Signature**: ________________________________  
**Date**: ________________________________

---

## Revision History

| **Version** | **Date** | **Author** | **Description of Changes** | **Approved By** |
|------------|----------|------------|---------------------------|-----------------|
| 1.0 | [Date] | Senior Developer | Initial policy creation | Akam Rahimi |

---

**END OF POLICY**

