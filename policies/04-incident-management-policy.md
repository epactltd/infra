# Incident Management Policy

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
| **ISO 27001 Reference** | A.5.24, A.5.25, A.5.26, A.6.8 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy establishes procedures for detecting, reporting, assessing, responding to, and learning from information security incidents to minimize impact on business operations and protect stakeholder interests.

### 1.2 Scope
This policy covers:
- All information security incidents and events
- All EPACT systems, networks, and data (including AWS infrastructure)
- Customer-impacting and internal incidents
- Data breaches and GDPR-reportable incidents
- Near-misses and potential security weaknesses
- Third-party incidents affecting EPACT

---

## 2. Definitions

### 2.1 Security Event
Any observable occurrence in a system or network that may indicate a security issue.

**Examples**:
- Failed login attempt
- GuardDuty low-severity finding
- CloudWatch alarm trigger
- Suspicious network traffic in VPC Flow Logs

### 2.2 Security Incident
A confirmed violation or imminent threat of violation of security policies, acceptable use, or security practices.

**Examples**:
- Unauthorized access to systems or data
- Malware detection on EC2 instances
- Data breach or exfiltration
- DDoS attack affecting availability
- Successful phishing attack
- Ransomware infection
- Insider threat activity
- Loss or theft of devices with company data

### 2.3 Data Breach
Incident involving unauthorized or accidental disclosure, access, alteration, or destruction of personal data.

**GDPR Definition**: "A breach of security leading to the accidental or unlawful destruction, loss, alteration, unauthorised disclosure of, or access to, personal data."

---

## 3. Incident Classification

### 3.1 Severity Levels

| **Severity** | **Definition** | **Response Time** | **Escalation** | **Examples** |
|-------------|---------------|------------------|---------------|-------------|
| **P1 - Critical** | Complete service outage; confirmed data breach; active attack | Immediate (15 min) | Managing Director + Customer notification | RDS database breach; multi-tenant data exposure; complete system compromise |
| **P2 - High** | Significant service degradation; potential data breach; malware detected | 1 hour | ISMS Lead + affected team leads | Single EC2 instance compromise; GuardDuty high-severity finding; ALB prolonged 5xx errors |
| **P3 - Medium** | Limited service impact; security policy violation; unsuccessful attack | 4 hours | ISMS Lead | Failed authentication spike; misconfigured security group; phishing attempt |
| **P4 - Low** | Minimal impact; suspicious activity; near-miss | 24 hours | Support team | Low GuardDuty finding; single failed login; minor policy violation |

### 3.2 Impact Assessment Factors
Consider impact on:
- **Confidentiality**: Is sensitive data exposed?
- **Integrity**: Is data or system integrity compromised?
- **Availability**: Are services unavailable or degraded?
- **Compliance**: Are there regulatory implications (GDPR, ISO 27001)?
- **Reputation**: Is there potential media attention or customer concern?
- **Financial**: Are there direct costs or potential fines?
- **Customer**: How many customers/tenants affected?

---

## 4. Incident Reporting

### 4.1 Reporting Channels

**Primary Contact**: Akam Rahimi, ISMS Lead  
**Email**: akam@epact.co.uk  
**Phone**: [TO BE COMPLETED]  
**Alternative**: Support team escalation  
**Automated**: SNS alerts to akam@epact.co.uk for CloudWatch/GuardDuty

### 4.2 Who Must Report
**Everyone** has a responsibility to report:
- Suspected security incidents
- Actual incidents
- Security weaknesses or vulnerabilities
- Policy violations observed
- Near-miss events

### 4.3 What to Report
- Date and time of incident (or discovery)
- Description of what happened
- Systems, data, or services affected
- Who discovered the incident
- Actions already taken (if any)
- Potential impact assessment
- Evidence available (logs, screenshots, emails)

### 4.4 Reporting Timelines
- **Critical incidents**: Immediately (by phone if outside business hours)
- **High incidents**: Within 1 hour of discovery
- **Medium incidents**: Within 4 hours of discovery
- **Low incidents**: Within 24 hours of discovery

### 4.5 No-Blame Culture
- Focus on learning and improvement, not punishment
- Honest reporting encouraged
- Protection from retaliation for good-faith reporting
- Accountability for deliberate policy violations

---

## 5. Incident Response Process

### 5.1 Incident Response Lifecycle

```
┌──────────────────────────────────────────────────┐
│ 1. Detection → 2. Reporting → 3. Triage →       │
│ 4. Containment → 5. Eradication → 6. Recovery → │
│ 7. Post-Incident Review → 8. Lessons Learned    │
└──────────────────────────────────────────────────┘
```

### 5.2 Phase 1: Detection
**Detection Methods**:
- AWS GuardDuty alerts (automated)
- CloudWatch alarms (CPU, error rates, ALB 5xx)
- Security Hub compliance findings
- AWS Config rule violations
- Employee/customer reports
- Penetration test findings
- External security researcher reports

**Initial Actions**:
- Note detection time (UTC timestamp)
- Gather initial evidence (screenshots, log snippets)
- Do not alter systems (preserve forensic evidence)

### 5.3 Phase 2: Reporting and Logging
1. Report to ISMS Lead immediately using reporting channels
2. Create incident ticket in incident tracking system
3. Assign unique incident ID (INC-YYYY-NNN)
4. Log initial details:
   - Reporter name and contact
   - Detection time
   - Affected systems
   - Initial classification (P1-P4)

### 5.4 Phase 3: Triage and Assessment
**ISMS Lead Actions** (within timelines per severity):
1. Verify incident is genuine (not false positive)
2. Classify severity (P1-P4) based on actual impact
3. Activate Incident Response Team if P1/P2
4. Assign incident owner
5. Establish communication channels
6. Begin evidence collection
7. Assess GDPR data breach notification requirements

**Assessment Questions**:
- What systems are affected?
- Is customer data involved?
- Is the attack ongoing?
- What is the scope of compromise?
- What is the business impact?
- Are backups affected?
- Is this a GDPR-reportable breach?

### 5.5 Phase 4: Containment
**Objectives**: Stop incident from spreading; preserve evidence

**Short-Term Containment** (immediate):
- Isolate affected systems (modify security groups, network ACLs)
- Disable compromised user accounts
- Block malicious IP addresses at WAF level
- Rotate potentially compromised credentials
- Take snapshots/images of affected systems for forensics

**Long-Term Containment** (within 24-48 hours):
- Deploy clean systems in parallel
- Migrate traffic away from compromised resources
- Maintain business operations using backup systems
- Preserve evidence in isolated environment

**AWS-Specific Actions**:
- Snapshot compromised EC2 instances (preserve for forensics)
- Enable S3 object lock on affected buckets (prevent deletion)
- Export CloudTrail logs to isolated S3 bucket
- Tag affected resources with "incident:INC-YYYY-NNN"
- Enable GuardDuty S3 protection if not already enabled

### 5.6 Phase 5: Eradication
**Objectives**: Remove threat; fix vulnerabilities

**Actions**:
1. Identify root cause (how attacker gained access)
2. Remove malware, backdoors, or unauthorized access
3. Patch vulnerabilities exploited
4. Update security group rules
5. Fix application code flaws
6. Update IAM policies
7. Rebuild compromised systems from clean AMIs
8. Verify eradication through scanning and testing

**Verification**:
- Run vulnerability scans
- Check GuardDuty findings cleared
- Review CloudTrail logs for continued suspicious activity
- Confirm all IOCs (Indicators of Compromise) removed

### 5.7 Phase 6: Recovery
**Objectives**: Restore normal operations; verify security

**Actions**:
1. Restore services from clean backups if necessary
2. Migrate traffic back to production systems
3. Monitor closely for 72 hours
4. Conduct post-recovery security testing
5. Verify data integrity
6. Confirm all security controls operational
7. Update monitoring and detection rules

**AWS Recovery Procedures**:
- Restore RDS from AWS Backup recovery point (see backup-restore-runbook.md)
- Launch new EC2 instances from approved AMI
- Restore tenant S3 buckets from versioned backups
- Update Route53 DNS if infrastructure changed
- Validate WAF rules and CloudWatch alarms active

**Recovery Validation**:
- Run automated health checks
- Conduct user acceptance testing
- Verify monitoring and logging operational
- Confirm backups running successfully
- Customer communication: "All clear"

### 5.8 Phase 7: Post-Incident Review
**Timing**: Within 5 business days after incident closure

**Attendees**: Incident Response Team, ISMS Lead, Managing Director (for P1/P2)

**Review Areas**:
- What happened? (incident timeline)
- How was it detected?
- How effective was the response?
- What worked well?
- What could be improved?
- Were policies and procedures followed?
- What is the root cause?
- What controls failed or were missing?

**Deliverables**:
- Incident report document
- Root cause analysis
- Action plan for improvements
- Policy/procedure updates
- Training recommendations

### 5.9 Phase 8: Lessons Learned
**Actions**:
1. Update security controls based on findings
2. Improve detection and monitoring
3. Update incident response procedures
4. Provide training to prevent recurrence
5. Share learnings (anonymized) with team
6. Update risk register
7. Implement recommended improvements (tracked in backlog)

---

## 6. Incident Response Team (IRT)

### 6.1 Team Structure

| **Role** | **Name** | **Responsibilities** | **Contact** |
|---------|---------|---------------------|------------|
| **Incident Manager** | Akam Rahimi | Overall coordination; decisions; communications; escalation | akam@epact.co.uk |
| **Technical Lead** | Senior Developer | Technical investigation; containment; eradication; recovery | [Email] |
| **Communications Lead** | Business Development Director | Customer/stakeholder communications; media relations | [Email] |
| **Support Lead** | Support Team | Monitoring; evidence collection; user communications | [Email] |
| **Legal/Compliance** | External counsel (if needed) | GDPR compliance; regulatory notifications; legal implications | [Contact] |

### 6.2 IRT Activation
- **Automatic**: All P1 and P2 incidents
- **Optional**: P3 incidents if complexity requires
- **Communication**: IRT activated via email/Slack with incident details
- **Availability**: IRT members must be reachable within response time SLAs

### 6.3 IRT Responsibilities
- **Incident Manager**: Coordinate response; make decisions; communicate with stakeholders
- **Technical Lead**: Execute technical response; forensics; recovery
- **Communications Lead**: Draft customer notifications; manage external communications
- **Support Lead**: Provide operational support; user assistance; monitoring
- **All members**: Document actions; preserve evidence; participate in post-incident review

---

## 7. Communication Protocols

### 7.1 Internal Communication
**Incident Chat Channel**: Create dedicated Slack/Teams channel per incident (e.g., #inc-2024-001)  
**Status Updates**: Every 2 hours for P1; every 4 hours for P2; daily for P3/P4  
**Escalation**: Managing Director notified immediately for P1; within 4 hours for P2  
**All Staff**: Briefed on P1 incidents; may require awareness notifications

### 7.2 Customer Communication

#### 7.2.1 Notification Triggers
**Immediate Notification** (within 2 hours):
- Service outage affecting customer access
- Confirmed or suspected customer data breach
- Extended service degradation (>1 hour)

**Within 24 Hours**:
- Incident investigation completed
- Mitigation actions taken
- Ongoing monitoring

**Within 72 Hours**:
- Incident closure or extended timeline communicated
- Root cause summary (if not confidential)
- Steps taken to prevent recurrence

#### 7.2.2 Communication Content
- Clear, non-technical language
- What happened
- What data/services affected
- What actions we've taken
- What customers should do (if anything)
- Contact for questions
- Expected resolution timeline

#### 7.2.3 Communication Channels
- Email to affected customers
- Status page update (if available)
- In-app notifications (if applicable)
- Phone calls for critical incidents (P1 affecting specific customers)

### 7.3 Regulatory Notification

#### 7.3.1 GDPR Data Breach Notification
**To ICO (Information Commissioner's Office)**:
- **Timeline**: Within 72 hours of becoming aware of breach
- **Trigger**: Personal data breach likely to result in risk to individuals
- **Method**: ICO online reporting tool
- **Content**: Nature of breach, categories and approximate number of data subjects, likely consequences, measures taken/proposed

**To Data Subjects**:
- **Timeline**: Without undue delay
- **Trigger**: Breach likely to result in high risk to individuals
- **Method**: Direct communication (email, letter, or prominent website notice)
- **Content**: Clear description, consequences, measures taken, contact point

#### 7.3.2 Other Regulatory Notifications
- **FCA**: If financial services affected
- **Industry regulators**: As required by sector
- **Law enforcement**: For criminal activity (cybercrime, fraud)

### 7.4 Media and Public Communications
- **Spokesperson**: Business Development Director (authorized only)
- **Approval**: All public statements approved by Managing Director
- **Legal review**: External counsel consulted for significant incidents
- **Consistency**: All channels communicate consistent message
- **Transparency**: Balanced with security and privacy considerations

---

## 8. Evidence Collection and Preservation

### 8.1 Evidence Types
- **Log files**: CloudTrail, CloudWatch, VPC Flow Logs, application logs
- **System snapshots**: EC2 EBS snapshots, RDS snapshots
- **Network captures**: VPC Flow Logs, WAF logs
- **Email**: Phishing emails, suspicious communications
- **Screenshots**: GuardDuty findings, Security Hub alerts
- **File hashes**: Malware samples, modified files

### 8.2 Evidence Handling
**Chain of Custody**:
1. Document who collected evidence, when, and from where
2. Store evidence in read-only, tamper-proof location
3. Calculate and record file hashes (SHA-256)
4. Limit access to authorized investigators only
5. Log all access to evidence
6. Retain evidence until incident fully closed and reviewed

**AWS Evidence Collection**:
- **CloudTrail logs**: Export to isolated S3 bucket with object lock
- **EC2 instances**: Create snapshots; do not terminate
- **S3 buckets**: Enable versioning and object lock; export logs
- **RDS**: Create manual snapshot before any recovery actions
- **Security groups/IAM**: Export current configuration to JSON
- **GuardDuty findings**: Export full details including sample events

### 8.3 Evidence Retention
- **Active incident**: Evidence retained until incident closed
- **Closed incident**: Minimum 12 months after closure
- **Legal proceedings**: Retained as directed by legal counsel
- **Compliance**: Aligned with data retention policy

### 8.4 Forensic Analysis
- **External experts**: Engaged for P1 incidents or complex investigations
- **Forensic tools**: Approved tools only (document forensic actions)
- **Analysis environment**: Isolated from production; no contamination
- **Reporting**: Forensic findings documented in incident report

---

## 9. Incident Response Procedures

### 9.1 Initial Response Checklist (First 30 Minutes)

**For All Incidents**:
- [ ] Report incident to ISMS Lead
- [ ] Create incident ticket (INC-YYYY-NNN)
- [ ] Classify severity (P1-P4)
- [ ] Document initial details
- [ ] Preserve evidence (logs, snapshots)
- [ ] Activate IRT if P1/P2

**For Data Breach Incidents**:
- [ ] Assess if personal data involved
- [ ] Estimate number of affected individuals
- [ ] Start 72-hour GDPR notification clock
- [ ] Notify Managing Director immediately
- [ ] Prepare draft customer notification

**For Availability Incidents**:
- [ ] Check AWS Service Health Dashboard
- [ ] Review CloudWatch metrics and alarms
- [ ] Verify backup systems operational
- [ ] Enable additional monitoring if needed
- [ ] Prepare customer status update

### 9.2 AWS-Specific Incident Response

#### 9.2.1 Compromised AWS Account/Credentials
**Immediate Actions**:
1. Rotate all access keys via AWS IAM console
2. Disable compromised IAM user
3. Review CloudTrail for unauthorized actions (last 90 days)
4. Check for unauthorized resource creation (EC2, S3, Lambda)
5. Enable CloudWatch billing alarms (detect cryptocurrency mining)
6. Review IAM policies for unauthorized changes
7. Contact AWS Support (Enterprise Support Plan if available)
8. Reset root account password if suspected compromise

#### 9.2.2 EC2 Instance Compromise
**Immediate Actions**:
1. Isolate instance (modify security group to deny all traffic except forensics)
2. Create EBS snapshot for forensics
3. Collect memory dump if possible
4. Export CloudWatch logs
5. Check GuardDuty findings for IOCs
6. Review VPC Flow Logs for C2 communication
7. Terminate instance (after forensics complete)
8. Launch clean instance from approved AMI

#### 9.2.3 S3 Data Breach
**Immediate Actions**:
1. Review S3 access logs and CloudTrail
2. Identify what data was accessed/downloaded
3. Verify bucket public access block settings
4. Check bucket policies for misconfigurations
5. Enable S3 Object Lock if not already enabled
6. Review IAM policies with S3 access
7. Assess GDPR notification requirements
8. Prepare customer notifications

#### 9.2.4 RDS Database Breach
**Immediate Actions**:
1. Review RDS audit logs and CloudTrail
2. Identify compromised credentials or SQL injection vector
3. Create manual RDS snapshot
4. Rotate database credentials via AWS Secrets Manager
5. Review application code for SQL injection vulnerabilities
6. Check security group rules
7. Enable enhanced monitoring if not active
8. Assess data exfiltration scope
9. Prepare GDPR breach notification

#### 9.2.5 DDoS Attack
**Immediate Actions**:
1. Review WAF metrics and CloudWatch ALB metrics
2. Identify attack pattern and source IPs
3. Update WAF rules to block attack traffic
4. Enable AWS Shield Standard protections (verify active)
5. Consider AWS Shield Advanced if attack severe
6. Scale ASG if legitimate traffic surge
7. Contact AWS Support for assistance
8. Communicate with customers about service degradation

---

## 10. GDPR Data Breach Response

### 10.1 72-Hour Notification Requirement
**ICO Notification Required When**:
- Personal data breach likely to result in risk to individuals' rights and freedoms
- Breach involves special category data (health, biometric, etc.)
- Uncertainty whether high risk → report to be safe

**ICO Notification NOT Required When**:
- Encrypted data with keys not compromised
- Immediate corrective action eliminates risk
- Risk to individuals demonstrably unlikely

### 10.2 Breach Assessment (Within 24 Hours)
**ISMS Lead determines**:
1. Is personal data involved? (Yes/No)
2. How many individuals affected? (Estimate)
3. What categories of data? (Names, emails, financial, health, etc.)
4. Was data encrypted? (KMS keys compromised?)
5. What is likelihood of harm to individuals? (Low/Medium/High)
6. Do we need to notify ICO? (Yes/No/Uncertain)
7. Do we need to notify individuals? (If high risk)

**Documentation**:
- Breach assessment form completed
- Decision rationale documented
- Managing Director sign-off on notification decision

### 10.3 ICO Notification Content
**Required Information**:
- Nature of the personal data breach
- Name and contact details of Data Protection Officer (Akam Rahimi, akam@epact.co.uk)
- Likely consequences of the breach
- Measures taken or proposed to address the breach
- Measures taken to mitigate possible adverse effects

**Submission**: Via ICO online portal (https://ico.org.uk/make-a-complaint/data-protection-complaints/)

### 10.4 Data Subject Notification
**Required When**: Breach likely to result in high risk to individuals

**Communication Must Include**:
- Description of breach in clear, plain language
- Contact point for more information (akam@epact.co.uk)
- Likely consequences
- Measures taken to address breach and mitigate effects
- Recommendations for individuals (e.g., password reset, fraud monitoring)

**Exemptions from Direct Notification**:
- Disproportionate effort (may use public communication)
- Technical protection measures render data unintelligible (e.g., strong encryption)
- Subsequent measures ensure high risk no longer likely

---

## 11. Incident Containment Strategies

### 11.1 Network Isolation
- Modify security groups to block malicious traffic
- Add WAF rules to block attack patterns
- Implement temporary IP blacklists
- Isolate compromised subnet/AZ if needed

### 11.2 Account Lockdown
- Disable compromised user accounts
- Revoke active sessions
- Force password reset for potentially affected users
- Rotate service account credentials
- Review and restrict IAM permissions

### 11.3 System Isolation
- Tag compromised resources ("quarantined")
- Move to isolated security group
- Preserve for forensics; do not delete
- Deploy replacement from clean images

---

## 12. Incident Recovery

### 12.1 Recovery Objectives
- **RTO (Recovery Time Objective)**: 4 hours for critical services
- **RPO (Recovery Point Objective)**: 24 hours maximum data loss

### 12.2 Recovery Procedures
See detailed procedures in:
- `docs/backup-restore-runbook.md` for RDS and S3 restoration
- `docs/disaster-recovery-test.md` for DR testing scenarios
- Infrastructure documentation for rebuilding with Terraform

### 12.3 Post-Recovery Verification
- All security controls operational
- No residual malicious activity
- Monitoring and logging functioning
- Performance within normal parameters
- Customers notified of resolution

---

## 13. Incident Documentation

### 13.1 Incident Report Template
**Executive Summary**:
- Incident ID, severity, status
- Brief description
- Impact summary
- Timeline (detection to resolution)

**Detailed Incident Information**:
- Detection method and time
- Affected systems and data
- Root cause analysis
- Actions taken (chronological)
- Evidence collected
- Containment and eradication steps
- Recovery actions
- Customer/regulatory notifications sent

**Lessons Learned**:
- What worked well
- What could be improved
- Action items for improvement
- Policy/procedure updates needed
- Training recommendations

**Approvals**:
- Prepared by: [Incident Owner]
- Reviewed by: ISMS Lead
- Approved by: Managing Director

### 13.2 Incident Metrics
Track and report:
- Number of incidents per month (by severity)
- Mean Time to Detect (MTTD)
- Mean Time to Respond (MTTR)
- Mean Time to Recover (MTTR)
- Incident sources (GuardDuty, employee report, customer, etc.)
- Incident categories (access, malware, DDoS, etc.)
- Repeat incidents (same root cause)
- Compliance with response time SLAs

---

## 14. Special Incident Types

### 14.1 Ransomware
**Response**:
- Do NOT pay ransom
- Isolate affected systems immediately
- Preserve encrypted files for forensics
- Restore from backups (AWS Backup daily/weekly)
- Report to National Crime Agency (NCA)
- Notify customers if their data affected

### 14.2 Phishing/Social Engineering
**Response**:
- Identify affected users
- Reset credentials
- Scan systems for malware
- Review email logs for data exfiltration
- Training for affected users
- Company-wide security awareness reminder

### 14.3 Insider Threat
**Response**:
- Immediately disable account
- Preserve all access logs (CloudTrail, application logs)
- Review recent activity for data exfiltration
- Engage HR and legal counsel
- Conduct confidential investigation
- Employee termination procedures if confirmed

### 14.4 Third-Party/Supply Chain Incident
**Response**:
- Assess impact on EPACT systems
- Contact supplier for status and remediation
- Review supplier access and revoke if necessary
- Implement compensating controls
- Consider alternative suppliers
- Update supplier risk assessment

---

## 15. Testing and Training

### 15.1 Tabletop Exercises
**Frequency**: Bi-annually (every 6 months)  
**Participants**: IRT members  
**Scenarios**: Data breach, DDoS, ransomware, insider threat  
**Duration**: 2-3 hours  
**Facilitator**: ISMS Lead or external consultant  
**Deliverables**: Exercise report, improvement recommendations

### 15.2 Live DR Testing
**Frequency**: Annually  
**Scope**: See `docs/disaster-recovery-test.md`  
**Scenarios**: RDS restore, EC2 recovery, S3 bucket restoration  
**Success Criteria**: Meet RTO (4 hours) and RPO (24 hours)

### 15.3 Incident Response Training
**For All Staff** (annually):
- How to recognize and report incidents
- Reporting channels
- What not to do (don't delete evidence)
- GDPR data breach awareness

**For IRT Members** (bi-annually):
- Role-specific responsibilities
- Evidence collection techniques
- Communication protocols
- Use of incident response tools
- Scenario-based practice

---

## 16. Incident Severity Examples

### P1 - Critical Examples
- Customer database fully compromised and downloaded
- Ransomware encrypting production systems
- Complete AWS account takeover
- Multi-day service outage across all tenants
- Active data exfiltration in progress
- Root account credentials publicly exposed

### P2 - High Examples
- Single EC2 instance compromised
- GuardDuty high-severity finding (cryptocurrency mining)
- Prolonged service degradation (>1 hour)
- Single tenant data exposure
- Successful phishing attack with credential compromise
- Unauthorized IAM policy changes

### P3 - Medium Examples
- Misconfigured security group (quickly corrected)
- Failed authentication spike from single IP
- Vulnerability discovered in non-production system
- Lost laptop with encrypted data
- Suspicious but unsuccessful attack attempts
- Policy violation (unauthorized data export)

### P4 - Low Examples
- Single failed login (legitimate user error)
- GuardDuty low-severity informational finding
- Minor security policy violation
- Suspicious email reported (verified safe)
- Outdated software component (no active exploit)

---

## 17. External Support

### 17.1 AWS Support
- **Support Plan**: Business or Enterprise Support recommended
- **Contacts**: AWS TAM (Technical Account Manager) if available
- **Use Cases**: Complex incidents, AWS service issues, architecture review
- **Contact Method**: AWS Support console or phone

### 17.2 Incident Response Consultants
- **Pre-vetted**: List of approved IR firms maintained
- **Engagement**: For P1 incidents beyond internal capability
- **Services**: Forensics, malware analysis, legal support
- **NDAs**: In place before engagement

### 17.3 Law Enforcement
- **National Crime Agency (NCA)**: Cybercrime reporting
- **Action Fraud**: Fraud reporting (https://www.actionfraud.police.uk/)
- **Local Police**: Physical security incidents
- **Engagement**: Through legal counsel for major incidents

---

## 18. Continuous Improvement

### 18.1 Incident Trend Analysis
**Quarterly Analysis**:
- Identify recurring incident types
- Root cause patterns
- Control effectiveness
- Detection capability gaps

**Actions**:
- Update controls to address patterns
- Improve detection rules
- Enhanced training on common issues
- Policy updates

### 18.2 Post-Incident Actions Tracking
- All improvement actions logged in tracking system
- Assigned owners and due dates
- Progress reviewed in monthly operations meetings
- Completion verified before closing incident

---

## 19. Compliance and Audit

### 19.1 ISO 27001 Requirements
- Documented incident management process
- Evidence of incident handling
- Records of incidents and responses
- Lessons learned and improvements
- Regular testing and training

### 19.2 Audit Trail
Maintained for auditors:
- Incident register (all incidents)
- Incident reports (detailed)
- Evidence files (preserved)
- Communications (customer, regulatory)
- Post-incident reviews
- Training records
- Testing exercise reports

---

## 20. Related Documents

- Information Security Policy
- Data Protection and Privacy Policy
- Risk Management Policy
- Business Continuity and Disaster Recovery Policy
- Backup and Restore Runbook (docs/backup-restore-runbook.md)
- Disaster Recovery Test Plan (docs/disaster-recovery-test.md)
- GDPR Data Breach Response Procedure (to be created)

---

## 21. Appendices

### Appendix A: Incident Report Template
[Available as separate document]

### Appendix B: GDPR Breach Assessment Form
[Available as separate document]

### Appendix C: Customer Notification Template
[Available as separate document]

### Appendix D: Incident Response Checklist
[Available as separate document]

### Appendix E: Emergency Contact List
[Maintained separately; restricted access]

---

## 22. Management Approval

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

**Emergency Contact**: Akam Rahimi, akam@epact.co.uk, [Phone]

