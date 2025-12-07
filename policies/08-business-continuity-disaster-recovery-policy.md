# Business Continuity and Disaster Recovery Policy

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
| **Owner** | Akam Rahimi, ISMS Lead |
| **Contact** | akam@epact.co.uk |
| **ISO 27001 Reference** | A.5.29, A.5.30 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy establishes EPACT LTD's approach to maintaining business operations during disruptions and recovering from disasters, ensuring minimal impact on customers and stakeholders.

### 1.2 Scope
- Critical business processes and IT services
- Multi-tenant SaaS platform on AWS
- Customer-facing services (ALB, EC2, RDS)
- Internal business operations
- Employee capability to work during disruptions
- Recovery of information and systems

---

## 2. Business Continuity Objectives

### 2.1 Recovery Time Objective (RTO)
**Maximum acceptable downtime** before business severely impacted:

| **Service/Process** | **RTO** | **Justification** |
|--------------------|---------|------------------|
| Customer-facing application (ALB/EC2) | 4 hours | SLA commitment; revenue impact |
| RDS database | 2 hours | Multi-AZ auto-failover; critical data dependency |
| Tenant S3 bucket access | 4 hours | Customer data access; can tolerate brief outage |
| AWS Backup restoration | 8 hours | DR scenario; full system rebuild |
| Internal business systems (email, docs) | 24 hours | Workarounds available |
| Development/staging environments | 5 business days | No customer impact |

### 2.2 Recovery Point Objective (RPO)
**Maximum acceptable data loss**:

| **Data Type** | **RPO** | **Backup Frequency** |
|--------------|---------|---------------------|
| RDS database (transactional data) | 1 hour | RDS continuous backup + daily AWS Backup |
| Tenant S3 data (documents, files) | 24 hours | S3 versioning (immediate) + daily AWS Backup |
| Terraform infrastructure state | 24 hours | S3 versioning (immediate) |
| CloudWatch logs | Real-time | Continuous streaming to CloudWatch |
| Application configuration | 24 hours | Git repository (immediate commit) |

### 2.3 Business Impact Tolerance

| **Impact Level** | **Definition** | **Maximum Tolerance** |
|-----------------|---------------|---------------------|
| **Catastrophic** | Complete loss of customer data; business survival threatened | 0 - Not acceptable |
| **Severe** | Multi-day outage; single tenant data loss; major financial impact | 4 hours RTO; 24 hours RPO |
| **Moderate** | Service degradation; partial functionality; manageable revenue loss | 24 hours RTO; 72 hours RPO |
| **Minor** | Negligible customer impact; internal inconvenience only | 5 days RTO; 7 days RPO |

---

## 3. Business Impact Analysis (BIA)

### 3.1 Critical Business Processes

**Priority 1 - Critical** (RTO: 4 hours):
1. **Customer application access**:
   - Dependencies: ALB, EC2 ASG, RDS database, Route53
   - Impact if unavailable: Customer revenue loss; SLA breach; reputation damage
   - Recovery: Multi-AZ auto-failover; restore from backup; rebuild from Terraform

2. **Tenant data storage and access**:
   - Dependencies: S3 buckets, KMS encryption, IAM authentication
   - Impact if unavailable: Customer operations disrupted; potential data loss
   - Recovery: S3 versioning restoration; AWS Backup restoration

3. **Authentication and access control**:
   - Dependencies: IAM, application authentication service
   - Impact if unavailable: No user logins; complete service unavailable
   - Recovery: IAM highly available; application authentication in RDS (auto-failover)

**Priority 2 - Important** (RTO: 24 hours):
4. **Monitoring and alerting**:
   - Dependencies: CloudWatch, GuardDuty, SNS
   - Impact if unavailable: Blind to incidents; delayed incident response
   - Recovery: AWS-managed services (high availability); reconfigure from Terraform

5. **Tenant provisioning automation**:
   - Dependencies: Lambda function, EventBridge, KMS
   - Impact if unavailable: Manual tenant provisioning required (workaround available)
   - Recovery: Redeploy Lambda from Terraform; low complexity

6. **Business email and communications**:
   - Dependencies: Email provider (Gmail/Office 365)
   - Impact if unavailable: Communication delays; customer queries unanswered
   - Recovery: Provider SLA-based; phone/SMS backup communication

**Priority 3 - Desirable** (RTO: 5 days):
7. **Development and testing environments**:
   - Dependencies: Separate AWS account/VPC
   - Impact if unavailable: Cannot deploy new features; bug fixes delayed
   - Recovery: Rebuild from Terraform

8. **Internal documentation and knowledge base**:
   - Dependencies: Git repository, Google Docs
   - Impact if unavailable: Productivity reduced; rely on local copies
   - Recovery: Provider backup; Git distributed nature

### 3.2 BIA Review
- **Annual review**: Update impact assessments, dependencies, recovery procedures
- **Trigger reviews**: New services, significant infrastructure changes, incidents
- **Documentation**: BIA report maintained by ISMS Lead

---

## 4. Business Continuity Strategies

### 4.1 High Availability Architecture
**Multi-AZ Deployment** (automatic failover):
- RDS database: Multi-AZ with synchronous replication (failover: ~2 minutes)
- EC2 instances: Auto Scaling Group spans 2+ AZs (automatic replacement)
- NAT Gateways: One per AZ (redundancy)
- ALB: Automatically routes to healthy instances across AZs

**Benefits**:
- No manual intervention for common failures
- Transparent to customers
- Meets RTO/RPO objectives for component failures

### 4.2 Auto-Recovery Features
**AWS Auto Scaling**:
- Unhealthy instances automatically replaced
- Scales up during traffic spikes (CPU >80%)
- Scales down during low traffic (CPU <30%)
- Health checks via ALB (application-level)

**RDS Automated Failover**:
- Multi-AZ standby promoted automatically
- DNS endpoint unchanged (application reconnects automatically)
- Typical failover: 60-120 seconds

**ALB Health Checks**:
- Endpoint: /health
- Frequency: Every 30 seconds
- Unhealthy threshold: 3 consecutive failures
- Automatic traffic routing away from unhealthy instances

### 4.3 Data Redundancy
**S3 Durability**: 99.999999999% (11 nines) across multiple AZs

**S3 Versioning**: Protects against accidental deletion or overwrite

**RDS Multi-AZ**: Synchronous replication to standby

**AWS Backup**: Offsite backups in AWS Backup vault (separate from production)

**Terraform State**: S3 versioning protects against state corruption

---

## 5. Backup Strategy

**See also**: Backup and Restore Runbook (docs/backup-restore-runbook.md)

### 5.1 Backup Schedules

**Daily Backups** (05:00 UTC):
- RDS database
- EC2 instances tagged `Backup=true`
- Tenant S3 buckets tagged `Backup=true`
- **Retention**: 30 days primary + 90-day copy

**Weekly Backups** (Sunday 06:00 UTC):
- Same resources as daily
- **Retention**: 365 days with cold storage transition after 30 days

**RDS Native Backups** (03:00-04:00 UTC):
- Automated snapshots (AWS-managed)
- **Retention**: 7 days
- **Purpose**: Quick restore point for operational issues

### 5.2 Backup Verification (Quarterly)
1. Select random RDS backup recovery point
2. Restore to staging environment
3. Verify data integrity (record counts, checksums)
4. Run application smoke tests
5. Measure restoration time (must meet RTO)
6. Document test results
7. Delete test restoration resources

### 5.3 Backup Security
- All backups encrypted with KMS (backup_kms_key)
- Backup vault access restricted (IAM policies)
- CloudTrail logs all backup vault access
- Backups in separate AWS account (future enhancement)

---

## 6. Disaster Recovery (DR)

### 6.1 Disaster Scenarios

#### Scenario 1: Complete RDS Database Failure
**Trigger**: Database corruption, irreversible failure, ransomware

**Recovery Procedure**:
1. Activate Incident Response Team
2. Notify customers of service disruption
3. Identify latest valid AWS Backup recovery point
4. Initiate restore job via AWS Backup (see backup-restore-runbook.md)
5. Restoration time: ~2 hours for RDS (size-dependent)
6. Update application configuration if new endpoint
7. Verify data integrity
8. Resume customer traffic
9. Post-incident review

**RTO**: 4 hours | **RPO**: 24 hours (daily backup) or 1 hour (RDS continuous backup)

#### Scenario 2: Complete EC2 Instance Failure
**Trigger**: Instance termination, corruption, availability zone failure

**Recovery Procedure**:
1. Auto Scaling Group automatically launches replacement instance
2. New instance pulls latest code from deployment bucket or Git
3. Joins ALB target group
4. Health checks pass
5. Traffic routed to new instance
6. Monitor for issues

**RTO**: 10 minutes (automated) | **RPO**: 0 (stateless instances)

#### Scenario 3: Availability Zone Failure
**Trigger**: AWS AZ-wide outage (rare)

**Recovery Procedure**:
1. Multi-AZ architecture handles automatically:
   - RDS failover to standby in healthy AZ
   - ALB routes traffic to instances in healthy AZ
   - ASG launches replacement instances in healthy AZs
2. Monitor service health
3. Scale up in healthy AZs if needed (temporary increase in desired capacity)
4. Await AWS AZ recovery
5. Re-balance instances across AZs after recovery

**RTO**: < 5 minutes (automated) | **RPO**: 0 (synchronous replication)

#### Scenario 4: Complete AWS Region Failure
**Trigger**: Catastrophic AWS eu-west-2 region outage (extremely rare)

**Current State**: Single-region deployment; no automatic failover

**Recovery Procedure** (manual):
1. Activate Business Continuity Plan
2. Notify all customers via alternative channels (email from backup provider)
3. Deploy infrastructure to secondary region (eu-west-1) using Terraform
4. Restore RDS from latest backup to new region
5. Restore tenant S3 buckets from backups
6. Update Route53 DNS to point to new region
7. DNS propagation: ~1 hour
8. Verify functionality
9. Customer communication: Service restored

**RTO**: 8 hours (manual rebuild) | **RPO**: 24 hours (daily backup)

**Future Enhancement**: Multi-region deployment with automated DR failover

#### Scenario 5: Ransomware Attack
**Trigger**: Ransomware encrypts production systems or data

**Recovery Procedure**:
1. **DO NOT PAY RANSOM**
2. Isolate affected systems (security group modification)
3. Identify encryption time from logs
4. Select backup recovery point before encryption
5. Rebuild clean infrastructure from Terraform
6. Restore RDS from pre-encryption backup
7. Restore S3 from versioning or backup
8. Verify malware eradicated
9. Enhanced monitoring for re-infection
10. Report to National Crime Agency (NCA)

**RTO**: 4-8 hours | **RPO**: 24 hours (latest clean backup)

### 6.2 DR Testing
**Frequency**: Annually (see docs/disaster-recovery-test.md)

**Test Scenarios**:
- RDS database restoration
- Tenant S3 bucket restoration
- EC2 instance replacement
- Complete infrastructure rebuild in new region (tabletop)

**Success Criteria**:
- Meet RTO and RPO objectives
- All critical functions operational
- Documentation accurate
- Gaps identified and remediated

---

## 7. Emergency Response

### 7.1 Emergency Contact List
**Available 24/7**:

| **Role** | **Name** | **Phone** | **Email** | **Escalation Order** |
|---------|---------|----------|----------|---------------------|
| **Primary**: ISMS Lead | Akam Rahimi | [Phone] | akam@epact.co.uk | 1st contact |
| **Escalation**: Managing Director | Akam Rahimi | [Phone] | akam@epact.co.uk | If primary unavailable |
| **Technical Lead** | Senior Developer | [Phone] | [Email] | 2nd contact |
| **AWS Support** | N/A | +1 (877) 910-7452 | Via console | For AWS service issues |

**Update**: Contact list reviewed quarterly; changes communicated to all staff

### 7.2 Communication Plan

**Internal Communications**:
- Incident Slack/Teams channel created immediately
- Status updates every 2 hours (P1/P2 incidents)
- All staff notified of major incidents affecting business operations

**Customer Communications**:
- Email notification within 2 hours of confirmed outage
- Status page updates (if available) every hour
- Estimated restoration time communicated
- Post-incident summary within 48 hours of resolution

**Stakeholder Communications**:
- Managing Director notifies board (P1 incidents)
- Media inquiries directed to Business Development Director
- Regulatory notifications per legal obligations (GDPR, etc.)

### 7.3 Emergency Decision-Making
**Authority to declare disaster**: Managing Director or ISMS Lead

**Activate BC/DR Plan**:
- For P1 incidents exceeding 1 hour
- Anticipated prolonged outage (>4 hours)
- Multiple AZ failure
- Confirmed data breach
- Regulatory reportable incident

**Decision-Making Hierarchy**:
1. Managing Director (if available)
2. ISMS Lead
3. Senior Developer (technical decisions)

---

## 8. Alternative Work Arrangements

### 8.1 Remote Work Capability
**Current State**: All staff already remote-capable

**Requirements for Business Continuity**:
- Laptops with VPN and MFA access
- Internet connectivity (home broadband or mobile hotspot backup)
- Access to AWS console and application systems
- Communication tools (Slack, email, video conferencing)
- Virtual phone system or mobile forwarding

### 8.2 Facility Disruption
**Scenarios**: Office inaccessible due to fire, flood, lockdown

**Response**:
- All staff work from home (standard practice)
- Redirect mail to Managing Director's address
- Forward office phone to mobile
- Virtual meetings for all business continuity decisions
- Document secure storage: Electronic copies in cloud; physical records recovered when safe

### 8.3 Key Personnel Unavailability

**Scenario**: ISMS Lead or Managing Director unable to work (illness, accident)

**Succession Plan**:
- **Managing Director** → Business Development Director (temporary authority)
- **ISMS Lead** → Senior Developer (temporary ISMS Lead duties)
- **Senior Developer** → [External contractor or junior promoted temporarily]

**Cross-Training**:
- Senior Developer trained on ISMS processes
- Runbooks documented for all critical procedures
- Passwords and credentials accessible via break-glass procedure

---

## 9. Supplier and Third-Party Dependencies

### 9.1 Critical Suppliers

**Amazon Web Services (AWS)**:
- **Dependency**: Complete infrastructure hosted on AWS
- **BC Plan**: Multi-AZ deployment; AWS 99.99% SLA for most services
- **Risk**: AWS region failure (rare)
- **Mitigation**: Multi-region DR capability (future); rely on AWS SLAs and BC practices

**Internet Service Providers (ISPs)**:
- **Dependency**: Connectivity for remote work and customer access
- **BC Plan**: Multiple ISPs or mobile hotspot backup
- **Risk**: ISP outage
- **Mitigation**: Staff use mobile hotspots; AWS multi-AZ provides path diversity

**Domain Registrar and DNS** (Route53):
- **Dependency**: DNS resolution for application domain
- **BC Plan**: Route53 100% SLA with global anycast
- **Risk**: Account compromise or misconfiguration
- **Mitigation**: MFA on account; CloudTrail monitoring; backup DNS provider (future)

**Payment Processor** (if applicable):
- **Dependency**: Customer billing
- **BC Plan**: Processor's BC plan reviewed
- **Risk**: Processor outage
- **Mitigation**: Manual invoicing fallback

### 9.2 Supplier BC/DR Reviews
- Annual review of critical supplier BC/DR capabilities
- Request supplier BC testing results
- Contractual SLA enforcement
- Alternative supplier identified (if feasible)

---

## 10. Data Backup and Recovery

### 10.1 Backup Infrastructure
**See docs/backup-restore-runbook.md for detailed procedures**

**AWS Backup Vault**:
- Name: `multi-tenant-app-prod-backup-vault`
- Encryption: KMS key (security_kms_key_arn)
- Access: Restricted to ISMS Lead and backup service role
- Monitoring: CloudWatch alarms for backup failures

**Backup Components**:
1. RDS database (daily 05:00 UTC + weekly Sunday 06:00 UTC)
2. EC2 instances tagged `Backup=true` (same schedule)
3. Tenant S3 buckets tagged `Backup=true` (same schedule)
4. Terraform state (S3 versioning - continuous)

### 10.2 Restoration Procedures

**RDS Restoration**:
```bash
# 1. List recovery points
aws backup list-recovery-points-by-backup-vault \
  --backup-vault-name multi-tenant-app-prod-backup-vault \
  --by-resource-type RDS

# 2. Start restore job
aws backup start-restore-job \
  --recovery-point-arn <ARN> \
  --metadata file://restore-metadata.json \
  --iam-role-arn <BACKUP_ROLE_ARN>

# 3. Monitor restoration
aws backup describe-restore-job --restore-job-id <JOB_ID>

# 4. Verify and cut over
# See backup-restore-runbook.md for details
```

**S3 Restoration**:
- Versioning: Restore previous version of object
- AWS Backup: Restore entire bucket to new location
- Verification: Compare object counts and checksums

### 10.3 Backup Testing
**Quarterly**: Random backup restoration test  
**Annually**: Full DR test per docs/disaster-recovery-test.md

**Success Criteria**:
- Restoration completes within RTO
- Data integrity verified (no corruption)
- Application functional post-restoration
- Lessons learned documented

---

## 11. Disaster Recovery Testing

### 11.1 Annual DR Exercise
**See**: docs/disaster-recovery-test.md for full plan

**Objectives**:
- Validate DR procedures are accurate and effective
- Train staff on DR execution
- Meet RTO/RPO objectives
- Identify gaps and improvements

**Scenarios Tested**:
- RDS database restoration (from backup)
- EC2 instance replacement (simulate AZ failure)
- S3 tenant bucket recovery
- Terraform state restoration (simulate corruption)
- Complete infrastructure rebuild (tabletop exercise)

**Participants**:
- IRT members (all roles)
- Observers: Managing Director, external auditors (if scheduled)

**Post-Exercise**:
- Debrief within 48 hours
- Measure RTO/RPO achievement
- Document findings and improvements
- Update procedures and runbooks
- Action items tracked to completion

### 11.2 Tabletop Exercises
**Frequency**: Semi-annually (every 6 months)

**Format**: Discussion-based walkthrough of DR scenario

**Duration**: 2-3 hours

**Scenarios**:
- AWS region failure (multi-region failover)
- Cyber attack with data breach
- Key personnel unavailable
- Prolonged internet outage

**Benefits**:
- Low cost and disruption
- Validates knowledge and decision-making
- Identifies documentation gaps
- Team building and awareness

---

## 12. Emergency Procedures

### 12.1 Incident Severity P1 (Critical)
**Immediate Actions** (within 15 minutes):
1. Activate Incident Response Team
2. Notify Managing Director
3. Assess customer impact (how many tenants affected?)
4. Initiate customer communication (status email)
5. Begin technical investigation (CloudTrail, GuardDuty, logs)
6. Consider activating DR plan if prolonged outage anticipated

### 12.2 Activating DR Plan
**Decision Criteria**:
- Service outage expected to exceed RTO (4 hours)
- Data loss risk exceeds RPO (24 hours)
- Primary systems unrecoverable
- Security incident requires complete rebuild

**Activation Process**:
1. ISMS Lead declares DR activation
2. IRT assembled (virtual meeting within 30 minutes)
3. DR runbook followed (backup-restore-runbook.md)
4. Progress updates every hour
5. Customer communication every 2 hours
6. Managing Director oversight

---

## 13. Recovery Strategies by Asset Type

### 13.1 Infrastructure Recovery (Terraform)
**Scenario**: Infrastructure corruption or accidental deletion

**Recovery**:
1. Git repository contains complete infrastructure code
2. Terraform state has S3 versioning (restore previous version)
3. Rebuild from Terraform code:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
4. Import existing resources if applicable (terraform import)
5. Restore data from backups (RDS, S3)
6. Verify infrastructure via automated tests

**RTO**: 2-4 hours (infrastructure rebuild) + restoration time

### 13.2 Database Recovery (RDS)
**See**: docs/backup-restore-runbook.md Section 5

**Methods**:
1. **Multi-AZ Failover**: Automatic (2 minutes)
2. **Point-in-Time Restore**: From continuous backup (RTO: 30 min - 2 hours)
3. **AWS Backup Restoration**: From daily/weekly backup (RTO: 1-2 hours)
4. **Manual Snapshot**: If created before failure (RTO: 1-2 hours)

**Data Validation Post-Restore**:
- Row counts match expected
- Critical records spot-checked
- Application smoke tests pass
- No data corruption detected

### 13.3 Application Recovery (EC2)
**Auto-Recovery**: ASG replaces failed instances automatically (RTO: 5-10 minutes)

**Manual Rebuild**:
1. Launch new instance from approved AMI
2. Apply latest application code (from S3 deployment bucket or Git)
3. Configure environment variables
4. Add to ALB target group
5. Health check passes
6. Monitor for stability

### 13.4 Storage Recovery (S3)
**Versioning Restore**: Restore deleted object from previous version (RTO: Minutes)

**Bucket Restore**:
1. List recovery points from AWS Backup
2. Restore to new bucket or original
3. Verify object count and sizes
4. Restore bucket policies and tags
5. Update application configuration if new bucket name

**RTO**: 1-4 hours (size-dependent)

---

## 14. Communication During Disasters

### 14.1 Customer Status Updates

**Template for Outage Notification**:
```
Subject: [URGENT] Service Disruption - [Brief Description]

Dear Valued Customer,

We are experiencing a service disruption affecting [description of impact].

Details:
- Issue detected: [Time UTC]
- Services affected: [List]
- Current status: [Investigating / Restoring / Resolved]
- Estimated resolution: [Time or "Under investigation"]

Our team is actively working to restore services. We will provide updates every [2/4] hours.

What you should do:
- [Any customer actions required]

We apologize for the inconvenience and appreciate your patience.

For urgent inquiries, contact: akam@epact.co.uk

EPACT LTD Support Team
```

**Update Frequency**:
- P1: Every 2 hours until resolved
- P2: Every 4 hours
- Final: Resolution notification with summary

### 14.2 Internal Communications
- **Incident Slack channel**: #incident-YYYY-NNN
- **Email**: Incident updates to all-staff
- **Phone**: For urgent communications to IRT members
- **Escalation**: Managing Director notified immediately for P1

---

## 15. Crisis Management

### 15.1 Crisis Definition
**Beyond incident**: Threatens organization's existence or reputation

**Examples**:
- Multi-day complete service outage
- Massive data breach (all customers affected)
- Regulatory enforcement action
- Media coverage damaging reputation
- Legal action from customers

### 15.2 Crisis Management Team
- **Leader**: Managing Director
- **Communications**: Business Development Director
- **Technical**: ISMS Lead and Senior Developer
- **Legal**: External counsel
- **PR**: External PR firm (if engaged)

### 15.3 Crisis Response
- Activate Crisis Management Team
- Establish crisis command center (virtual)
- Coordinate with legal counsel
- Prepare public statements
- Manage stakeholder communications (customers, regulators, investors, media)
- Document all actions and decisions
- Post-crisis review and improvement

---

## 16. Plan Maintenance and Testing

### 16.1 Plan Review Schedule
- **Annually**: Comprehensive BC/DR plan review and update
- **Quarterly**: Review critical sections (contact lists, dependencies)
- **After incidents**: Update based on lessons learned
- **After infrastructure changes**: Ensure procedures current

### 16.2 Changes Requiring Plan Update
- New services or infrastructure
- Organizational changes (personnel, structure)
- Supplier changes (new providers)
- Regulatory changes
- Technology changes (new AWS services)
- Test findings and recommendations

### 16.3 Version Control
- BC/DR documentation in Git repository
- Version history maintained
- Stakeholders notified of significant changes
- Training provided on new procedures

---

## 17. Compliance and Audit

### 17.1 ISO 27001 Requirements
- A.5.29: Documented BC/DR procedures
- A.5.30: ICT readiness for business continuity
- Evidence of testing and reviews
- Management approval and oversight

### 17.2 Audit Evidence
- Business impact analysis
- BC/DR plan (this policy and runbooks)
- DR test reports (annual)
- Backup verification test results (quarterly)
- Contact list and escalation procedures
- Incident records demonstrating plan activation
- Plan review meeting minutes

---

## 18. Related Documents

- Information Security Policy
- Incident Management Policy
- Operations Security Policy
- Risk Management Policy
- Backup and Restore Runbook (docs/backup-restore-runbook.md)
- Disaster Recovery Test Plan (docs/disaster-recovery-test.md)
- Infrastructure Documentation (docs/readme.md, docs/infrastructure.md)
- Deployment Guide (docs/deployment.md)

---

## 19. Management Approval

**Approved by**:

**Name**: Akam Rahimi  
**Position**: Managing Director & ISMS Lead  
**Signature**: ________________________________  
**Date**: ________________________________

---

## Revision History

| **Version** | **Date** | **Author** | **Description of Changes** | **Approved By** |
|------------|----------|------------|---------------------------|-----------------|
| 1.0 | [Date] | Akam Rahimi | Initial policy creation | Akam Rahimi |

---

**END OF POLICY**

**For emergency BC/DR activation, contact: Akam Rahimi, akam@epact.co.uk, [Phone]**

