# Security Monitoring and Logging Policy

**EPACT LTD** | Company Registration: 11977631

## Document Control
| Version | 1.0 | Owner | Support Team Lead |
|---------|-----|-------|-------------------|
| **Approved By** | Akam Rahimi | **ISO 27001 Ref** | A.8.15, A.8.16 |
| **Contact** | akam@epact.co.uk |

---

## 1. Logging Requirements

### 1.1 Events to Log
**All systems must log**:
- User authentication (success/failure)
- Access to RESTRICTED data
- Administrative actions
- System errors and exceptions
- Configuration changes
- Security events (GuardDuty findings, WAF blocks)

### 1.2 Log Contents (Minimum)
- Timestamp (UTC)
- User identity (username, IAM ARN, IP)
- Action performed
- Resource accessed
- Outcome (success/error code)
- Source IP and location

---

## 2. AWS Logging Implementation

### 2.1 CloudTrail (AWS API Audit Log)
- **Scope**: All AWS API calls
- **Retention**: 365 days in S3
- **Encryption**: KMS (security_kms_key)
- **Integrity**: Log file validation enabled
- **Multi-region**: Single region (eu-west-2)
- **Storage**: S3 bucket with lifecycle (90d→Glacier)

### 2.2 CloudWatch Logs
- **Application logs**: 90-day retention, KMS encrypted
- **Lambda logs**: 90-day retention, KMS encrypted
- **RDS logs**: Error, general, slow-query (30-day retention)
- **VPC Flow Logs**: 365-day retention (S3 with lifecycle)
- **ALB Access Logs**: 365-day retention (S3 with lifecycle)

### 2.3 GuardDuty
- **Threat detection**: Enabled
- **Findings retention**: 90 days active; archived indefinitely
- **Alert severity**: High/Critical → immediate SNS alert
- **Data sources**: CloudTrail, VPC Flow Logs, DNS logs, S3 data events

### 2.4 Security Hub
- **Standards**: CIS AWS Foundations Benchmark, PCI DSS
- **Findings aggregation**: GuardDuty, Config, IAM Access Analyzer
- **Compliance tracking**: Dashboard and reports
- **Review**: Weekly

### 2.5 AWS Config
- **Configuration recording**: All resource types
- **Retention**: Configuration history and snapshots
- **Compliance rules**: Encryption, tagging, security groups
- **S3 storage**: Config bucket (KMS encrypted, lifecycle policies)

---

## 3. Log Protection

### 3.1 Integrity
- **Immutability**: S3 Object Lock for CloudTrail logs
- **Encryption**: KMS encryption prevents tampering
- **Access control**: Read-only except authorized log archival
- **Hashing**: CloudTrail log file validation

### 3.2 Retention
| **Log Type** | **Retention** | **Rationale** |
|-------------|---------------|---------------|
| CloudTrail | 365 days | Audit, compliance, forensics |
| CloudWatch (application) | 90 days | Operational troubleshooting, GDPR compliance |
| VPC Flow Logs | 365 days (lifecycle) | Network security, incident investigation |
| ALB Access Logs | 365 days (lifecycle) | Security, performance analysis |
| RDS Logs | 30 days | Performance tuning |

### 3.3 Access Control
**Who Can Access Logs**:
- Support team: CloudWatch (read-only)
- ISMS Lead: All logs (read-only)
- Incident Response Team: Full access during incidents
- Auditors: Controlled access (supervised)

**Prohibited**:
- Log deletion (except automated expiry)
- Log modification
- Unauthorized export

---

## 4. Security Monitoring

### 4.1 Real-Time Monitoring
**24/7 Automated Monitoring**:
- GuardDuty findings → SNS → ISMS Lead email/SMS
- CloudWatch alarms → SNS → Support team
- Security Hub critical findings → daily digest

**Business Hours Monitoring** (9am-6pm UK time):
- CloudWatch dashboard reviewed hourly
- GuardDuty console checked every 4 hours
- Security Hub findings triaged

**On-Call**: ISMS Lead available for P1/P2 incidents (24/7)

### 4.2 Proactive Monitoring
**Weekly**:
- GuardDuty findings review (all severities)
- Security Hub compliance score
- Failed authentication report
- New IAM users/roles report
- Security group changes review

**Monthly**:
- CloudTrail privileged action review
- Trend analysis (incidents, alarms, findings)
- Capacity and performance review
- Cost anomaly review

**Quarterly**:
- Comprehensive security posture assessment
- Log coverage review (all critical systems logged?)
- Retention compliance verification

### 4.3 Threat Detection
**GuardDuty Finding Types**:
- Reconnaissance: Port scanning, unusual API activity
- Instance compromise: Cryptocurrency mining, C2 communication, malware
- Account compromise: Credential misuse, unusual geo-location, impossible travel
- S3 data exfiltration: Unusual API patterns, Tor exit node access

**Response**: Per Incident Management Policy based on severity

---

## 5. Log Review and Analysis

### 5.1 Automated Analysis
- **CloudWatch Logs Insights**: Query logs for patterns
- **GuardDuty**: Machine learning-based anomaly detection
- **Security Hub**: Compliance findings and prioritization
- **AWS Config**: Configuration drift detection

### 5.2 Manual Review
**Monthly Privileged Access Review**:
- All CloudTrail events by admin.* IAM users
- All root account activity (should be zero)
- All IAM policy modifications
- All security group changes
- Sample of RDS administrative queries

**Quarterly Comprehensive Review**:
- Failed authentication attempts (pattern analysis)
- Data export activities (large S3 downloads)
- Off-hours access (outside 6am-8pm UK time)
- Access from unusual locations (geo-IP analysis)

### 5.3 Log Analysis Tools
- **CloudWatch Logs Insights**: Ad-hoc queries
- **Athena**: SQL queries on S3 logs (VPC Flow, ALB)
- **CloudTrail Lake**: Long-term audit log queries (future)
- **Third-party SIEM**: Consider for advanced correlation (future)

---

## 6. Alerting and Escalation

### 6.1 Alert Types
**Critical Alerts** (immediate SMS + email):
- GuardDuty high/critical findings
- Root account usage
- Multiple failed MFA attempts
- IAM policy changes (unexpected)
- Security group allowing 0.0.0.0/0 on sensitive ports
- S3 bucket made public

**High Priority Alerts** (email within 15 min):
- CloudWatch alarms (ALB 5xx, CPU high, RDS CPU)
- Security Hub high-severity findings
- AWS Config non-compliance (encryption disabled)
- Failed backup jobs

**Standard Alerts** (email digest):
- Medium/low GuardDuty findings (daily digest)
- Informational Security Hub findings (weekly digest)
- Performance warnings (weekly summary)

### 6.2 Escalation Matrix
| **Alert Type** | **Primary** | **Escalation (15 min)** | **Escalation (1 hour)** |
|---------------|-----------|----------------------|---------------------|
| Critical security | ISMS Lead | Managing Director | External incident response |
| High security | Support team | ISMS Lead | Managing Director |
| Availability (P1) | Support team | Senior Developer | ISMS Lead |
| Standard | Support team | Shift supervisor | ISMS Lead (next day) |

---

## 7. SIEM and Correlation (Future)

### 7.1 Current State
- Logs centralized in CloudWatch and S3
- Basic correlation via GuardDuty
- Manual analysis for complex investigations

### 7.2 Future Enhancement
- Deploy SIEM solution (Splunk, Elastic, AWS Security Lake)
- Advanced correlation rules
- Automated playbooks (SOAR - Security Orchestration Automation Response)
- Integration with threat intelligence feeds

---

## 8. Compliance and Audit

### 8.1 ISO 27001 Requirements
- A.8.15: Logging of events
- A.8.16: Clock synchronization (NTP)
- Evidence of log reviews and actions taken

### 8.2 GDPR Requirements
- Audit trails for personal data processing
- Logs for data subject rights requests
- Evidence for security of processing (Article 32)

### 8.3 Audit Evidence
- Log retention policies
- Log review reports (monthly/quarterly)
- Alert configurations (CloudWatch alarms, SNS)
- Incident investigation logs
- Access to logs (IAM policies)

---

## 9. Related Documents
- Operations Security Policy
- Incident Management Policy
- Access Control Policy

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

