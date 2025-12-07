# EPACT LTD - Forms

**ISO 27001 & GDPR Compliance Forms**

---

## Overview

This directory contains operational forms for day-to-day ISMS activities. Forms are used to initiate processes, document decisions, and maintain compliance evidence.

**Owner**: Akam Rahimi, ISMS Lead  
**Contact**: akam@epact.co.uk

---

## Form Index

| Form Name | File | Purpose | Completed By | Frequency |
|-----------|------|---------|-------------|-----------|
| **Incident Report Form** | `incident-report-form.md` | Document security incidents from detection to resolution | IRT / ISMS Lead | Per incident |
| **GDPR Breach Assessment Form** | `gdpr-breach-assessment-form.md` | Assess personal data breaches for ICO/individual notification | DPO | Per suspected breach |
| **Change Request Form** | `change-request-form.md` | Request and approve infrastructure/system changes | Requestor, Approvers | Per change |
| **Access Request Form** | `access-request-form.md` | Request user access provisioning/modification/removal | Line Manager, ISMS Lead | Per access change |
| **Asset Disposal Form** | `asset-disposal-form.md` | Request secure disposal of assets with data sanitization | Asset Owner, ISMS Lead | Per disposal |

---

## Form Descriptions

### 1. Incident Report Form
**Purpose**: Comprehensive incident documentation from detection through post-incident review

**Key Sections**:
- Incident identification and classification (P1-P4 severity)
- Detailed incident description (what, when, where, who)
- Impact assessment (confidentiality, integrity, availability)
- Initial response and evidence preservation
- IRT activation and member roles
- Containment, eradication, recovery actions
- Investigation findings and root cause
- Communication (internal, customers, regulatory)
- Metrics (MTTD, MTTR)
- Lessons learned and action items
- Approvals (ISMS Lead, Managing Director)

**Completion**: During and after incident; finalized within 5 business days of closure

**Filed**: /policies/incident-reports/INC-YYYY-NNN/ (with evidence)

**Retention**: 12 months minimum; longer if legal/audit requirements

---

### 2. GDPR Breach Assessment Form
**Purpose**: Structured assessment for GDPR breach notification decision

**Key Sections**:
1. Is this a personal data breach? (definition check)
2. Breach details (data categories, special category, number of individuals)
3. Risk assessment (cause, encryption status, likelihood of harm)
4. Notification decision (ICO required? Individuals required?)
5. Notification content and timeline
6. Remediation and prevention measures
7. DPO assessment and Managing Director approval
8. Post-breach follow-up

**Critical Deadlines**:
- **Assessment**: Within 24 hours of breach awareness
- **ICO notification**: Within 72 hours of breach awareness (if required)
- **Individual notification**: Without undue delay (if high risk)

**Completion Time**: 2-4 hours (assessment); ongoing (notifications and follow-up)

**Filed**: /policies/data-breaches/BR-YYYY-NNN/ (highly confidential)

**Retention**: 7 years (GDPR legal requirement)

**Linked**: To Incident Report (if incident involves personal data)

---

### 3. Change Request Form
**Purpose**: Controlled, auditable process for infrastructure and system changes

**Key Sections**:
- Change identification (type, category)
- Change details (what, why, systems affected)
- Impact analysis (risk level, security, customer)
- Implementation plan (steps, timeline, pre/post actions)
- Rollback plan (procedure, decision criteria)
- Testing (environment, results)
- Communication plan (stakeholder notification)
- Approvals (Technical, Security, Change Authority)
- Implementation record (actual duration, issues)
- Post-implementation review (success, lessons learned)

**Change Types**:
- Emergency (verbal approval; document post-change)
- Major (CAB approval; Managing Director)
- Standard (Senior Developer approval)
- Normal (automated CI/CD)

**Completion Time**: 30 minutes - 2 hours (depending on complexity)

**Filed**: /policies/change-requests/CHG-YYYY-NNN.pdf

**Retention**: 3 years (audit requirements)

**Linked**: To Terraform Git commits, deployment logs

---

### 4. Access Request Form
**Purpose**: Formal process for granting, modifying, or removing user access

**Key Sections**:
- Request information (type: new/modify/remove)
- User information (name, role, employment type)
- Access requirements (AWS, application, database, VPN)
- Business justification (why needed, duration)
- Security requirements (data classification, MFA, user obligations)
- Pre-access requirements (training, NDAs, background checks)
- Approvals (Line Manager, ISMS Lead, Managing Director if high-privilege)
- Access provisioning (account creation, credentials)
- Access review (quarterly recertification)
- Access termination (revocation procedures)

**Request Types**:
- New access (new hire, new system access)
- Modify access (role change, additional permissions)
- Temporary access (project-based, time-limited)
- Remove access (termination, no longer needed)

**Completion Time**: 15-30 minutes (simple); 1 hour (complex)

**Processing Time**: Same day (standard); immediate (emergency)

**Filed**: /policies/access-requests/ACC-YYYY-NNN.pdf

**Retention**: Duration of access + 3 years

**Linked**: User Access Register updated

---

### 5. Asset Disposal Form
**Purpose**: Ensure secure, compliant disposal of assets containing sensitive data

**Key Sections**:
- Asset information (ID, type, classification)
- Disposal reason (end of life, replacement, security risk)
- Data sanitization plan (method appropriate for classification)
- Disposal method (WEEE, destruction, return, donation, cloud deletion)
- Environmental compliance (WEEE regulations)
- Approvals (Asset Owner, ISMS Lead for RESTRICTED, Managing Director for high-value)
- Disposal execution (verification, certificate of destruction)
- Post-disposal (asset register update, documentation)
- Insurance and financial (write-off, claims)
- Lessons learned

**Disposal Methods**:
- Physical assets: Secure wipe (DoD 5220.22-M) or physical destruction
- Cloud assets: Terraform destroy or AWS deletion (AWS-managed wiping)
- Data: Deletion of all versions; backup expiry

**Completion Time**: 30 minutes - 1 hour

**Filed**: /policies/asset-disposals/DISP-YYYY-NNN/ (with certificates)

**Retention**: 7 years (asset lifecycle + compliance)

**Linked**: Asset Register updated; Asset Disposal Log entry

---

## Form Completion Guidelines

### General Instructions

**Before Completing a Form**:
1. Read all instructions and section descriptions
2. Gather necessary information
3. Consult policies if unsure of requirements
4. Have approval authority available (if time-sensitive)

**While Completing**:
1. Fill in all required fields (marked with *)
2. Be specific (not vague)
3. Use checkboxes where provided
4. Attach supporting documents (evidence, approvals, certificates)
5. Use consistent date/time format (UTC for incidents)
6. Proofread before submitting for approval

**After Completion**:
1. Obtain required signatures/approvals
2. Save as PDF (preserve formatting)
3. File in appropriate directory
4. Update related register
5. Set reminders for follow-up actions
6. Archive supporting documents with form

### Required vs. Optional Fields

**Required Fields** (must be completed):
- All identification fields (IDs, names, dates)
- Classification and severity
- Approval signatures
- Critical decision points (ICO notification, disposal method, etc.)

**Optional Fields** (complete if applicable):
- "Other" fields (if specific options don't fit)
- Notes and additional information
- Lessons learned (valuable but not always applicable)

### Electronic vs. Paper Forms

**Electronic Preferred**:
- Easy to store, search, and backup
- Can be digitally signed (future enhancement)
- Easier to track and report

**Paper Acceptable**:
- For field work or when systems unavailable
- Must be scanned and filed electronically
- Original retained if contains signatures

---

## Form Workflows

### Incident Response Workflow
```
Incident Detected
    ↓
Open Incident Report Form
    ↓
Classify Severity (P1-P4)
    ↓
[If Personal Data] → Complete GDPR Breach Assessment Form
    ↓
Activate IRT (if P1/P2)
    ↓
Document Response Actions in Form
    ↓
[If Customer Impact] → Use Customer Notification Template
    ↓
Post-Incident Review
    ↓
Complete Final Sections of Form
    ↓
ISMS Lead Approval
    ↓
File Report + Add to Incident Register
    ↓
Track Action Items
```

### Access Management Workflow
```
Access Need Identified
    ↓
Complete Access Request Form
    ↓
Line Manager Approval
    ↓
[If Privileged Access] → ISMS Lead Review
    ↓
[If Admin Access] → Managing Director Approval
    ↓
Pre-Access Requirements (Training, NDA)
    ↓
Support Team Provisions Access
    ↓
Update User Access Register
    ↓
User Notified
    ↓
Quarterly Access Review (using same form)
```

### Change Management Workflow
```
Change Proposed
    ↓
Complete Change Request Form
    ↓
Technical Review (Senior Developer)
    ↓
[If Infrastructure/Security] → ISMS Lead Review
    ↓
[If Major Change] → CAB Review → Managing Director Approval
    ↓
Pre-Change Actions (Backup, Notification)
    ↓
Implement Change
    ↓
Document Implementation in Form
    ↓
Post-Implementation Verification
    ↓
Lessons Learned
    ↓
Close Change Request
```

---

## Approval Authorities

**Quick Reference** - Who approves what:

| Form | Approval Level 1 | Approval Level 2 | Approval Level 3 |
|------|-----------------|-----------------|-----------------|
| **Incident Report** | ISMS Lead | Managing Director (P1/P2) | - |
| **GDPR Breach Assessment** | DPO (Akam Rahimi) | Managing Director | - |
| **Change Request (Emergency)** | ISMS Lead (verbal) | Post-implementation (24h) | - |
| **Change Request (Major)** | Senior Developer | ISMS Lead | Managing Director |
| **Change Request (Standard)** | Senior Developer | - | - |
| **Access Request (Standard)** | Line Manager | - | - |
| **Access Request (Privileged)** | Line Manager | ISMS Lead | - |
| **Access Request (Admin)** | Line Manager | ISMS Lead | Managing Director |
| **Asset Disposal (Standard)** | Asset Owner | - | - |
| **Asset Disposal (RESTRICTED)** | Asset Owner | ISMS Lead | - |
| **Asset Disposal (>£1000)** | Asset Owner | ISMS Lead | Managing Director |

---

## Digital Signatures (Future Enhancement)

**Current State**: Physical signatures or email approvals

**Future State**: Digital signature integration
- DocuSign, Adobe Sign, or similar
- Legally binding electronic signatures
- Automatic tracking and reminders
- Integration with registers (auto-update)
- Audit trail built-in

**Until then**: Email approvals acceptable; print, sign, scan for formal records

---

## Related Documents

**Policies**: ../policies/*.md (20 ISO 27001 policies)  
**Templates**: ../templates/*.md (DPIA, Risk Treatment, Notifications, Supplier Assessment)  
**Registers**: ../registers/*.csv (Risk, Asset, Incident, Breach, etc.)  
**Technical Docs**: ../../docs/ (Infrastructure, runbooks)

---

## Support and Questions

**For form-related questions**:
- **General**: ISMS Lead (akam@epact.co.uk)
- **GDPR/Privacy forms**: DPO (akam@epact.co.uk)
- **Access forms**: Support Team
- **Technical forms**: Senior Developer

**For form approvals**:
- Check approval matrix above
- Escalate if approver unavailable (next level)
- Emergency: Managing Director can approve all forms

---

**Document Owner**: Akam Rahimi, ISMS Lead  
**Last Updated**: [Date]  
**Next Review**: [Date + 12 months]

---

**CONFIDENTIAL - Internal Use Only**

