# Information Backup Policy

**EPACT LTD** | Company Registration: 11977631

## Document Control
| Version | 1.0 | Owner | ISMS Lead |
|---------|-----|-------|-----------|
| **ISO 27001 Ref** | A.8.13 | **Approved** | Akam Rahimi |

---

## 1. Backup Requirements

### 1.1 What is Backed Up
**Critical Data** (mandatory backup):
- RDS MySQL database (all tenant data)
- Tenant S3 buckets (customer documents and files)
- EC2 instances tagged `Backup=true` (EBS volumes)
- Terraform state file (S3 versioning)
- Application configuration (Git repository)

**Important Data** (recommended backup):
- CloudWatch Logs (90-day retention)
- CloudTrail logs (365-day retention in S3)
- Documentation (Git repository)

**Not Backed Up** (ephemeral or replaceable):
- Individual EC2 instances (stateless; rebuilt from AMI)
- Temporary files and caches
- Development/test data

### 1.2 Backup Schedules

**See also**: docs/backup-restore-runbook.md

| **Resource** | **Frequency** | **Time (UTC)** | **Retention** | **Method** |
|-------------|--------------|---------------|---------------|-----------|
| RDS Database | Daily | 05:00 | 30 days + 90-day copy | AWS Backup |
| RDS Database | Weekly | Sunday 06:00 | 365 days (cold storage after 30d) | AWS Backup |
| RDS Database | Native snapshot | 03:00-04:00 | 7 days | RDS automated backup |
| EC2 (tagged) | Daily | 05:00 | 30 days | AWS Backup |
| Tenant S3 | Daily | 05:00 | 30 days | AWS Backup + Versioning |
| Terraform state | Continuous | Real-time | Indefinite (versioned) | S3 versioning |

---

## 2. Backup Infrastructure

### 2.1 AWS Backup Vault
- **Name**: multi-tenant-app-prod-backup-vault
- **Encryption**: KMS (security_kms_key_arn)
- **Access**: Restricted to backup service role and ISMS Lead
- **Location**: Same region (eu-west-2)
- **Vault Lock**: Consider enabling (prevent deletion; future)

### 2.2 Backup Plans
**Daily Plan**:
```
Rule: multi-tenant-app-daily-backup
Schedule: cron(0 5 * * ? *)
Lifecycle: delete_after = 30 days
Copy: 90-day retention
```

**Weekly Plan**:
```
Rule: multi-tenant-app-weekly-backup
Schedule: cron(0 6 ? * SUN *)
Lifecycle: cold_storage_after = 30 days, delete_after = 365 days
```

---

## 3. Backup Testing

### 3.1 Quarterly Restoration Test
**Procedure**:
1. Select random RDS backup (last 30 days)
2. Restore to staging environment
3. Verify data integrity (row counts, checksums)
4. Run application smoke tests
5. Measure restoration time
6. Document results
7. Clean up test resources

**Success Criteria**:
- Restoration completes within RTO (4 hours)
- Data integrity verified (no corruption)
- Application functional
- RPO met (max 24-hour data loss)

### 3.2 Annual DR Test
**See**: docs/disaster-recovery-test.md

**Scenarios**:
- Complete RDS restore
- S3 tenant bucket restore
- Infrastructure rebuild from Terraform
- Cross-region failover (tabletop)

---

## 4. Backup Monitoring

### 4.1 Automated Monitoring
- **AWS Backup**: Job status monitored
- **CloudWatch Alarms**: Backup failures trigger SNS alert
- **SNS Notification**: ISMS Lead notified of failures

### 4.2 Manual Review
- **Daily**: Verify previous night's backups successful
- **Weekly**: Review backup vault storage growth
- **Monthly**: Backup cost analysis
- **Quarterly**: Backup policy effectiveness review

---

## 5. Recovery Procedures

**See**: docs/backup-restore-runbook.md (detailed procedures)

### 5.1 RDS Restore
```bash
aws backup start-restore-job \
  --recovery-point-arn <ARN> \
  --metadata file://restore-metadata.json
```

### 5.2 S3 Bucket Restore
- Via AWS Backup (restore to new bucket)
- Via S3 Versioning (restore individual objects)

### 5.3 EC2 Restore
- Launch from AMI backup
- Restore EBS volumes from snapshots

---

## 6. Backup Security

- **Encryption**: All backups encrypted with KMS
- **Access control**: IAM policies restrict vault access
- **Immutability**: Vault Lock prevents deletion (future)
- **Separation**: Backups logically separated from production
- **Monitoring**: CloudTrail logs all backup vault access

---

## 7. Offsite Backups

### 7.1 Current State
- AWS Backup vault in same region (eu-west-2)
- S3 cross-region replication: Not enabled (cost consideration)

### 7.2 Future Enhancement
- Cross-region replication to eu-west-1 (Ireland)
- Separate AWS account for backups (security best practice)
- Backup vault in secondary region

---

## 8. Compliance

### 8.1 RTO/RPO Compliance
- RTO: 4 hours (tested quarterly)
- RPO: 24 hours (daily backups)
- Evidence: Test reports, restoration time measurements

### 8.2 Audit Evidence
- Backup schedules (Terraform configuration)
- Backup job logs (AWS Backup dashboard)
- Restoration test reports (quarterly)
- Backup policy (this document)

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

