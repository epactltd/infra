# Compliance and Legal Policy

**EPACT LTD**  
Company Registration: 11977631  
International House, 36-38 Cornhill, London, England, EC3V 3NG

---

## Document Control

| **Version** | 1.0 |
|------------|-----|
| **Approved By** | Akam Rahimi, Managing Director |
| **Approval Date** | [TO BE COMPLETED] |
| **Next Review Date** | [12 months from approval] |
| **Owner** | Akam Rahimi, Managing Director |
| **ISO 27001 Reference** | A.5.31, A.5.32, A.5.33, A.5.34, A.5.36, A.5.37 |

---

## 1. Purpose

Ensure EPACT LTD complies with all applicable legal, statutory, regulatory, and contractual information security requirements.

---

## 2. Applicable Legal and Regulatory Requirements

### 2.1 Data Protection
- **UK GDPR** (General Data Protection Regulation)
- **Data Protection Act 2018**
- **Privacy and Electronic Communications Regulations (PECR) 2003**
- ICO (Information Commissioner's Office) guidance

### 2.2 Information Security Standards
- **ISO/IEC 27001:2022**: Information Security Management
- **ISO/IEC 27002**: Code of practice for information security controls
- **ISO 9001**: Quality Management System (if pursuing certification)

### 2.3 Industry Standards
- **PCI DSS**: Payment Card Industry Data Security Standard (if processing payments)
- **CIS Benchmarks**: AWS Foundations Benchmark
- **OWASP**: Web application security standards

### 2.4 Corporate and Financial
- **Companies Act 2006**: Records retention
- **Income Tax Act 2007 / Corporation Tax Act 2010**: Financial records (7 years)
- **Bribery Act 2010**: Anti-corruption compliance
- **Modern Slavery Act 2015**: Supply chain transparency (if revenue >£36m)

### 2.5 Employment Law
- **Employment Rights Act 1996**: Employee data protection
- **Equality Act 2010**: Non-discrimination
- **Health and Safety at Work Act 1974**: Workplace safety (includes information security)

### 2.6 Intellectual Property
- **Copyright, Designs and Patents Act 1988**: IP protection
- **Trade Marks Act 1994**: Brand protection
- Open-source licenses: MIT, Apache 2.0, GPL (compliance required)

---

## 3. Compliance Management

### 3.1 Compliance Register
EPACT maintains register of:
- Applicable laws and regulations
- Specific requirements and obligations
- Responsible person for each requirement
- Compliance status (Compliant / In Progress / Non-Compliant)
- Evidence of compliance
- Review date

### 3.2 Compliance Monitoring
**Quarterly Reviews**:
- AWS Security Hub standards (CIS, PCI DSS)
- AWS Config compliance rules
- ISO 27001 control implementation
- GDPR compliance checklist
- Policy compliance metrics

**Annual Reviews**:
- Comprehensive compliance audit
- External legal review of compliance register
- Regulatory changes assessment
- Internal audit program

### 3.3 Non-Compliance Response
1. Identify non-compliance (audit, self-assessment, incident)
2. Risk assessment (likelihood and impact of enforcement action)
3. Remediation plan with timeline
4. Managing Director approval for plan
5. Implementation and verification
6. Documentation for audit trail
7. Reporting to regulators if required

---

## 4. GDPR Compliance

### 4.1 Core Obligations
**See also**: Data Protection and Privacy Policy (detailed)

- Article 5: Data protection principles (lawfulness, purpose limitation, minimization, etc.)
- Article 6: Lawful bases for processing
- Articles 13-14: Transparency and privacy notices
- Articles 15-22: Data subject rights (access, rectification, erasure, portability, objection)
- Article 25: Privacy by design and by default
- Article 30: Records of processing activities
- Article 32: Security of processing (encryption, resilience, testing)
- Articles 33-34: Data breach notification (72 hours to ICO; without delay to individuals)
- Article 35: Data Protection Impact Assessments (DPIAs)

### 4.2 GDPR Compliance Evidence
- Privacy policy (published on website)
- Data processing register (Article 30 records)
- DPIAs for high-risk processing
- DPAs with data processors (AWS, etc.)
- Consent records (if consent-based processing)
- Data subject rights request log
- Data breach register
- Training records (GDPR awareness)

### 4.3 ICO Registration
- EPACT registered with ICO as data controller
- Registration number: [TO BE COMPLETED]
- Renewal: Annual
- Updates: When processing activities change significantly

---

## 5. ISO 27001 Compliance

### 5.1 Certification Objective
EPACT pursues ISO 27001:2022 certification for ISMS.

### 5.2 Certification Process
1. **Gap Analysis**: Assess current controls against ISO 27001 Annex A (93 controls)
2. **Remediation**: Implement missing or insufficient controls
3. **Documentation**: Policies, procedures, records
4. **Internal Audit**: Verify ISMS implementation
5. **Management Review**: Demonstrate leadership commitment
6. **Stage 1 Audit**: Certification body reviews documentation
7. **Stage 2 Audit**: Certification body assesses implementation
8. **Certification**: Certificate issued (valid 3 years)
9. **Surveillance Audits**: Annual audits to maintain certification

### 5.3 ISO 27001 Compliance Activities
**Quarterly**:
- Internal control testing
- Policy compliance reviews
- Risk assessments
- Management review meetings

**Annually**:
- Comprehensive internal audit
- Policy reviews and updates
- External certification audit (after initial certification)
- ISMS effectiveness assessment

### 5.4 ISO 27001 Evidence
- Information Security Policy (Statement of Applicability)
- Risk assessments and risk register
- All 20 security policies
- Procedures and runbooks
- Training records
- Incident records
- Audit reports
- Management review minutes
- Continual improvement evidence

---

## 6. PCI DSS Compliance (If Applicable)

### 6.1 Applicability
**If EPACT processes, stores, or transmits payment card data**:
- Full PCI DSS compliance required
- Annual PCI DSS audit (QSA or SAQ)
- Quarterly vulnerability scans (ASV)

**If using third-party payment processor** (recommended):
- PCI DSS scope significantly reduced
- SAQ A (minimal requirements)
- Redirect to processor for payment (never store card data)

### 6.2 PCI DSS Requirements (Summary)
1. Firewalls and network segmentation (AWS security groups, VPC)
2. No default passwords (enforced via configuration management)
3. Protect stored cardholder data (encryption at rest)
4. Encrypt cardholder data in transit (TLS 1.2+)
5. Antimalware (GuardDuty, endpoint protection)
6. Secure systems and applications (patching, hardening)
7. Restrict access by business need-to-know (IAM least privilege)
8. Authenticate access (MFA, strong passwords)
9. Restrict physical access (AWS data centers; office security)
10. Track and monitor access (CloudTrail, CloudWatch)
11. Test security systems (annual penetration test)
12. Information security policy (this and related policies)

**Current Status**: [To be completed - specify if PCI DSS applies]

---

## 7. Contract and SLA Compliance

### 7.1 Customer Contracts
**Security Commitments** (typical):
- Data protection and privacy (GDPR-compliant)
- Security measures (encryption, access controls, monitoring)
- Availability SLA (99.9% uptime)
- Incident notification (within 24 hours)
- Data ownership (customer owns their data)
- Data return or deletion at contract end
- Audit rights (customer can audit or request SOC 2 report)

**Compliance Monitoring**:
- SLA tracking (CloudWatch uptime metrics)
- Incident notification compliance (log all customer notifications)
- Contract obligation register
- Annual customer contract review

### 7.2 Supplier Contracts
**Security Requirements for Suppliers**:
- Data protection and confidentiality clauses
- Security incident notification (within 24 hours)
- Right to audit supplier security
- ISO 27001, SOC 2, or equivalent certification (preferred)
- Insurance (professional indemnity, cyber insurance)
- Termination assistance (data return, deletion)

**Supplier Compliance**:
- Annual supplier security review
- Request compliance certificates (ISO, SOC 2)
- Monitor supplier incidents and breaches
- Supplier performance metrics

---

## 8. Intellectual Property Compliance

### 8.1 Copyright Compliance
**Software Licensing**:
- Use only licensed software
- Maintain software asset register with licenses
- Annual license compliance audit
- Purchase additional licenses before deployment
- Open-source license compliance (attribute, share-alike if required)

**Open Source License Types**:
- **Permissive** (MIT, Apache 2.0, BSD): Few restrictions; attribute author
- **Copyleft** (GPL, AGPL): Must share modifications; legal review required before use
- **Weak copyleft** (LGPL, MPL): Moderate restrictions

**License Scanning**: Automated tools in CI/CD (detect incompatible licenses)

### 8.2 Source Code Protection
**EPACT Proprietary Code**:
- Copyright notice in all source files
- Private Git repository
- NDAs with contractors
- No public disclosure without approval

**Customer Code** (if applicable):
- Customer owns their customizations
- License terms clear in contract
- IP assignment documented

---

## 9. Records Management

### 9.1 Legal Retention Requirements

**Financial Records** (7 years):
- Invoices and receipts
- Bank statements
- VAT records
- Corporation tax records
- Payroll records
- Expense claims

**Tax Records** (6 years after tax year):
- PAYE records
- National Insurance
- Business accounts
- Tax returns

**Employment Records**:
- Employee contracts: Duration of employment + 6 years
- Payroll: 6 years after tax year
- Disciplinary records: 6 years
- Recruitment (unsuccessful): 6 months

**Corporate Records** (Indefinite):
- Articles of Association
- Board minutes
- Shareholder records
- Insurance policies
- Material contracts

**Data Protection Records** (3-7 years):
- Consent records: Duration of processing + 7 years (proof of consent)
- Data breach register: 7 years
- Data subject rights requests: 3 years
- DPIAs: Duration of processing + 3 years

### 9.2 Retention Implementation
- Automated deletion: S3 lifecycle policies
- Manual deletion: Quarterly review and deletion procedure
- Legal hold: Suspend deletion if litigation or investigation
- Secure disposal: Per Asset Management Policy

---

## 10. Regulatory Reporting

### 10.1 ICO (Information Commissioner's Office)
**Registration**: Annual data protection fee (£40-£2,900 based on size/turnover)

**Notifications**:
- Data breaches (within 72 hours if reportable)
- Annual data protection assessment
- Respond to ICO investigations or audits

**Contact**: https://ico.org.uk/, 0303 123 1113

### 10.2 Companies House
**Filings**:
- Annual accounts (within 9 months of financial year end)
- Confirmation statement (at least annually)
- Change of directors, address, etc. (within 14 days)

### 10.3 HMRC
**Filings**:
- VAT returns (quarterly or monthly)
- Corporation tax return (12 months after accounting period end)
- PAYE and NI (monthly or quarterly)
- Annual tax return

### 10.4 Industry Regulators
**FCA** (if providing financial services): Regulatory reporting per FCA rules

**Other**: As applicable to business activities

---

## 11. Privacy and Cookies Compliance

### 11.1 PECR Compliance
**Email Marketing**:
- B2B: Soft opt-in acceptable (existing customers; opt-out provided)
- B2C: Explicit consent required before sending
- Unsubscribe link in every email
- Honor opt-outs within 24 hours

**Cookies**:
- Cookie consent banner (granular choices)
- Essential cookies: No consent required (authentication, load balancing)
- Analytics, marketing cookies: Consent required
- Cookie policy published (website)

### 11.2 ICO Cookie Guidance
- No pre-ticked boxes
- Clear information about cookies
- Easy to withdraw consent
- Re-consent if cookie purposes change

---

## 12. Export Control and Sanctions

### 12.1 Export Control
**Encryption Technology**: AES-256, RSA-2048+ may be controlled

**Compliance**:
- UK dual-use export controls reviewed
- No export to sanctioned countries (OFSI list)
- Customer screening against sanctions lists

### 12.2 Economic Sanctions
**Prohibited**:
- Providing services to sanctioned individuals or entities
- Processing data from sanctioned countries (unless authorized)

**Screening**:
- Customer onboarding: Screen against OFSI, UN, US OFAC lists
- Ongoing monitoring: Sanctions list updates (quarterly)
- Suspicious activity: Report to National Crime Agency (NCA)

---

## 13. Audit and Assessment

### 13.1 Internal Audits
**Frequency**: At least annually (ISO 27001 requirement)

**Scope**: All ISMS processes and controls

**Process**:
1. Audit plan approved by Managing Director
2. Auditor independent of audited area
3. Audit execution (interviews, document review, testing)
4. Findings documented (conformities, non-conformities, opportunities for improvement)
5. Corrective actions assigned with deadlines
6. Follow-up audit to verify corrections
7. Report to Managing Director

**Audit Program**: Covers all ISO 27001 clauses over 3-year certification cycle

### 13.2 External Audits
**ISO 27001 Certification Audits**:
- Stage 1: Documentation review (off-site)
- Stage 2: Implementation audit (on-site or virtual)
- Surveillance: Annual (after certification)
- Re-certification: Every 3 years

**Customer Audits**:
- Permitted per contract terms
- Notice period: 30 days (reasonable notice)
- Scope: Security controls relevant to customer data
- NDA required
- Findings addressed per agreed timeline

**Penetration Testing**:
- Frequency: Annually (external firm)
- Scope: Application and infrastructure
- AWS permission: Notify AWS (some services require pre-approval)
- Findings: Remediate per vulnerability management policy

### 13.3 Audit Rights
**EPACT Obligations**:
- Provide reasonable access to systems and documentation
- Respond to auditor queries promptly
- Remediate findings per agreed timelines
- Maintain audit trail of remediations

**Limitations**:
- Customer audits: Reasonable scope (no access to other customers' data)
- Confidentiality: Auditors sign NDA
- Timing: Minimal disruption to operations
- Costs: Excessive audit costs may be passed to customer (per contract)

---

## 14. Compliance Roles and Responsibilities

| **Role** | **Responsibilities** |
|---------|---------------------|
| **Managing Director** | Overall accountability; legal compliance; contract approvals |
| **ISMS Lead / DPO** | GDPR compliance; ISO 27001 compliance; regulatory liaison; audit coordination |
| **Senior Developer** | Technical compliance (PCI DSS, CIS Benchmark); AWS Config rules |
| **Development Team** | Implement compliance controls; secure coding standards |
| **Support Team** | Operational compliance; monitoring; incident response |
| **Business Development** | Contract compliance; customer commitments; SLA tracking |

---

## 15. Legal Requests and Investigations

### 15.1 Law Enforcement Requests
**Procedure**:
1. Request received by Managing Director
2. Verify legitimacy (official letterhead, signature, court order)
3. Legal counsel consulted
4. Scope and necessity assessed
5. Customer notified (unless prohibited by order)
6. Minimum necessary data disclosed
7. Disclosure logged in legal request register

**Requirements**:
- Proper legal authority (warrant, court order, statutory power)
- Proportionate to investigation
- Documented and approved by Managing Director

### 15.2 Subject Access Requests (from Authorities)
Handle per Data Protection and Privacy Policy (no special exemption for authorities without proper legal basis)

### 15.3 Data Preservation Requests
**If litigation anticipated**:
- Legal hold implemented (suspend normal deletion)
- Affected data identified and preserved
- Legal counsel engaged
- Preservation scope documented
- Regular review of legal hold status

---

## 16. Contractual Compliance

### 16.1 Customer SLA Compliance
**Availability SLA**: 99.9% uptime (monthly)

**Measurement**:
- CloudWatch uptime monitoring
- Exclude scheduled maintenance (with 7-day notice)
- Monthly SLA report generated
- Breaches: Credits per contract terms

**Incident SLA**: Notification within 24 hours

**Data Protection SLA**: GDPR-compliant processing

### 16.2 Supplier SLA Monitoring
**AWS SLAs**:
- EC2: 99.99% (region); 99.5% (instance)
- RDS Multi-AZ: 99.95%
- S3: 99.9% availability; 99.999999999% durability
- CloudFront: 99.9% (if used)

**Monitoring**: CloudWatch tracks actual vs. SLA; AWS credits claimed if SLA breached

---

## 17. Certification Management

### 17.1 Current Certifications
[To be updated as certifications obtained]

| **Certification** | **Status** | **Certificate Number** | **Issue Date** | **Expiry Date** | **Surveillance** |
|------------------|-----------|----------------------|--------------|----------------|-----------------|
| ISO 27001:2022 | [Planned / In Progress / Certified] | [Number] | [Date] | [Date] | Annual |
| ISO 9001:2015 | [Planned / In Progress / Certified] | [Number] | [Date] | [Date] | Annual |
| PCI DSS | [N/A / Required / Compliant] | [AOC] | [Date] | [Date] | Annual |

### 17.2 Certification Maintenance
- Maintain compliance continuously (not just during audits)
- Address non-conformities promptly
- Participate in surveillance audits
- Communicate certification to customers (website, proposals)

---

## 18. Record Retention and Disposal

**See also**: Asset Management Policy, Data Protection Policy

### 18.1 Retention Schedule
Per Section 9.1 (Records Management)

### 18.2 Secure Disposal
- Digital: Secure deletion per sanitization standards
- Paper: Shredding (cross-cut shredder or certified disposal service)
- Certification: Certificate of destruction for confidential records

---

## 19. Intellectual Property Protection

### 19.1 EPACT IP Assets
- Source code (proprietary, confidential)
- Business processes and methodologies
- Trademarks: "EPACT" [Register if not already]
- Trade secrets: Customer lists, algorithms

**Protection**:
- NDAs with employees, contractors, partners
- Confidential classification
- Access controls
- Legal action against infringement

### 19.2 Respect for Third-Party IP
- License compliance (software, images, fonts, etc.)
- Attribution where required (open source)
- No copyright infringement (training provided)

---

## 20. Cross-Border Data Considerations

### 20.1 Data Residency
**Policy**: Customer data remains in UK / EU (AWS eu-west-2 region)

**Enforcement**:
- Terraform configuration specifies region
- No S3 cross-region replication
- No cross-region backups (current state; may change)

### 20.2 International Customers
**EU/UK customers**: Standard processing (adequacy)

**Non-EU/UK customers**:
- Data still processed in UK (adequate protection)
- Standard Contractual Clauses (if customer requires)
- Customer notification of data location

### 20.3 Brexit Considerations
- UK GDPR and EU GDPR alignment monitored
- UK adequacy decision (currently in place; monitor for changes)
- Standard Contractual Clauses prepared if UK adequacy withdrawn

---

## 21. Compliance Training

### 21.1 Annual Training (All Staff)
- GDPR and data protection responsibilities
- ISO 27001 policy overview
- Legal and regulatory obligations
- Compliance violations consequences
- How to report non-compliance

### 21.2 Specialized Training
- **Development team**: Secure coding, PCI DSS (if applicable)
- **ISMS Lead**: ISO 27001 lead implementer course; GDPR practitioner
- **Senior Developer**: AWS security certifications

### 21.3 Training Records
- Completion tracked in training register
- Certificates retained for audit
- Non-completion escalated

---

## 22. Compliance Reporting

### 22.1 To Managing Director (Quarterly)
- Compliance status dashboard
- Regulatory changes affecting EPACT
- Audit findings and remediation status
- Compliance risks and issues
- Upcoming compliance deadlines (certifications, filings)

### 22.2 To Customers (Annually or Upon Request)
- Security posture summary
- Compliance certifications (ISO 27001, SOC 2)
- Major security enhancements
- Anonymized incident statistics

### 22.3 To Regulators (As Required)
- ICO: Data breach notifications, annual assessment
- Companies House: Annual filings
- HMRC: Tax filings

---

## 23. Related Documents

- Information Security Policy
- Data Protection and Privacy Policy
- Risk Management Policy
- All other ISO 27001 policies
- GDPR Privacy Notice
- ISO 27001 Statement of Applicability (SOA)

---

## 24. Management Approval

**Name**: Akam Rahimi  
**Position**: Managing Director  
**Signature**: ________________________________  
**Date**: ________________________________

---

**END OF POLICY**

