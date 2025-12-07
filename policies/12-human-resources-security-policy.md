# Human Resources Security Policy

**EPACT LTD** | Company Registration: 11977631  
International House, 36-38 Cornhill, London, England, EC3V 3NG

## Document Control
| Version | 1.0 | Owner | Managing Director |
|---------|-----|-------|-------------------|
| **Approved By** | Akam Rahimi | **ISO 27001 Ref** | A.6.1-A.6.4, A.6.7 |

---

## 1. Pre-Employment

### 1.1 Recruitment Screening
- **Background checks**: For roles with system access
  - Identity verification (passport/driving license)
  - Employment history verification (2 previous roles)
  - Professional references (2 minimum)
  - Criminal record check (DBS) for privileged access roles
- **Timeline**: Completed before start date

### 1.2 Employment Contracts
**Must include**:
- Confidentiality obligations (during and post-employment)
- Acceptable use of systems
- IP assignment (work product owned by EPACT)
- Data protection responsibilities
- Security policy compliance requirement
- Right to monitor systems and communications
- Disciplinary procedures for security violations

### 1.3 Contractor Agreements
**Must include**:
- Non-Disclosure Agreement (NDA)
- Security policy compliance
- Access restrictions (least privilege)
- Data protection obligations (GDPR)
- No subcontracting without approval
- Termination clauses (immediate for security violations)

---

## 2. During Employment

### 2.1 Security Awareness Training
**All Employees**:
- **Induction**: First week of employment (4 hours)
  - Information security policy overview
  - Data classification and handling
  - Password security and MFA
  - Phishing and social engineering recognition
  - Incident reporting
  - Acceptable use policy

- **Annual Refresher**: Every 12 months (2 hours minimum)
  - Updated threat landscape
  - New policies and procedures
  - Incident case studies
  - GDPR obligations
  - Quiz/assessment (80% pass required)

- **Ad-hoc**: After incidents or major changes

**Privileged Users** (Development team, ISMS Lead):
- **Additional training** (annually):
  - Secure coding (OWASP Top 10)
  - AWS security best practices
  - Terraform security
  - Incident response
  - Advanced threat awareness

**Training Records**: Tracked in training register; evidence for audits

### 2.2 Roles and Responsibilities

**Managing Director**:
- Overall accountability for information security
- Policy approval
- Resource allocation
- Legal and regulatory compliance

**ISMS Lead / DPO** (Akam Rahimi):
- Day-to-day ISMS management
- Data protection compliance
- Incident management
- Policy development and maintenance
- Audit coordination
- Training delivery

**Business Development Director**:
- Customer security commitments
- Contract security review
- Security-related customer communications

**Senior Developer**:
- Infrastructure security (Terraform, AWS)
- Application security (code review, secure design)
- Technical security controls implementation
- Vulnerability management

**Developer**:
- Secure coding practices
- Code review participation
- Security testing
- Documentation

**Support Team**:
- Monitoring and alerting response
- User account management
- First-line incident response
- Log review

### 2.3 Performance Management
- Security responsibilities in job descriptions
- Security objectives in performance reviews
- Recognition for good security practices
- Corrective action for poor security behavior

### 2.4 Disciplinary Process for Security Violations

| **Violation** | **First Offense** | **Repeat Offense** |
|--------------|------------------|-------------------|
| Unintentional policy violation (minor) | Coaching, training | Written warning |
| Negligent behavior (significant risk) | Written warning | Final warning or suspension |
| Intentional violation or gross negligence | Suspension, investigation | Termination |
| Malicious activity, fraud, theft | Immediate termination, legal action | N/A |

**Investigation**: Fair and confidential; opportunity to respond

---

## 3. Employment Termination or Change

### 3.1 Termination Checklist
**Last Working Day**:
- [ ] All access revoked (AWS IAM, applications, email, VPN)
- [ ] Company property returned (laptop, phone, keys, MFA tokens)
- [ ] Exit interview conducted
- [ ] Confidentiality reminder (ongoing obligations)
- [ ] Termination form signed by employee and line manager
- [ ] Asset register updated
- [ ] Email forwarding (if needed for business continuity)
- [ ] Shared credentials rotated (if employee had access)

**IT Access Removal** (within 1 hour of notification):
- AWS IAM user: Disabled, then deleted after 30 days
- Application accounts: Disabled
- VPN: Access revoked
- MFA devices: De-registered
- Git repository: Permissions removed
- Email: Forwarded to manager or converted to shared mailbox (temporary)

### 3.2 Role Changes
**Internal Transfers/Promotions**:
- Access review (remove unnecessary access from old role)
- New access provisioned per new role
- Training for new security responsibilities
- Updated in HR system and access register

**Contractors End of Engagement**:
- Access revoked on contract end date (automated if possible)
- Final deliverables received
- Knowledge transfer completed
- NDA reminder
- No final payment until access revoked and assets returned

### 3.3 Extended Leave (>30 Days)
**Sabbatical, Maternity, Long-term Illness**:
- Access suspended (not deleted)
- Email auto-responder with alternative contact
- Handover procedures to covering person
- Access restored upon return (after verification)

---

## 4. Confidentiality Agreements

### 4.1 Employee NDAs
**Signed at**:
- Start of employment
- Before access to confidential systems/data
- Re-acknowledged annually

**Coverage**:
- EPACT confidential information
- Customer data (as data processor)
- Trade secrets
- Business strategies
- Source code and technical designs

**Duration**: During employment + 2 years post-termination (or indefinitely for trade secrets)

### 4.2 Contractor/Supplier NDAs
- Required before access to EPACT systems or customer data
- Mutual NDA (two-way confidentiality)
- Standard template approved by legal
- Signed before work commences

---

## 5. Remote Working Security

**See also**: Remote Working Policy (detailed)

### 5.1 Remote Work Requirements
- **Equipment**: Company laptop (encrypted, managed)
- **Connectivity**: Home broadband or mobile hotspot with VPN
- **Workspace**: Secure, private area
- **Screen privacy**: Privacy filter for work in public
- **Physical security**: Lock devices when not in use; clean desk

### 5.2 Information Security for Remote Workers
- No storage of RESTRICTED data on local drives (cloud only)
- VPN for accessing internal systems
- MFA for all authentication
- No public WiFi without VPN
- Family members not allowed access to company devices

---

## 6. Compliance

### 6.1 Policy Compliance
- HR reviews policy annually
- Employee acknowledgments tracked
- Non-compliance addressed through disciplinary process

### 6.2 Audit Evidence
- Employment contracts (confidentiality clauses)
- NDAs (signed copies)
- Background check records
- Training records (completion, scores, certificates)
- Termination checklists (access revocation proof)

---

## 7. Related Documents
- Information Security Policy
- Access Control Policy
- Remote Working Policy
- Acceptable Use Policy
- Data Protection Policy

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

