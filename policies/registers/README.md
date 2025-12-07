# EPACT LTD - Registers and Logs

**ISO 27001:2022 Compliance - Operational Registers**

---

## Overview

This directory contains operational registers and logs required for ISO 27001 compliance and effective ISMS operation. These registers provide evidence of security control implementation and support audit requirements.

**Owner**: Akam Rahimi, ISMS Lead  
**Contact**: akam@epact.co.uk

---

## Register Index

| Register Name | File | Owner | Update Frequency | Purpose |
|--------------|------|-------|-----------------|---------|
| **Risk Register** | `risk-register.csv` | ISMS Lead | Monthly / Ad-hoc | Track information security risks, treatments, and status |
| **Asset Register** | `asset-register.csv` | Senior Developer | Quarterly | Inventory of all information assets (physical, cloud, data) |
| **Incident Register** | `incident-register.csv` | ISMS Lead | Per incident | Log all security incidents and response actions |
| **Data Breach Register** | `data-breach-register.csv` | DPO | Per breach | GDPR Article 33 - Record all personal data breaches |
| **Supplier Register** | `supplier-register.csv` | Managing Director | Quarterly | Track suppliers, security assessments, DPAs |
| **User Access Register** | `user-access-register.csv` | Support Team | Real-time / Quarterly review | All user accounts and access permissions |
| **Data Subject Rights Register** | `data-subject-rights-register.csv` | DPO | Per request | GDPR rights requests (SAR, erasure, portability, etc.) |
| **Training Register** | `training-register.csv` | ISMS Lead | Per training event | Security training completion and certification |
| **Asset Disposal Log** | `asset-disposal-log.csv` | ISMS Lead | Per disposal | Secure disposal of assets and data sanitization |

---

## Register Descriptions

### 1. Risk Register (`risk-register.csv`)

**Purpose**: Central repository of all identified information security risks

**Contents**:
- Risk ID, title, description
- Assets affected, threat sources
- Likelihood and impact ratings (1-5 scale)
- Inherent and residual risk scores
- Risk treatment (mitigate, accept, transfer, avoid)
- Control effectiveness
- Risk owner and status
- Review dates and notes

**Usage**:
- Updated monthly by ISMS Lead
- Reviewed quarterly with Managing Director
- New risks added as identified (risk assessments, incidents, audits)
- Completed risks archived (status changed to "Closed")

**Examples Provided**:
- RISK-2024-001: Terraform state unauthorized access
- RISK-2024-002: Multi-tenant data leakage
- RISK-2024-003: RDS database failure
- Plus 12 more example risks covering AWS infrastructure

**Audit Evidence**: Demonstrates systematic risk management per ISO 27001 Clause 6.1

---

### 2. Asset Register (`asset-register.csv`)

**Purpose**: Inventory of all EPACT information assets

**Asset Types**:
- **Cloud Infrastructure**: AWS resources (VPC, EC2, RDS, S3, Lambda, KMS, etc.)
- **Physical**: Laptops, phones, MFA tokens, network equipment
- **Software**: Applications, tools, licenses
- **Data**: Databases, repositories, documents
- **Services**: AWS, SaaS subscriptions, external services

**Contents**:
- Asset ID, type, name, description
- Classification (RESTRICTED/CONFIDENTIAL/INTERNAL/PUBLIC)
- Owner and custodian
- Location (AWS region, physical location)
- Value and purchase date
- Review dates and tags

**Usage**:
- Updated quarterly (scheduled review)
- Updated real-time for new assets or disposals
- Annual physical asset audit (verify laptops, phones)
- AWS assets tracked via Terraform state and resource tags

**Examples Provided**:
- AWS infrastructure assets (VPC, ASG, RDS, S3, KMS keys)
- Physical assets (laptops, phones, MFA tokens)
- Software and services
- Critical data assets

**Audit Evidence**: ISO 27001 A.5.9 (Asset inventory)

---

### 3. Incident Register (`incident-register.csv`)

**Purpose**: Log all security incidents, events, and response actions

**Contents**:
- Incident ID, detection date/time, reported by
- Title, description, severity (P1-P4)
- Systems and data affected
- Detection method (GuardDuty, CloudWatch, employee report)
- IRT activation status
- Containment, eradication, recovery actions
- Root cause and lessons learned
- Customer/ICO notifications
- Resolution date and metrics (MTTD, MTTR)
- Post-incident review reference

**Usage**:
- New entry for every reported incident (even false alarms)
- Updated as incident progresses (status changes)
- Closed incidents retained for trend analysis
- Reviewed monthly for patterns
- Annual comprehensive review

**Examples Provided**:
- INC-2024-001: Failed login spike (P3)
- INC-2024-002: GuardDuty high severity finding (P2)
- INC-2024-003: Accidental S3 public exposure (P2)

**Audit Evidence**: ISO 27001 A.5.24-A.5.26 (Incident management)

---

### 4. Data Breach Register (`data-breach-register.csv`)

**Purpose**: GDPR Article 33 requirement - document all personal data breaches

**Contents**:
- Breach ID, detection date, type
- Personal data categories and number of individuals
- Special category data (if any)
- Severity and harm assessment
- ICO notification decision and date
- Individual notification decision and date
- Containment, investigation, root cause
- Remediation and prevention measures
- Encryption status and key compromise
- Resolution and DPO assessment

**Usage**:
- Entry created for every suspected personal data breach
- Even if ICO notification not required, breach must be documented (GDPR accountability)
- DPO assesses within 24 hours
- Managing Director approves ICO notification decisions
- Reviewed quarterly
- Retained for 7 years (legal requirement)

**Examples Provided**:
- BR-2024-001: Accidental email disclosure (25 individuals, low risk, no ICO notification)
- Template row for future breaches

**Audit Evidence**: GDPR Article 33(5) - Documentation of all breaches

---

### 5. Supplier Register (`supplier-register.csv`)

**Purpose**: Track all suppliers and third-party service providers

**Contents**:
- Supplier ID, name, type
- Contact information
- Services provided and classification (Critical/Important/Standard)
- Contract dates and annual cost
- Data processing details (personal data? DPA in place?)
- Security assessment date and score
- Certifications (ISO 27001, SOC 2, PCI DSS)
- SLA uptime commitments
- Review dates and risk level
- Contract manager and notes

**Usage**:
- New supplier assessed before engagement (using Supplier Security Questionnaire)
- Registered upon contract signing
- Annual security review (recertification verification, performance review)
- Critical suppliers reviewed quarterly
- Updated when contract changes or renewed

**Examples Provided**:
- SUP-001: AWS (primary critical supplier)
- SUP-002: Email provider
- SUP-003: Git repository hosting
- Plus 7 more typical suppliers (domain registrar, VPN, payment processor, pen testing, insurance, legal, certification body)

**Audit Evidence**: ISO 27001 A.5.19-A.5.23 (Supplier relationships)

---

### 6. User Access Register (`user-access-register.csv`)

**Purpose**: Track all user accounts and access permissions

**Contents**:
- Access ID, user name, employee ID
- Position and email
- Access type (AWS IAM, application, database)
- Access level and permissions
- Business justification
- Approval chain (who approved, when)
- Provisioning details
- Last access date
- Quarterly review results
- MFA status
- Account status (Active/Suspended/Revoked)
- Revocation date and reason

**Usage**:
- New entry for every access grant (user or service account)
- Updated when access modified
- Quarterly access review (recertification)
- Revoked access retained (audit trail)
- Supports Access Control Policy compliance

**Examples Provided**:
- ACC-001: Akam Rahimi (Managing Director, full admin)
- ACC-002-007: Employee accounts (various roles)
- ACC-008-010: Service accounts (Terraform, Lambda, Backup)
- ACC-011: Contractor (time-limited)
- ACC-012: Former employee (revoked)

**Audit Evidence**: ISO 27001 A.5.15, A.5.18, A.8.2, A.8.3 (Access control)

---

### 7. Data Subject Rights Register (`data-subject-rights-register.csv`)

**Purpose**: GDPR - Track all data subject rights requests and responses

**Contents**:
- Request ID, receipt date
- Request type (Access, Rectification, Erasure, Portability, Restriction, Object)
- Data subject details and identity verification
- Complexity assessment and extensions
- Response deadline (30 or 90 days)
- Data located and actions taken
- Response date and outcome (Fulfilled/Refused/Partial)
- Fees charged (if applicable - usually £0)
- Completion notes

**Usage**:
- Entry for every data subject rights request
- Updated as request processed
- 30-day deadline tracked carefully
- Extensions documented with data subject notification
- Refused requests require detailed justification
- Review quarterly for trends

**Examples Provided**:
- DSR-2024-001: Subject Access Request (SAR)
- DSR-2024-002: Right to erasure (tenant account closure)
- DSR-2024-003: Data portability (large export)
- DSR-2024-004: Objection to marketing
- DSR-2024-005: Rectification (email update)

**Audit Evidence**: GDPR Articles 15-22 (Data subject rights)

---

### 8. Training Register (`training-register.csv`)

**Purpose**: Track security training completion and certifications

**Contents**:
- Training ID, employee details
- Course name and type (mandatory/optional)
- Training date, provider, duration
- Completion status and test scores
- Pass/fail and certificates
- Expiry and refresher dates
- Topics covered and notes

**Usage**:
- Entry for every training event
- Annual mandatory training tracked (100% completion required)
- Certifications and expiry dates monitored
- Non-completion escalated (access suspended until training complete)
- Reviewed monthly for upcoming refreshers

**Examples Provided**:
- ISO 27001 Lead Implementer (Akam Rahimi)
- GDPR Practitioner (Akam Rahimi)
- Annual security awareness (all staff)
- AWS Security Best Practices
- OWASP Secure Coding
- Phishing simulations
- DR tabletop exercise
- Incident response training

**Audit Evidence**: ISO 27001 Clause 7.2, 7.3 (Competence and awareness)

---

### 9. Asset Disposal Log (`asset-disposal-log.csv`)

**Purpose**: Record secure disposal of assets and data sanitization

**Contents**:
- Disposal ID, asset ID, asset details
- Classification and disposal date
- Disposal reason and approval
- Disposal method (WEEE, destruction, wipe)
- Data sanitization method and verification
- Certificate of destruction
- Disposal service provider and cost
- Witness and asset register update status

**Usage**:
- Entry for every disposed asset (physical or cloud)
- RESTRICTED assets require ISMS Lead approval and certified destruction
- Certificates of destruction filed
- Annual review of disposal practices
- Compliance with GDPR (secure deletion of personal data)

**Examples Provided**:
- DISP-2024-001: Laptop disposal (secure wipe + shredding)
- DISP-2024-002: USB drive destruction
- DISP-2024-003: AWS EC2 instance deletion
- DISP-2024-004: Mobile phone trade-in
- DISP-2024-005: S3 tenant bucket deletion (GDPR erasure)
- DISP-2024-006: KMS key deletion (rotation)

**Audit Evidence**: ISO 27001 A.5.10, A.5.12, A.7.14 (Asset disposal), GDPR (secure deletion)

---

## File Formats and Access

### Format
- **CSV** (Comma-Separated Values): Easy to import into Excel, Google Sheets, database tools
- **UTF-8 encoding**: Supports international characters
- **Headers**: First row contains column names

### Recommended Tools
- **Excel / Google Sheets**: For viewing and editing
- **Database**: Import into MySQL/PostgreSQL for queries and reporting
- **GRC Tools**: Import into governance/risk/compliance platforms (future)

### Access Control
**CONFIDENTIAL** - Restricted Access

| Register | Access Level |
|----------|-------------|
| Risk Register | ISMS Lead, Managing Director, External Auditors |
| Asset Register | ISMS Lead, Senior Developer, Managing Director, Auditors |
| Incident Register | ISMS Lead, IRT Members, Managing Director, Auditors |
| Data Breach Register | DPO, Managing Director, Auditors (ICO if requested) |
| Supplier Register | Managing Director, ISMS Lead, Auditors |
| User Access Register | ISMS Lead, Support Team (provisioning), Managing Director, Auditors |
| Data Subject Rights Register | DPO, Managing Director, Auditors |
| Training Register | ISMS Lead, HR/Line Managers, Managing Director, Auditors |
| Asset Disposal Log | ISMS Lead, Managing Director, Auditors |

**Storage**: 
- Company secure file storage (Google Drive with restricted access / OneDrive)
- Git repository (encrypted, restricted access)
- Backup: Included in business data backups

---

## Maintenance Schedule

| Register | Update Trigger | Review Frequency | Retention |
|----------|---------------|-----------------|-----------|
| Risk Register | New risks; monthly review; quarterly management review | Monthly | Active risks + 3 years after closure |
| Asset Register | New assets; disposals; quarterly audit | Quarterly | Current + 7 years historical |
| Incident Register | Every incident | Monthly (trend analysis) | Indefinite (incident history) |
| Data Breach Register | Every suspected breach | Quarterly | 7 years minimum (GDPR legal requirement) |
| Supplier Register | New suppliers; annual reviews | Quarterly (critical); Annually (all) | Duration of contract + 3 years |
| User Access Register | Access changes; quarterly reviews | Quarterly (recertification) | Current + terminated users 3 years |
| Data Subject Rights Register | Every rights request | Quarterly | 3 years |
| Training Register | Every training event | Monthly (upcoming refreshers) | Employee duration + 3 years |
| Asset Disposal Log | Every disposal | Annual (disposal practice review) | 7 years |

---

## How to Use These Registers

### Adding New Entries

**Step 1**: Open CSV file in Excel/Google Sheets

**Step 2**: Copy template row (usually last row or marked "TEMPLATE")

**Step 3**: Paste as new row

**Step 4**: Fill in all required fields:
- IDs: Follow format (RISK-YYYY-NNN, INC-YYYY-NNN, etc.)
- Dates: Use ISO format (YYYY-MM-DD) or DD/MM/YYYY consistently
- Status: Select from defined values (Open/Closed, Active/Suspended, etc.)
- Free text: Be concise but complete

**Step 5**: Save file

**Step 6**: Update related systems:
- If asset: Update AWS tags or asset tracking system
- If incident: Create incident folder for evidence
- If breach: Complete GDPR Breach Assessment Form

**Step 7**: Backup (if not auto-backed up)

### Example Workflows

**New Security Incident**:
1. Incident detected (GuardDuty alert / employee report)
2. Open `incident-register.csv`
3. Add new row with next incident ID (INC-2024-004)
4. Fill in detection details, severity, systems affected
5. Assign to ISMS Lead
6. Update status as incident progresses
7. Link to incident report form (once completed)
8. Close incident when resolved
9. If personal data involved: Also create breach register entry

**Quarterly Access Review**:
1. Open `user-access-register.csv`
2. Filter to accounts with next review date = this quarter
3. For each account:
   - Verify still employed/active
   - Confirm access still needed (check with line manager)
   - Review last access date (unused accounts flagged)
   - Update "Review Result" column (Retain/Modify/Revoke)
   - Set next review date (+3 months)
4. Take actions (revoke unused, modify changed roles)
5. Document review completion (sign-off by ISMS Lead)

**Risk Assessment Update**:
1. Open `risk-register.csv`
2. Filter to risks with review date = this month
3. For each risk:
   - Reassess likelihood and impact (any changes?)
   - Review control effectiveness
   - Update residual risk score
   - Verify treatment plan on track (if mitigating)
   - Set next review date
4. Add new risks identified
5. Close resolved risks (status = "Closed")
6. Generate risk dashboard for management (top 10 risks, trends)

---

## Reporting from Registers

### Monthly Security Dashboard

**Sources**:
- Incident Register: Incidents this month, severity breakdown, MTTD/MTTR
- Risk Register: New risks, high/critical risks, overdue treatments
- Training Register: Training completion rate, upcoming refreshers
- Data Breach Register: Any breaches this month

**Generated Report**:
- Executive summary (1 page)
- Key metrics and KPIs
- Trends (improving/declining)
- Action items for management
- Sent to Managing Director monthly

### Quarterly Management Review

**Sources**: All registers

**Analysis**:
- Risk trends (increasing/decreasing)
- Incident trends (recurring issues?)
- Asset changes (new critical assets)
- Compliance status (training completion, access reviews)
- Supplier performance
- GDPR compliance (rights requests, breaches)

**Output**: Management review meeting agenda and reports

### Annual ISO 27001 Audit

**Evidence Provided**:
- All registers (current state)
- Historical changes (demonstrate continuous management)
- Review meeting minutes (evidencing oversight)
- Action completion (corrective actions from findings)

---

## Privacy and Confidentiality

### Sensitive Information in Registers

**Personal Data**: Registers contain personal data (names, emails, incident details)

**Data Protection**:
- Access restricted (role-based)
- Encrypted storage
- No sharing outside EPACT (except auditors under NDA)
- GDPR processing basis: Legitimate interests (security management) + Legal obligation (audit requirements)
- Retention per schedules (then secure deletion)

**Special Handling**:
- Data Breach Register: Extra sensitivity (breach details confidential)
- Incident Register: May contain sensitive investigation details
- Access logs: Who accessed which register (audit trail)

---

## Backup and Recovery

**Backup Strategy**:
- **Frequency**: Daily (as part of business data backups)
- **Method**: Cloud storage provider backups + Git version control (if committed)
- **Encryption**: Yes (cloud storage encryption)
- **Testing**: Quarterly (restore test of registers)

**Recovery**:
- If registers lost/corrupted: Restore from previous backup
- If recent entries lost: Reconstruct from other sources (incident reports, AWS CloudTrail, email records)

---

## Integration with Policies

**Registers Support Policy Implementation**:

| Policy | Register(s) Used |
|--------|-----------------|
| Risk Management Policy | Risk Register |
| Asset Management Policy | Asset Register, Asset Disposal Log |
| Incident Management Policy | Incident Register, Data Breach Register |
| Access Control Policy | User Access Register |
| Data Protection Policy | Data Subject Rights Register, Data Breach Register |
| Supplier Relationships Policy | Supplier Register |
| Human Resources Security Policy | Training Register, User Access Register |
| Operations Security Policy | Incident Register, Asset Register |

---

## Quality and Accuracy

### Data Quality Standards

**Accuracy**:
- Entries verified before committing
- Periodic spot checks (10% sample quarterly)
- Annual comprehensive review

**Completeness**:
- All required fields completed (no blanks in critical columns)
- Template rows guide proper completion
- Validation rules in spreadsheet (if using Excel)

**Consistency**:
- IDs follow format (PREFIX-YYYY-NNN)
- Dates in consistent format
- Status values from defined list
- Naming conventions followed

**Timeliness**:
- Real-time for critical registers (incidents, access)
- Within 1 week for scheduled registers (assets)
- Review dates enforced (reminders set)

---

## Continuous Improvement

### Register Evolution

**Feedback Welcome**:
- Additional columns needed?
- Better categorization?
- Integration with tools (GRC platforms)?
- Automation opportunities?

**Changes Managed**:
- Propose changes to ISMS Lead
- Assess impact (audit requirements, usability)
- Approve changes (Managing Director)
- Migrate data to new format
- Update documentation
- Communicate changes to users

---

## Related Documents

**Policies**:
- All 20 ISO 27001 policies reference these registers

**Forms**:
- `../forms/` - Forms that populate these registers

**Templates**:
- `../templates/` - Templates that reference these registers

**Technical Documentation**:
- `../../docs/` - Infrastructure documentation

---

## Support and Questions

**For register-related questions**:
- **ISMS Lead**: Akam Rahimi, akam@epact.co.uk
- **Technical Issues**: Senior Developer (asset register, incident register)
- **GDPR/Privacy**: DPO (Akam Rahimi) for breach and rights registers

**For making updates**:
- Access request: Email ISMS Lead
- Training on register use: Contact ISMS Lead
- Reporting from registers: Request from ISMS Lead

---

**Document Owner**: Akam Rahimi, ISMS Lead  
**Last Updated**: [Date]  
**Next Review**: [Date + 12 months]

---

**CONFIDENTIAL - Internal Use Only**

