# Supplier Security Assessment Questionnaire

**EPACT LTD** - Third-Party Security Evaluation

---

## Supplier Information

**Assessment Date**: ________________________________  
**Assessed By**: ________________________________ *(ISMS Lead)*  
**Supplier Assessment ID**: SUP-ASSESS-YYYY-NNN

**Supplier Name**: ________________________________________________________________  
**Supplier Address**: ________________________________________________________________  
**Website**: ________________________________  
**Primary Contact**: ________________________________  
**Contact Email**: ________________________________  
**Contact Phone**: ________________________________

**Services to Be Provided**: ________________________________________________________________

**Will Supplier Process EPACT or Customer Data?** ☐ Yes ☐ No  
**Will Supplier Process Personal Data (GDPR)?** ☐ Yes ☐ No  
**Contract Value (Annual)**: £ ________________________________  
**Supplier Classification**: ☐ Critical ☐ Important ☐ Standard

---

## Section 1: General Information Security

### 1.1 Information Security Policy
**Q1**: Does your organization have a documented information security policy?  
☐ Yes ☐ No ☐ In Development

**If YES**:
- Approved by senior management? ☐ Yes ☐ No
- Reviewed annually? ☐ Yes ☐ No
- Communicated to all employees? ☐ Yes ☐ No
- **Please attach** copy of policy or summary

### 1.2 Information Security Management
**Q2**: Do you have a dedicated information security officer/team?  
☐ Yes ☐ No

**If YES**:
- Name/Title: ________________________________
- Contact: ________________________________

**Q3**: When was your last security risk assessment?  
Date: ________________________________

**Q4**: Do you maintain an information security risk register?  
☐ Yes ☐ No

---

## Section 2: Compliance and Certifications

### 2.1 Certifications

**Q5**: Does your organization hold any of the following certifications? *(Check all that apply)*

**Information Security**:
- ☐ ISO/IEC 27001 (Certificate number: ________________ Expiry: ________)
- ☐ ISO/IEC 27017 (Cloud security)
- ☐ ISO/IEC 27018 (Cloud privacy)
- ☐ SOC 2 Type II (Report date: ____________)
- ☐ Cyber Essentials / Cyber Essentials Plus (UK)

**Data Protection**:
- ☐ GDPR-compliant *(provide evidence)*
- ☐ Privacy Shield (if US-based; now invalid but indicates privacy practices)

**Industry-Specific**:
- ☐ PCI DSS Level [1/2/3/4] *(if processing payment cards)*
- ☐ HIPAA compliant *(if processing health data)*
- ☐ FedRAMP *(if US government)*

**Quality**:
- ☐ ISO 9001 (Quality management)

**Other**:
- ☐ ________________________________

**Please provide**: Copies of current certificates or attestation reports

**Q6**: Do you conduct annual compliance audits?  
☐ Yes ☐ No

**If YES**, by whom? ☐ Internal ☐ External auditor ☐ Both

---

## Section 3: Data Protection and Privacy

### 3.1 GDPR Compliance (If Processing Personal Data)

**Q7**: Is your organization registered with the UK ICO (or relevant EU DPA)?  
☐ Yes (Registration number: ________________) ☐ No ☐ N/A (no personal data)

**Q8**: Do you have a designated Data Protection Officer (DPO)?  
☐ Yes ☐ No ☐ N/A

**If YES**:
- DPO Name: ________________________________
- DPO Email: ________________________________

**Q9**: Can you provide a Data Processing Agreement (DPA) that meets GDPR Article 28 requirements?  
☐ Yes (attach) ☐ Yes (will provide) ☐ No

**Q10**: Do you have documented procedures for:
- Data subject access requests (SARs)? ☐ Yes ☐ No
- Data breach notification? ☐ Yes ☐ No
- Data portability? ☐ Yes ☐ No
- Data erasure/right to be forgotten? ☐ Yes ☐ No

### 3.2 Data Location and Transfer

**Q11**: Where is data physically stored? *(List all locations)*

- Primary: ________________________________________________________________
- Backup/DR: ________________________________________________________________

**Q12**: Is data transferred outside the UK/EU?  
☐ Yes ☐ No

**If YES**:
- Destination countries: ________________________________
- Safeguards: ☐ Adequacy decision ☐ Standard Contractual Clauses ☐ BCR ☐ Other

**Q13**: Do you use sub-processors?  
☐ Yes ☐ No

**If YES**, provide list: ________________________________________________________________

---

## Section 4: Security Controls

### 4.1 Access Control

**Q14**: Do you enforce the following for user accounts:
- Unique user IDs (no shared accounts)? ☐ Yes ☐ No
- Strong password policy (minimum 12 characters, complexity)? ☐ Yes ☐ No
- Multi-Factor Authentication (MFA)? ☐ Yes, mandatory ☐ Yes, optional ☐ No
- Regular access reviews? ☐ Yes ☐ No (Frequency: _________)
- Immediate access revocation upon termination? ☐ Yes ☐ No

**Q15**: Do you implement role-based access control (RBAC) or least privilege?  
☐ Yes ☐ No ☐ Partially

**Q16**: Are administrative actions logged?  
☐ Yes ☐ No

### 4.2 Encryption

**Q17**: Is data encrypted at rest?  
☐ Yes, all data ☐ Yes, sensitive data only ☐ No

**If YES**:
- Encryption standard: ☐ AES-256 ☐ AES-128 ☐ Other: ________
- Key management: ☐ Customer-managed ☐ Provider-managed

**Q18**: Is data encrypted in transit?  
☐ Yes ☐ No

**If YES**:
- Protocols: ☐ TLS 1.3 ☐ TLS 1.2 ☐ TLS 1.1 or lower (not acceptable)
- Certificate authority: ________________________________

**Q19**: How are encryption keys managed?
- ☐ Hardware Security Module (HSM)
- ☐ Key Management Service (KMS)
- ☐ Software-based key storage
- ☐ Other: ________________________________

**Key rotation**: ☐ Automatic ☐ Manual (Frequency: _________)

### 4.3 Network Security

**Q20**: Do you implement network segmentation?  
☐ Yes ☐ No

**Q21**: Do you use firewalls?  
☐ Yes ☐ No

**Type**: ☐ Network firewall ☐ Web Application Firewall (WAF) ☐ Both

**Q22**: Do you have DDoS protection?  
☐ Yes ☐ No

**Q23**: Do you monitor network traffic for anomalies?  
☐ Yes ☐ No

---

## Section 5: Security Monitoring and Incident Response

### 5.1 Monitoring

**Q24**: Do you have 24/7 security monitoring?  
☐ Yes ☐ No ☐ Business hours only

**Q25**: What security monitoring tools do you use?
- ☐ SIEM (Security Information and Event Management)
- ☐ IDS/IPS (Intrusion Detection/Prevention)
- ☐ Log management and analysis
- ☐ Vulnerability scanning
- ☐ Antimalware
- ☐ Other: ________________________________________________________________

**Q26**: How long are security logs retained?  
________________________________

### 5.2 Incident Response

**Q27**: Do you have a documented incident response plan?  
☐ Yes ☐ No

**If YES**:
- Last tested: ________________________________
- Testing frequency: ________________________________

**Q28**: What is your commitment for notifying EPACT of security incidents affecting our data?  
☐ Within 24 hours ☐ Within 48 hours ☐ Within 72 hours ☐ Other: ________

**Q29**: Have you experienced any security breaches in the last 24 months?  
☐ Yes ☐ No

**If YES**, please provide brief details:

________________________________________________________________
________________________________________________________________

---

## Section 6: Physical and Environmental Security

**Q30**: Where are your data centers/offices located?  
________________________________________________________________

**Q31**: Do your facilities have:
- Physical access controls (guards, badges, etc.)? ☐ Yes ☐ No
- CCTV surveillance? ☐ Yes ☐ No
- Fire suppression systems? ☐ Yes ☐ No
- Redundant power (UPS, generators)? ☐ Yes ☐ No
- Environmental controls (cooling, humidity)? ☐ Yes ☐ No

**Q32**: If cloud-based, which provider(s) do you use?
- ☐ AWS ☐ Azure ☐ Google Cloud ☐ Other: ________________________________

---

## Section 7: Backup and Business Continuity

**Q33**: Do you perform regular backups of data?  
☐ Yes ☐ No

**If YES**:
- Backup frequency: ☐ Continuous ☐ Daily ☐ Weekly ☐ Other: ________
- Backup location: ☐ Offsite ☐ Cloud ☐ Same location
- Backup encryption: ☐ Yes ☐ No
- Backup testing frequency: ☐ Monthly ☐ Quarterly ☐ Annually ☐ Never

**Q34**: Do you have a Business Continuity Plan (BCP)?  
☐ Yes ☐ No

**If YES**:
- Last tested: ________________________________
- RTO (Recovery Time Objective): ________________________________
- RPO (Recovery Point Objective): ________________________________

**Q35**: Do you have a Disaster Recovery Plan (DRP)?  
☐ Yes ☐ No

**Q36**: What is your uptime SLA?  
________________________________ % (e.g., 99.9%)

---

## Section 8: Vulnerability and Patch Management

**Q37**: Do you conduct vulnerability assessments?  
☐ Yes ☐ No

**Frequency**: ☐ Continuous ☐ Monthly ☐ Quarterly ☐ Annually

**Q38**: Do you perform penetration testing?  
☐ Yes ☐ No

**If YES**:
- Frequency: ☐ Annually ☐ Bi-annually ☐ Other: ________
- Last test date: ________________________________
- Conducted by: ☐ Internal team ☐ External firm ☐ Both

**Q39**: What is your patch management process?

**Critical security patches**: Applied within ________ days  
**Standard updates**: Applied within ________ days

**Q40**: Do you scan for vulnerabilities in third-party dependencies?  
☐ Yes ☐ No

---

## Section 9: Personnel Security

**Q41**: Do you conduct background checks on employees with access to customer data?  
☐ Yes ☐ No

**Q42**: Do all employees sign confidentiality/non-disclosure agreements?  
☐ Yes ☐ No

**Q43**: Do employees receive security awareness training?  
☐ Yes ☐ No

**If YES**, frequency: ☐ Onboarding only ☐ Annual ☐ Quarterly

**Q44**: How do you handle employee terminations?
- Access revocation timeline: ________________________________
- Equipment return process: ________________________________________________________________
- Exit procedures documented: ☐ Yes ☐ No

---

## Section 10: Third-Party and Supply Chain

**Q45**: Do you use sub-contractors or sub-processors?  
☐ Yes ☐ No

**If YES**:
- Do you conduct security assessments of sub-contractors? ☐ Yes ☐ No
- List key sub-contractors: ________________________________________________________________

**Q46**: Do you have security requirements in your supplier contracts?  
☐ Yes ☐ No

---

## Section 11: Audit and Transparency

**Q47**: Do you allow customer security audits or assessments?  
☐ Yes ☐ Yes, with restrictions ☐ No

**Q48**: Can you provide SOC 2 Type II reports or equivalent to customers?  
☐ Yes ☐ Yes, under NDA ☐ No ☐ N/A (not obtained)

**Q49**: How often do you conduct internal security audits?  
☐ Quarterly ☐ Semi-annually ☐ Annually ☐ Never

**Q50**: Do you have an external security audit program?  
☐ Yes ☐ No

---

## Section 12: Insurance

**Q51**: Do you carry cyber liability insurance?  
☐ Yes ☐ No

**If YES**:
- Coverage amount: £ ________________________________
- Provider: ________________________________
- Policy number: ________________________________

**Q52**: Do you carry Professional Indemnity insurance?  
☐ Yes ☐ No

**If YES**, coverage: £ ________________________________

---

## Section 13: Specific to EPACT Requirements

### 13.1 AWS-Specific (If AWS-based supplier)

**Q53**: Which AWS services do you use?  
________________________________________________________________

**Q54**: Which AWS region(s)?  
- Primary: ________________________________________________________________
- DR/Backup: ________________________________________________________________

**Q55**: Do you use AWS security services?
- GuardDuty? ☐ Yes ☐ No
- Security Hub? ☐ Yes ☐ No
- Config? ☐ Yes ☐ No
- CloudTrail? ☐ Yes ☐ No

### 13.2 Multi-Tenancy (If SaaS provider)

**Q56**: Is your platform multi-tenant?  
☐ Yes ☐ No ☐ N/A

**If YES**:
- How is tenant data isolated? ________________________________________________________________
- Have you experienced any cross-tenant data leakage? ☐ Yes ☐ No
- If YES, details: ________________________________________________________________

### 13.3 Data Return and Deletion

**Q57**: Upon contract termination, can you:
- Return all data in usable format (JSON, CSV)? ☐ Yes ☐ No
- Securely delete all data from your systems? ☐ Yes ☐ No
- Provide certification of deletion? ☐ Yes ☐ No

**Data deletion timeline**: ________________________________ *(days after termination)*

---

## Section 14: Security Incidents

**Q58**: Have you experienced any of the following in the last 24 months?

- Data breach? ☐ Yes ☐ No
  - If YES, brief details: ________________________________________________________________
- Ransomware attack? ☐ Yes ☐ No
- DDoS attack? ☐ Yes ☐ No
- Regulatory enforcement action? ☐ Yes ☐ No
- Customer data compromise? ☐ Yes ☐ No

**Q59**: Have any incidents been reported to regulators (ICO, etc.)?  
☐ Yes ☐ No

**If YES**, please provide details or public incident reports.

**Q60**: What was your response and lessons learned?

________________________________________________________________
________________________________________________________________

---

## Section 15: References and Due Diligence

**Q61**: Can you provide customer references for security due diligence?  
☐ Yes ☐ No

**Reference 1**:
- Company: ________________________________
- Contact: ________________________________
- Email: ________________________________

**Q62**: Are you willing to participate in onboarding security calls/meetings?  
☐ Yes ☐ No

**Q63**: Additional information or clarifications:

________________________________________________________________
________________________________________________________________
________________________________________________________________

---

## EPACT Assessment

### Security Assessment Score

**Scoring** *(ISMS Lead completes)*:

| Category | Possible Points | Score | Notes |
|----------|----------------|-------|-------|
| Certifications (ISO 27001, SOC 2) | 20 | | |
| GDPR Compliance | 20 | | |
| Access Controls & Authentication | 15 | | |
| Encryption (at rest and in transit) | 15 | | |
| Monitoring and Logging | 10 | | |
| Incident Response | 10 | | |
| Business Continuity & DR | 5 | | |
| Personnel Security | 5 | | |
| **TOTAL** | **100** | | |

**Overall Score**: _______ / 100

**Rating**:
- 90-100: **Excellent** - Highly trusted supplier
- 75-89: **Good** - Acceptable with standard contract
- 60-74: **Adequate** - Acceptable with additional security requirements in contract
- Below 60: **Insufficient** - Significant concerns; consider alternative supplier or enhanced due diligence

### Risk Level

**Supplier Risk Level**: ☐ Low ☐ Medium ☐ High ☐ Unacceptable

**Justification**:

________________________________________________________________
________________________________________________________________

### Red Flags Identified

**Concerns** *(Any of these may be disqualifying)*:
- ☐ No information security policy
- ☐ Recent unresolved data breach
- ☐ No encryption of data
- ☐ No certifications (for critical suppliers)
- ☐ Data stored in high-risk jurisdiction
- ☐ No incident response capability
- ☐ No backup or DR plan
- ☐ Poor security track record
- ☐ Unwilling to sign DPA
- ☐ Cannot provide adequate transparency
- ☐ Other: ________________________________________________________________

---

## Recommendation

### ISMS Lead Recommendation

**Recommendation**: ☐ Approve ☐ Approve with Conditions ☐ Reject ☐ Request Additional Information

**Conditions** *(if applicable)*:
1. ________________________________________________________________
2. ________________________________________________________________
3. ________________________________________________________________

**Additional Due Diligence Required**:
- ☐ Reference checks
- ☐ On-site visit or virtual assessment
- ☐ Third-party security audit report review
- ☐ Trial period (limited scope)
- ☐ Legal review of DPA
- ☐ Technical security testing
- ☐ Other: ________________________________________________________________

**Justification**:

________________________________________________________________
________________________________________________________________

**ISMS Lead Signature**: ________________________________  
**Name**: Akam Rahimi  
**Date**: ________________________________

### Managing Director Approval

**Required for**: Critical suppliers, contracts >£10,000/year

**Managing Director Decision**: ☐ Approve ☐ Approve with Conditions ☐ Reject

**Signature**: ________________________________  
**Name**: Akam Rahimi  
**Date**: ________________________________

---

## Follow-Up Actions

**Actions Required Before Engagement**:
1. ☐ Obtain and review certifications (ISO 27001, SOC 2)
2. ☐ Negotiate and sign Data Processing Agreement
3. ☐ Include security requirements in master contract
4. ☐ Set up ongoing monitoring (review cycle, contact points)
5. ☐ Add to supplier register
6. ☐ Schedule annual security review
7. ☐ Other: ________________________________________________________________

**Assigned To**: ________________________________  
**Due Date**: ________________________________

---

## Ongoing Monitoring

**Annual Review Date**: ________________________________  
**Review Includes**:
- ☐ Recertification status (ISO, SOC 2)
- ☐ Incident history (any breaches?)
- ☐ SLA compliance
- ☐ Updated security questionnaire
- ☐ Contract renewal decision

---

**File Location**: /policies/supplier-assessments/SUP-ASSESS-YYYY-NNN.pdf  
**Retention**: Duration of contract + 3 years  
**Supplier Register Entry**: SUP-YYYY-NNN

---

**CONFIDENTIAL - Internal Use Only - Supplier Security Assessment**

