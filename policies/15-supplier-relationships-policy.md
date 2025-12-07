# Supplier Relationships Policy

**EPACT LTD** | Company Registration: 11977631

## Document Control
| Version | 1.0 | Owner | Managing Director |
|---------|-----|-------|-------------------|
| **ISO 27001 Ref** | A.5.19-A.5.23 | **Approved** | Akam Rahimi |

---

## 1. Purpose

Ensure information security risks related to supplier and third-party relationships are identified, assessed, and managed.

---

## 2. Supplier Classification

### 2.1 Critical Suppliers
**Definition**: Suppliers whose failure would severely impact business

**EPACT Critical Suppliers**:
1. **Amazon Web Services (AWS)**: Complete infrastructure
2. **Domain registrar**: DNS and domain management
3. **Email provider**: Business communications [Specify: Google Workspace / Office 365]
4. **Payment processor**: Customer billing (if applicable)

**Requirements**:
- ISO 27001, SOC 2, or equivalent certification
- Annual security review
- Data Processing Agreement (if processing personal data)
- Business continuity plan verification
- SLA with penalties

### 2.2 Important Suppliers
**Definition**: Suppliers providing significant services but alternatives available

**Examples**:
- Monitoring/alerting tools (if third-party beyond AWS)
- Code repository (GitHub/GitLab)
- Communication tools (Slack, Teams)

**Requirements**:
- Security questionnaire completed
- Contract includes security clauses
- Annual renewal review
- DPA if processing personal data

### 2.3 Standard Suppliers
**Definition**: Low-risk suppliers; minimal data access

**Examples**:
- Office supplies
- Marketing services
- Non-technical consultants

**Requirements**:
- Standard terms and conditions
- NDA if accessing confidential information
- Basic security review

---

## 3. Supplier Onboarding

### 3.1 Security Assessment
**Before Engagement**:
1. Complete supplier security questionnaire
2. Review privacy policy and security practices
3. Request compliance certificates (ISO 27001, SOC 2)
4. Assess data processing role (controller, processor, sub-processor)
5. Evaluate security controls (encryption, access controls, incident response)
6. Risk assessment (likelihood and impact of supplier failure or breach)
7. ISMS Lead approval for critical/important suppliers
8. Managing Director approval for contracts >£10,000/year

**Red Flags** (proceed with caution or reject):
- No information security policy
- Unencrypted data storage or transmission
- No incident response capability
- No compliance certifications
- Poor reputation or history of breaches
- Located in high-risk jurisdiction (data transfer concerns)

### 3.2 Contract Requirements

**Mandatory Clauses** (all suppliers):
- Confidentiality and non-disclosure
- Data protection and privacy (if personal data processed)
- Security incident notification (24-hour SLA)
- Right to audit or receive audit reports
- Compliance with applicable laws
- Liability and indemnification
- Termination assistance (data return/deletion)
- Insurance requirements (professional indemnity, cyber)

**Data Processing Agreement** (Supplier as Processor):
- GDPR Article 28 requirements
- Instructions for processing
- Security measures
- Sub-processor approval mechanism
- Data subject rights assistance
- Data breach notification
- Post-termination data handling

---

## 4. AWS (Primary Supplier)

### 4.1 AWS Security Assurance
**Certifications** (verified annually):
- ISO 27001, ISO 27017, ISO 27018
- SOC 1, SOC 2, SOC 3
- PCI DSS Level 1
- GDPR-compliant (Data Processing Addendum)

**AWS Shared Responsibility Model**:
- **AWS Responsibility**: Physical security, infrastructure, network, hypervisor
- **EPACT Responsibility**: Data, applications, OS, IAM, encryption, security groups, firewalls

**Monitoring AWS Security**:
- AWS Service Health Dashboard (daily check)
- AWS security bulletins (subscribed)
- AWS re:Post and security blog (weekly review)
- AWS Trust & Safety reports (quarterly)

### 4.2 AWS Service Selection
**Approved Services** (Security-reviewed):
- See Operations Security Policy Section 20.1

**New Service Adoption**:
- Security review (ISMS Lead)
- Privacy assessment (DPO if personal data)
- Documentation review (AWS security whitepapers)
- Testing in non-production
- Terraform module development
- Approval and production deployment

---

## 5. Supplier Performance Management

### 5.1 SLA Monitoring
**AWS SLAs** (monitored monthly):
- EC2: 99.99% region availability
- RDS Multi-AZ: 99.95% availability
- S3: 99.9% availability
- CloudFront: 99.9% (if used)

**SLA Breach Process**:
1. Identify breach (uptime metrics)
2. Document evidence (CloudWatch charts)
3. Submit SLA credit request to AWS
4. Track credit application and receipt
5. Escalate if AWS disputes valid claim

### 5.2 Annual Supplier Review
**For All Critical/Important Suppliers**:
- Security posture assessment
- Compliance certification verification
- SLA performance review
- Incident history (supplier-side)
- Cost vs. value analysis
- Relationship satisfaction (internal feedback)
- Renewal or replacement decision

**Documentation**: Supplier review report (signed by Managing Director)

---

## 6. Supplier Access Management

### 6.1 Principle
**Minimize supplier access** to EPACT systems and data

### 6.2 AWS Access
- **No shared IAM users**: AWS Support accesses via own authentication
- **Support cases**: Submitted via AWS Support Center
- **Trusted Advisor**: AWS provides recommendations; no direct access to systems
- **Enterprise Support**: TAM (Technical Account Manager) if subscribed

### 6.3 Third-Party Tool Access
**If supplier requires access** (monitoring tools, support, consultants):
- Temporary IAM role with minimum permissions
- MFA required
- Access time-limited (max 7 days; extend if needed)
- Activity logged to CloudTrail
- Access revoked immediately after work completed
- Reviewed by ISMS Lead post-access

---

## 7. Supplier Incidents

### 7.1 Supplier Breach Notification
**Supplier must notify EPACT** within 24 hours of:
- Security incidents affecting EPACT data
- Data breaches involving personal data
- Service outages affecting EPACT
- Compliance violations

**EPACT Response**:
1. Assess impact on EPACT operations and customer data
2. Activate incident response if customer impact
3. Notify affected customers per GDPR requirements
4. Work with supplier on remediation
5. Review supplier relationship (continue, replace, or add controls)

### 7.2 AWS Incident Monitoring
- Subscribe to AWS Personal Health Dashboard (alerts for events affecting EPACT resources)
- Monitor AWS Service Health Dashboard (region-wide issues)
- AWS Security Bulletins (subscribe to RSS/email)

---

## 8. Supplier Termination

### 8.1 Termination Assistance
**Supplier obligations at contract end**:
- Return all EPACT data and confidential information
- Securely delete EPACT data from supplier systems
- Certification of deletion provided
- Revoke all access (accounts, tokens, keys)
- Transfer knowledge and documentation
- Cooperate with transition to new supplier

**Timeline**: Within 30 days of termination (or as specified in contract)

### 8.2 Data Recovery
- Export all data in usable format (JSON, CSV, SQL)
- Verify data completeness
- Import to new system
- Parallel run period (if feasible)
- Final cutover after verification

---

## 9. Supply Chain Security

### 9.1 Software Supply Chain
**Dependencies** (application and infrastructure):
- **Dependency scanning**: Automated (Dependabot, Snyk, npm audit)
- **Version pinning**: Lock files for reproducibility
- **Vulnerability monitoring**: Alerts for CVEs in dependencies
- **Update process**: Test updates in dev/staging before production

**Terraform Modules**:
- Use official HashiCorp modules or verified community modules
- Source from trusted registries (Terraform Registry, GitHub)
- Version pinning (avoid `latest`)
- Code review before adoption

### 9.2 Open Source Risks
- **License compliance**: Automated scanning for incompatible licenses
- **Security**: No unmaintained or abandoned projects
- **Provenance**: Verify publisher identity (GPG signatures)
- **Forks**: Use original repos; avoid unmaintained forks

---

## 10. Compliance

### 10.1 Supplier Compliance Requirements
- GDPR-compliant (if processing personal data)
- ISO 27001 certified (preferred for critical suppliers)
- UK/EU data residency (for personal data)
- Contractual compliance (security, privacy, SLA)

### 10.2 Audit Evidence
- Supplier register (list of all suppliers)
- Supplier security assessments
- Contracts with security clauses
- DPAs (data processing agreements)
- Supplier compliance certificates (ISO, SOC 2)
- Annual supplier review reports
- Supplier incident log

---

## 11. Related Documents
- Information Security Policy
- Data Protection Policy
- Risk Management Policy

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

