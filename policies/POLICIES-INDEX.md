# EPACT LTD - Complete Policies, Forms, and Registers Index

**ISO 27001:2022 Compliance Documentation - Master Index**

---

## Document Control

**Company**: EPACT LTD  
**Registration**: 11977631  
**Address**: International House, 36-38 Cornhill, London, England, EC3V 3NG  
**ISMS Lead / DPO**: Akam Rahimi  
**Email**: akam@epact.co.uk

**Framework Version**: 1.0  
**Last Updated**: [Date]  
**Next Comprehensive Review**: [Date + 12 months]

---

## Quick Navigation

📋 [Policies](#policies-20-documents) | 📝 [Forms](#forms-5-documents) | 📊 [Registers](#registers-9-files) | 📑 [Templates](#templates-4-documents) | 🔧 [Technical Docs](../docs/)

---

## Policies (20 Documents)

### Priority 1 - Critical (Implement Immediately)

| # | Policy | File | Pages | Status | Key Topics |
|---|--------|------|-------|--------|-----------|
| 01 | **Information Security Policy** | `01-information-security-policy.md` | 10 | ✅ Draft | Master policy; management commitment; security objectives; ISMS framework; compliance requirements |
| 02 | **Access Control Policy** | `02-access-control-policy.md` | 16 | ✅ Draft | AWS IAM; MFA; passwords; RBAC; privileged access; quarterly access reviews; account lifecycle |
| 03 | **Risk Management Policy** | `03-risk-management-policy.md` | 17 | ✅ Draft | 5×5 risk matrix; treatment options; AWS-specific risks; risk register; monitoring |
| 04 | **Incident Management Policy** | `04-incident-management-policy.md` | 19 | ✅ Draft | P1-P4 severity; IRT structure; GDPR 72-hour notification; AWS incident response procedures |
| 05 | **Data Protection and Privacy Policy** | `05-data-protection-privacy-policy.md` | 22 | ✅ Draft | GDPR compliance; data subject rights; DPIAs; multi-tenant isolation; ICO notification; privacy by design |

### Priority 2 - High (Within 3 Months)

| # | Policy | File | Pages | Status | Key Topics |
|---|--------|------|-------|--------|-----------|
| 06 | **Operations Security Policy** | `06-operations-security-policy.md` | 16 | ✅ Draft | Change management; Terraform workflow; vulnerability management; patching; malware protection; capacity; logging |
| 07 | **Asset Management Policy** | `07-asset-management-policy.md` | 14 | ✅ Draft | Asset classification; AWS resource tagging; inventory; ownership; lifecycle; disposal procedures |
| 08 | **Business Continuity and DR** | `08-business-continuity-disaster-recovery-policy.md` | 15 | ✅ Draft | RTO: 4h; RPO: 24h; disaster scenarios; Multi-AZ architecture; annual DR testing; AWS Backup strategy |
| 09 | **Cryptography Policy** | `09-cryptography-policy.md` | 9 | ✅ Draft | AES-256; RSA-2048+; TLS 1.2+; KMS key management; 30-day deletion windows; encryption standards |
| 10 | **Compliance and Legal** | `10-compliance-legal-policy.md` | 12 | ✅ Draft | GDPR; ISO 27001; Companies Act; retention schedules; ICO registration; audit requirements; certifications |

### Priority 3 - Medium (Within 6 Months)

| # | Policy | File | Pages | Status | Key Topics |
|---|--------|------|-------|--------|-----------|
| 11 | **Communications Security** | `11-communications-security-policy.md` | 7 | ✅ Draft | Network segmentation; TLS enforcement; WAF; VPN; email security; DNS security |
| 12 | **Human Resources Security** | `12-human-resources-security-policy.md` | 8 | ✅ Draft | Pre-employment screening; NDAs; training; termination; confidentiality; roles and responsibilities |
| 13 | **Security Monitoring & Logging** | `13-security-monitoring-logging-policy.md` | 7 | ✅ Draft | CloudTrail; CloudWatch; GuardDuty; Security Hub; log retention; 24/7 monitoring; SIEM |
| 14 | **Information Backup** | `14-information-backup-policy.md` | 6 | ✅ Draft | Daily (30d) + weekly (365d); AWS Backup vault; quarterly testing; retention; backup security |
| 15 | **Supplier Relationships** | `15-supplier-relationships-policy.md` | 6 | ✅ Draft | Supplier assessment; DPAs; SLA monitoring; AWS (primary supplier); annual reviews |

### Priority 4 - Standard (Within 12 Months)

| # | Policy | File | Pages | Status | Key Topics |
|---|--------|------|-------|--------|-----------|
| 16 | **System Development & Maintenance** | `16-system-development-maintenance-policy.md` | 7 | ✅ Draft | Secure SDLC; OWASP Top 10; code review; SAST/DAST; Terraform security; dependency management |
| 17 | **Remote Working** | `17-remote-working-policy.md` | 7 | ✅ Draft | Home office security; VPN; clean desk; travel security; public WiFi; workspace requirements |
| 18 | **Acceptable Use** | `18-acceptable-use-policy.md` | 6 | ✅ Draft | Authorized use; prohibited activities; email/internet guidelines; monitoring; violations and consequences |
| 19 | **Mobile Device & Teleworking** | `19-mobile-device-teleworking-policy.md` | 7 | ✅ Draft | BYOD; device encryption; remote wipe; public WiFi; travel security; MDM; app security |
| 20 | **Physical & Environmental** | `20-physical-environmental-security-policy.md` | 6 | ✅ Draft | AWS data center security; office security; equipment protection; clear desk; disposal; utilities |

**Total Policy Pages**: ~220 pages of comprehensive ISO 27001:2022 compliance policies

---

## Forms (5 Documents)

| Form | File | Pages | Purpose | Completed By |
|------|------|-------|---------|-------------|
| **Incident Report** | `forms/incident-report-form.md` | 8 | Complete incident documentation | IRT / ISMS Lead |
| **GDPR Breach Assessment** | `forms/gdpr-breach-assessment-form.md` | 9 | 72-hour ICO notification decision | DPO (Akam Rahimi) |
| **Change Request** | `forms/change-request-form.md` | 7 | Infrastructure/system change approval | Requestor → Approvers |
| **Access Request** | `forms/access-request-form.md` | 6 | User access provisioning/modification | Line Manager → ISMS Lead |
| **Asset Disposal** | `forms/asset-disposal-form.md` | 6 | Secure asset disposal with sanitization | Asset Owner → ISMS Lead |

---

## Registers (9 Files)

| Register | File | Type | Entries | Purpose |
|----------|------|------|---------|---------|
| **Risk Register** | `registers/risk-register.csv` | CSV | 15 example risks | Track information security risks and treatments |
| **Asset Register** | `registers/asset-register.csv` | CSV | 23 example assets | Inventory all information assets (cloud, physical, data) |
| **Incident Register** | `registers/incident-register.csv` | CSV | 3 example incidents | Log all security incidents and responses |
| **Data Breach Register** | `registers/data-breach-register.csv` | CSV | 2 example breaches | GDPR Article 33 - all personal data breaches |
| **Supplier Register** | `registers/supplier-register.csv` | CSV | 10 example suppliers | Track suppliers, assessments, DPAs, reviews |
| **User Access Register** | `registers/user-access-register.csv` | CSV | 12 example accounts | All user accounts and access permissions |
| **Data Subject Rights Register** | `registers/data-subject-rights-register.csv` | CSV | 6 example requests | GDPR rights requests (SAR, erasure, etc.) |
| **Training Register** | `registers/training-register.csv` | CSV | 12 example trainings | Security training completion and certifications |
| **Asset Disposal Log** | `registers/asset-disposal-log.csv` | CSV | 7 example disposals | Secure disposal and data sanitization |

**All registers include example entries and template rows for easy population**

---

## Templates (4 Documents)

| Template | File | Pages | Purpose | Used By |
|----------|------|-------|---------|---------|
| **DPIA Template** | `templates/dpia-template.md` | 7 | Data Protection Impact Assessment | DPO |
| **Risk Treatment Plan** | `templates/risk-treatment-plan-template.md` | 8 | Detailed risk mitigation plans | ISMS Lead |
| **Customer Notifications** | `templates/customer-incident-notification-template.md` | 6 | 6 incident communication templates | ISMS Lead, Business Dev |
| **Supplier Security Questionnaire** | `templates/supplier-security-questionnaire.md` | 9 | Assess supplier security (63 questions) | ISMS Lead, Managing Director |

---

## Documentation Summary

### Total Documentation Delivered

📄 **Policies**: 20 comprehensive documents (~220 pages)  
📝 **Forms**: 5 operational forms (~36 pages)  
📊 **Registers**: 9 CSV registers with example data  
📑 **Templates**: 4 detailed templates (~30 pages)  
📚 **README Guides**: 4 comprehensive guides (policies, forms, registers, templates)  
📖 **Master Overview**: 1 policy requirements document (21 pages)

**Grand Total**: ~40 documents, ~315 pages of ISO 27001:2022 compliance documentation

---

## Implementation Roadmap

### Phase 1: Immediate (Next 30 Days)

**Week 1-2**: Policy Review and Customization
- [ ] Managing Director reviews all 20 policies
- [ ] Fill in [TO BE COMPLETED] fields (phone numbers, provider names, etc.)
- [ ] Legal counsel reviews data protection policies (recommended)
- [ ] Customize policies for company specifics

**Week 3**: Approval and Publication
- [ ] Managing Director signs all policies
- [ ] Set approval and effective dates
- [ ] Publish policies to company shared drive/intranet
- [ ] Email all staff with policy location

**Week 4**: Training and Acknowledgment
- [ ] Schedule policy overview training sessions
- [ ] Distribute Policy Acknowledgment Forms
- [ ] Collect signed acknowledgments (deadline: 30 days)
- [ ] Update training register

### Phase 2: Implementation (Months 2-3)

**Populate Registers**:
- [ ] Complete Risk Register (conduct risk assessment)
- [ ] Complete Asset Register (audit all assets)
- [ ] Set up Supplier Register (assess current suppliers)
- [ ] Populate User Access Register (all current accounts)
- [ ] Initialize other registers (empty but ready to use)

**Develop Procedures**:
- [ ] Detailed procedures for each policy (as needed)
- [ ] Incident response playbooks (specific scenarios)
- [ ] Data subject rights procedures
- [ ] Backup/restore procedures (exists: docs/backup-restore-runbook.md)

**Implement Controls**:
- Many already implemented in AWS infrastructure
- [ ] Enhance where gaps identified
- [ ] Document control evidence

### Phase 3: Testing and Audit (Months 4-6)

**Internal Audit**:
- [ ] Plan internal audit program (quarterly cycle covering all policies)
- [ ] Conduct first internal audit (Priority 1 policies)
- [ ] Document findings
- [ ] Remediate non-conformities
- [ ] Follow-up audit to verify corrections

**Testing**:
- [ ] Quarterly backup restoration test
- [ ] Annual DR test (see docs/disaster-recovery-test.md)
- [ ] Incident response tabletop exercise
- [ ] Penetration test (external firm)

**Continuous Operation**:
- [ ] Monthly risk reviews
- [ ] Quarterly access reviews
- [ ] Weekly security monitoring
- [ ] Regular policy compliance checks

### Phase 4: Certification (Months 7-12)

**ISO 27001 Certification** (if pursuing):
- [ ] Gap analysis against ISO 27001 Annex A
- [ ] Remediate identified gaps
- [ ] Management review meetings (establish quarterly schedule)
- [ ] Select certification body (UKAS-accredited)
- [ ] Stage 1 audit (documentation review)
- [ ] Address Stage 1 findings
- [ ] Stage 2 audit (implementation assessment)
- [ ] Certificate issued (3-year validity)
- [ ] Celebrate! 🎉

**Ongoing Compliance**:
- [ ] Annual surveillance audits (maintain certification)
- [ ] Continuous improvement
- [ ] Policy annual reviews
- [ ] Training refreshers

---

## ISO 27001:2022 Compliance Status

### Annex A Controls Coverage

**Total Controls**: 93  
**Covered by Policies**: 93 (100%)  
**Implemented**: [To be assessed in gap analysis]

**Control Categories**:
- ✅ Organizational (37 controls) - Policies 01, 03, 04, 05, 07, 10, 12, 15
- ✅ People (8 controls) - Policies 02, 12, 17, 18, 19
- ✅ Physical (14 controls) - Policies 07, 20
- ✅ Technological (34 controls) - Policies 02, 06, 09, 11, 13, 14, 16

**Statement of Applicability (SOA)**: To be developed (lists all 93 controls and applicability)

---

## GDPR Compliance Status

### Key GDPR Requirements

✅ **Accountability** (Article 5(2)):
- Data Protection Policy demonstrates compliance
- Records of processing activities (Article 30) - in policy
- DPIAs for high-risk processing - template provided
- Data protection by design and default - in policies

✅ **Lawfulness** (Article 6):
- Lawful bases identified - in Data Protection Policy
- Privacy notices - required (website)
- Consent management - procedures in policy

✅ **Data Subject Rights** (Articles 15-22):
- Procedures documented - Data Protection Policy
- 1-month response timeline - enforced
- Identity verification - procedures defined
- Request register - provided (data-subject-rights-register.csv)

✅ **Security** (Article 32):
- Encryption - Cryptography Policy + AWS KMS implementation
- Access controls - Access Control Policy + IAM
- Monitoring - Security Monitoring Policy + CloudWatch/GuardDuty
- Testing - Annual pen test; quarterly backup tests

✅ **Breach Notification** (Articles 33-34):
- 72-hour ICO notification - procedures in Incident Management Policy
- Assessment process - GDPR Breach Assessment Form provided
- Breach register - data-breach-register.csv provided
- Individual notification - templates provided

✅ **DPO** (Article 37):
- DPO appointed: Akam Rahimi
- Contact published: akam@epact.co.uk
- Responsibilities defined - in policies

✅ **Records** (Article 30):
- Processing register - described in Data Protection Policy (to be populated)

---

## Completeness Checklist

### Policies ✅ Complete
- [x] 20 of 20 policies created
- [x] Company details incorporated (EPACT LTD, registration, address)
- [x] Personnel identified (Akam Rahimi as ISMS Lead/DPO)
- [x] AWS infrastructure specifics included
- [x] ISO 27001:2022 and GDPR requirements covered
- [ ] [TO BE COMPLETED] fields customized (phone numbers, provider names, dates)
- [ ] Legal review (recommended for data protection policies)
- [ ] Managing Director signatures obtained
- [ ] Effective dates set
- [ ] Published to employees
- [ ] Acknowledgments collected

### Forms ✅ Complete
- [x] 5 of 5 core forms created
- [x] Comprehensive and usable
- [x] Approval workflows defined
- [x] Examples provided (where helpful)
- [ ] Integrated with workflows (train staff on form usage)
- [ ] Digital signature solution (future enhancement)

### Registers ✅ Complete
- [x] 9 of 9 registers created with example data
- [x] CSV format for easy import/export
- [x] Template rows for each register
- [x] Real-world examples (AWS-specific)
- [ ] Import into operational tool (Excel, Google Sheets, GRC platform)
- [ ] Populate with actual company data
- [ ] Establish update procedures (who, when, how)
- [ ] Set up reminders for reviews

### Templates ✅ Complete
- [x] 4 of 4 core templates created
- [x] DPIA for high-risk processing
- [x] Risk treatment planning
- [x] Customer communications (6 variants)
- [x] Supplier security assessment (63 questions)
- [ ] Train relevant staff on template usage
- [ ] Integrate into operational workflows

---

## File Structure

```
policies/
├── POLICIES-INDEX.md (this file - master index)
├── README.md (policies overview and guidance)
├── iso27001-required-policies.md (policy requirements summary)
│
├── 01-information-security-policy.md
├── 02-access-control-policy.md
├── 03-risk-management-policy.md
├── 04-incident-management-policy.md
├── 05-data-protection-privacy-policy.md
├── 06-operations-security-policy.md
├── 07-asset-management-policy.md
├── 08-business-continuity-disaster-recovery-policy.md
├── 09-cryptography-policy.md
├── 10-compliance-legal-policy.md
├── 11-communications-security-policy.md
├── 12-human-resources-security-policy.md
├── 13-security-monitoring-logging-policy.md
├── 14-information-backup-policy.md
├── 15-supplier-relationships-policy.md
├── 16-system-development-maintenance-policy.md
├── 17-remote-working-policy.md
├── 18-acceptable-use-policy.md
├── 19-mobile-device-teleworking-policy.md
├── 20-physical-environmental-security-policy.md
│
├── forms/
│   ├── README.md
│   ├── incident-report-form.md
│   ├── gdpr-breach-assessment-form.md
│   ├── change-request-form.md
│   ├── access-request-form.md
│   └── asset-disposal-form.md
│
├── registers/
│   ├── README.md
│   ├── risk-register.csv
│   ├── asset-register.csv
│   ├── incident-register.csv
│   ├── data-breach-register.csv
│   ├── supplier-register.csv
│   ├── user-access-register.csv
│   ├── data-subject-rights-register.csv
│   ├── training-register.csv
│   └── asset-disposal-log.csv
│
└── templates/
    ├── README.md
    ├── dpia-template.md
    ├── risk-treatment-plan-template.md
    ├── customer-incident-notification-template.md
    └── supplier-security-questionnaire.md
```

---

## Integration with Technical Infrastructure

**These policies govern the AWS infrastructure documented in**:

```
../docs/
├── readme.md (architecture overview)
├── infrastructure.md (detailed design + AWS icon diagram)
├── deployment.md (deployment procedures)
├── backup-restore-runbook.md (backup/recovery procedures)
├── disaster-recovery-test.md (DR testing plan)
└── iam-matrix.csv (IAM roles and permissions)

../modules/ (Terraform infrastructure code)
├── vpc/ (network security - Policy 11)
├── compute/ (application tier - Policies 06, 16)
├── database/ (RDS security - Policies 05, 09, 14)
├── security/ (WAF, GuardDuty, CloudTrail - Policies 06, 13)
├── backup/ (AWS Backup - Policies 08, 14)
├── monitoring/ (CloudWatch, alarms - Policies 06, 13)
└── lambda-tenant/ (automation - Policies 05, 06, 16)
```

---

## Training and Awareness

### Required Training (Using This Documentation)

**All Employees** (Annual - 2 hours):
- Policies: 01, 02, 05, 17, 18
- Forms: How to report incidents, access requests
- Key concepts: Classification, MFA, phishing, GDPR rights

**Development Team** (Annual - Additional 4 hours):
- Policies: 06, 09, 11, 16
- Forms: Change requests, incident reports
- Terraform security, AWS best practices, OWASP Top 10

**ISMS Lead** (Specialized):
- All policies (deep understanding)
- All forms and templates (expert level)
- ISO 27001 Lead Implementer certification
- GDPR Practitioner certification
- Incident response training

**Support Team**:
- Policies: 02, 04, 06, 13
- Forms: Incident reports, access requests
- Monitoring tools, log analysis, incident triage

**Management**:
- Policy 01 (comprehensive understanding)
- Executive summaries of all policies
- Risk register and management reviews
- Compliance obligations

---

## Audit Preparation

### ISO 27001 Certification Audit Evidence

**Stage 1 (Documentation Review)**:
Provide auditor with:
- ✅ All 20 policies (this directory)
- ✅ Risk Register (populated)
- ✅ Asset Register (populated)
- ✅ Forms and templates (showing systematic approach)
- Statement of Applicability (to be developed)
- ISMS scope document (to be developed)
- Organizational chart with security responsibilities

**Stage 2 (Implementation Assessment)**:
Demonstrate:
- Policies communicated to staff (training records, acknowledgments)
- Controls implemented (AWS infrastructure, procedures)
- Registers actively maintained (recent entries, reviews)
- Forms in use (completed incident reports, change requests)
- Management oversight (review meeting minutes)
- Continuous improvement (action items tracked, metrics reviewed)

**Surveillance Audits** (Annual):
- Evidence of continued compliance
- Policy reviews conducted
- Incident management effective
- Risk management active
- Training ongoing
- Improvements implemented

---

## Metrics and KPIs

### ISMS Effectiveness Metrics (Tracked in Registers)

**From Risk Register**:
- Number of risks (total, by level)
- Risks accepted vs. mitigated
- Overdue risk treatments
- Trend (risks increasing/decreasing)

**From Incident Register**:
- Incidents per month (by severity)
- MTTD (Mean Time to Detect)
- MTTR (Mean Time to Respond/Recover)
- Repeat incidents (same root cause)
- Incident sources (GuardDuty, employee report, etc.)

**From Data Breach Register**:
- Personal data breaches (count)
- ICO notifications (count)
- Breaches prevented (encryption effective)

**From Training Register**:
- Training completion rate (target: 100%)
- Overdue refreshers
- Phishing simulation results (target: <10% click rate)

**From User Access Register**:
- Access review completion (target: 100% quarterly)
- Orphaned accounts detected and removed
- Privileged accounts (count and review status)

**From Asset Register**:
- Critical assets (count)
- Untagged AWS resources (target: 0)
- Assets overdue for review

**Quarterly Dashboard**: Generated for Managing Director

---

## Continuous Improvement

### Feedback Loops

**After Each Use** (Forms):
- Was form helpful? Improvements needed?
- Feedback to ISMS Lead

**Quarterly** (Policies):
- Policy effectiveness review
- Compliance metrics
- Employee feedback

**Annually** (Complete Framework):
- Comprehensive review of all documentation
- Benchmark against industry best practices
- Update for regulatory changes
- Incorporate lessons learned
- Refresh examples and guidance

---

## Quick Start Guide

### New to ISO 27001 Compliance?

**Start Here**:
1. Read `README.md` (policies overview)
2. Read `01-information-security-policy.md` (master policy)
3. Review policies relevant to your role (see README for role-specific lists)
4. Complete annual security awareness training
5. Sign policy acknowledgment forms
6. Familiarize yourself with forms you may use (incident report, access request)

**ISMS Lead / DPO Start Here**:
1. Review all 20 policies (comprehensive understanding)
2. Customize [TO BE COMPLETED] fields
3. Populate registers with current data
4. Establish operational rhythms (monthly risk reviews, quarterly access reviews)
5. Schedule management review meetings
6. Plan internal audit program
7. Initiate ISO 27001 certification process

**Auditor Start Here**:
1. Review `README.md` and this index
2. Access all policies (policies/*.md)
3. Review populated registers (registers/*.csv)
4. Sample completed forms (forms/*.md for templates)
5. Review technical implementation (../docs/)
6. Conduct audit per ISO 27001:2022 standard

---

## Compliance Certification Path

### Certifications Supported by This Framework

**ISO 27001:2022** - Information Security Management:
- ✅ All 93 Annex A controls covered by policies
- ✅ Risk-based approach documented
- ✅ Management commitment and oversight
- ✅ Competence and awareness (training)
- ✅ Operational planning and control
- ✅ Incident management
- ✅ Continual improvement
- **Status**: Documentation complete; implementation and certification pending

**GDPR Compliance** - Data Protection:
- ✅ All principles (Article 5)
- ✅ Lawful bases (Article 6)
- ✅ Data subject rights (Articles 15-22)
- ✅ Privacy by design (Article 25)
- ✅ Records of processing (Article 30)
- ✅ Security of processing (Article 32)
- ✅ Breach notification (Articles 33-34)
- ✅ DPIAs (Article 35)
- ✅ DPO (Article 37)
- **Status**: Policy framework complete; operational compliance ongoing

**ISO 9001** - Quality Management (if pursuing):
- Compatible with ISO 27001
- Quality objectives aligned with security objectives
- Document control practices (version control, approvals)
- **Status**: Documentation supports quality management framework

**PCI DSS** - Payment Card Security (if applicable):
- 12 requirements mappable to security policies
- Network segmentation, encryption, access control, monitoring, testing
- **Status**: Policies provide foundation; specific PCI DSS controls to be implemented if processing card data

---

## Document Maintenance

### Version Control
- All policies, forms, templates in Git repository
- Change tracking via Git history
- Pull requests for significant changes
- Managing Director approval for policy changes

### Backup
- Git repository (distributed backup)
- Cloud storage (Google Drive, OneDrive)
- Included in business continuity backup strategy

### Access Control
- Policies: INTERNAL (all staff) to CONFIDENTIAL (detailed procedures)
- Forms: CONFIDENTIAL (limited to users)
- Registers: CONFIDENTIAL to RESTRICTED (role-based access)
- Templates: CONFIDENTIAL (authorized users)

---

## Support and Contacts

### Primary Contacts

**For Questions About**:

| Topic | Contact | Email | Phone |
|-------|---------|-------|-------|
| **Policies (general)** | ISMS Lead | akam@epact.co.uk | [TBC] |
| **GDPR / Data Protection** | DPO (Akam Rahimi) | akam@epact.co.uk | [TBC] |
| **Technical Policies** | Senior Developer | [email] | [TBC] |
| **HR Policies** | Managing Director | akam@epact.co.uk | [TBC] |
| **Forms and Templates** | ISMS Lead | akam@epact.co.uk | [TBC] |
| **Registers (Access, Training)** | Support Team | [email] | [TBC] |
| **Emergency / Incidents** | ISMS Lead (24/7) | akam@epact.co.uk | [TBC] |

### External Support

| Service | Provider | Contact |
|---------|----------|---------|
| **Legal Counsel** | [Firm name] | [Contact TBC] |
| **ISO 27001 Certification** | [Certification body] | [Contact TBC] |
| **Penetration Testing** | [Testing firm] | [Contact TBC] |
| **Cyber Insurance** | [Insurance provider] | [Contact TBC] |
| **AWS Support** | Amazon Web Services | Via AWS Console |

---

## Recognition and Credits

**Framework Development**: Akam Rahimi (Managing Director & ISMS Lead)  
**Technical Integration**: Senior Developer  
**Infrastructure Design**: Development Team  
**Based on Standards**: ISO/IEC 27001:2022, UK GDPR, ISO/IEC 27002:2022

**Aligned with AWS Services**:
- VPC, EC2, RDS, S3, Lambda (compute and storage)
- KMS, WAF, GuardDuty, Security Hub, CloudTrail, Config (security)
- CloudWatch, SNS, EventBridge (monitoring and automation)
- AWS Backup (business continuity)
- Terraform (Infrastructure-as-Code)

---

## Final Notes

### This Framework Provides

✅ **Complete ISO 27001:2022 policy suite** (20 policies)  
✅ **Operational registers** (9 registers with examples)  
✅ **Practical forms** (5 forms for daily use)  
✅ **Useful templates** (4 templates for complex processes)  
✅ **AWS infrastructure alignment** (specific to your multi-tenant platform)  
✅ **GDPR compliance** (comprehensive data protection)  
✅ **Audit-ready documentation** (evidence and records)  
✅ **Scalable framework** (grows with company)

### What You Still Need to Do

📝 **Customize**: Fill in company-specific details ([TO BE COMPLETED] fields)  
✍️ **Approve**: Managing Director signatures on all policies  
📢 **Publish**: Distribute to all employees  
🎓 **Train**: Conduct policy overview training  
📋 **Populate**: Fill registers with actual data  
🔄 **Operate**: Use forms and templates in daily operations  
📊 **Monitor**: Track metrics and KPIs  
🔍 **Audit**: Internal audits and certification  
🔁 **Improve**: Continuous improvement based on experience

---

**For the complete EPACT information security and compliance framework, this directory provides everything needed for ISO 27001 certification and GDPR compliance.**

**Next Steps**: See README.md Section "Next Steps" for detailed implementation roadmap.

---

**Document Owner**: Akam Rahimi, Managing Director & ISMS Lead  
**Created**: [Date]  
**Framework Version**: 1.0  
**Last Updated**: [Date]  
**Next Comprehensive Review**: [Date + 12 months]

---

**EPACT LTD - Committed to Information Security Excellence**

For support: akam@epact.co.uk

