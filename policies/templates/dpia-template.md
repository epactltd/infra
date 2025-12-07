# Data Protection Impact Assessment (DPIA)

**EPACT LTD** - Privacy Impact Assessment

---

## Document Control

**DPIA ID**: DPIA-YYYY-NNN  
**Assessment Date**: ________________________________  
**Assessed By** (DPO): Akam Rahimi  
**Email**: akam@epact.co.uk  
**Review Date**: ________________________________ *(Annual or when processing changes)*

**ISO 27001 / GDPR Reference**: A.5.33, GDPR Article 35

---

## Section 1: Processing Description

### 1.1 Project/Processing Activity Name

________________________________________________________________

### 1.2 Purpose of Processing

**What are you trying to achieve?**

________________________________________________________________
________________________________________________________________

**Business objectives**:

________________________________________________________________

### 1.3 Nature of Processing

**Type of processing** *(Select all that apply)*:
- ☐ Collection
- ☐ Recording / Organization
- ☐ Storage
- ☐ Adaptation or alteration
- ☐ Retrieval / Consultation
- ☐ Use / Analysis
- ☐ Disclosure by transmission
- ☐ Combination / Linking
- ☐ Restriction
- ☐ Erasure or destruction

**Processing methods**:
- ☐ Automated
- ☐ Manual
- ☐ Both

**Is this**:
- ☐ New processing activity
- ☐ Change to existing processing
- ☐ New technology or methodology

### 1.4 Scope of Processing

**What personal data will be processed?**

**Data Categories** *(Select all that apply)*:
- ☐ Basic identifiers (names, email, phone, address)
- ☐ Account/authentication data (usernames, passwords hashed)
- ☐ Financial data (billing, payment details)
- ☐ Employment data (if employee processing)
- ☐ Usage data (logs, IP addresses, timestamps)
- ☐ Communication data (emails, messages)
- ☐ Location data (IP geolocation)
- ☐ Technical data (device IDs, cookies, user agents)
- ☐ Preferences and settings
- ☐ Other: ________________________________

**Special category data?** ☐ Yes ☐ No

**If YES** (requires explicit legal basis):
- Data type: ________________________________
- Legal basis: ☐ Explicit consent ☐ Employment law ☐ Legal claims ☐ Other Article 9 exception

**Volume of data**: ________________________________ *(e.g., 10,000 records)*

**Data subjects** *(Select all that apply)*:
- ☐ Customers (B2B contacts)
- ☐ End users (tenant users of platform)
- ☐ Employees
- ☐ Contractors
- ☐ Suppliers
- ☐ Prospective customers
- ☐ Children (if yes, special considerations required)
- ☐ Vulnerable individuals
- ☐ Other: ________________________________

### 1.5 Context of Processing

**Lawful basis for processing** (GDPR Article 6):
- ☐ Consent (freely given, specific, informed, unambiguous)
- ☐ Contract (necessary for contract performance)
- ☐ Legal obligation
- ☐ Vital interests
- ☐ Public task
- ☐ Legitimate interests *(complete balancing test below)*

**If Legitimate Interests, Balancing Test**:

**Our legitimate interest**: ________________________________________________________________

**Necessity**: Is processing necessary for this purpose? ☐ Yes ☐ No

**Balancing**: Do individual's interests override our legitimate interests? ☐ Yes (cannot process) ☐ No (can process)

**Justification**: ________________________________________________________________

### 1.6 Controller, Processor, Third Parties

**Data Controller**: ☐ EPACT LTD ☐ Customer ☐ Joint controllers

**Data Processors** *(who processes on our behalf)*:
- AWS (infrastructure): ☐ Yes
- [Email provider]: ☐ Yes
- Other: ________________________________________________________________

**Third parties** *(who receives data)*:
- ________________________________________________________________

**International transfers?** ☐ Yes ☐ No

**If YES**:
- Destination countries: ________________________________
- Safeguards: ☐ Adequacy decision ☐ Standard Contractual Clauses ☐ Other

---

## Section 2: Necessity and Proportionality

### 2.1 Is Processing Necessary?

**Could you achieve the same purpose without personal data?** ☐ Yes ☐ No

**If NO** *(processing necessary)*:

**Why is personal data necessary?**

________________________________________________________________
________________________________________________________________

**Could you achieve it with less data or less intrusive processing?** ☐ Yes ☐ No

**Data minimization applied**:
- ☐ Collect only essential data fields
- ☐ Optional fields clearly marked
- ☐ Aggregate where possible
- ☐ Pseudonymize where feasible

### 2.2 Is Processing Proportionate?

**Is processing proportionate to the purpose?** ☐ Yes ☐ No

**Proportionality assessment**:
- Benefits to organization: ________________________________________________________________
- Benefits to individuals: ________________________________________________________________
- Necessity vs. intrusiveness: ☐ Proportionate ☐ Disproportionate

### 2.3 Retention

**How long will data be retained?**

________________________________________________________________

**Retention justification** *(why this period)*:

________________________________________________________________

**Deletion method**: ☐ Automated (lifecycle policies) ☐ Manual review ☐ Upon request

---

## Section 3: Data Subject Rights

### 3.1 Consultation with Data Subjects

**Have data subjects been consulted?** ☐ Yes ☐ No ☐ N/A (not appropriate)

**If YES, how**:
- ☐ Survey
- ☐ Focus groups
- ☐ Privacy notice review
- ☐ User testing

**Feedback received**:

________________________________________________________________

### 3.2 Rights Provided

**How will individuals exercise their rights?**

**Right to be informed**: ☐ Privacy notice provided ☐ Transparent processing

**Right of access**: ☐ SAR procedure documented ☐ 1-month response time

**Right to rectification**: ☐ Self-service in application ☐ Via support request

**Right to erasure**: ☐ Account deletion feature ☐ Manual processing

**Right to restrict processing**: ☐ Opt-out mechanism ☐ Temporary suspension capability

**Right to data portability**: ☐ JSON export feature ☐ Manual export via support

**Right to object**: ☐ Opt-out of marketing ☐ Object to legitimate interests processing

**Automated decision-making** (if applicable): ☐ Human review available ☐ N/A (no automated decisions)

---

## Section 4: Risk Identification

### 4.1 Risks to Individuals

**What could go wrong?** *(Identify risks to individuals' rights and freedoms)*

**Risk 1**: ________________________________________________________________

- **Likelihood**: ☐ Low ☐ Medium ☐ High
- **Impact on individuals**: ☐ Minor ☐ Moderate ☐ Severe ☐ Catastrophic
- **Potential harm**: ________________________________________________________________

**Risk 2**: ________________________________________________________________

- **Likelihood**: ☐ Low ☐ Medium ☐ High
- **Impact on individuals**: ☐ Minor ☐ Moderate ☐ Severe ☐ Catastrophic
- **Potential harm**: ________________________________________________________________

**Risk 3**: ________________________________________________________________

### 4.2 Specific Risks to Consider

**Unauthorized access or disclosure**:
- Could data be accessed by unauthorized parties (inside or outside organization)?
- Could data be disclosed accidentally?
- What would be the harm to individuals?

**Data quality and accuracy**:
- Could inaccurate data lead to wrong decisions about individuals?
- Is data kept up to date?

**Unfair or unlawful processing**:
- Could processing be used in discriminatory ways?
- Does processing respect individual autonomy and dignity?

**Function creep**:
- Could data be used for purposes not originally intended?
- Are safeguards in place to prevent scope expansion?

**Disproportionate impact**:
- Could processing disproportionately affect certain groups?
- Vulnerable individuals at greater risk?

---

## Section 5: Measures to Address Risks

### 5.1 Technical Measures

**For each risk identified above, list measures to reduce or eliminate**:

**Measure 1**: ________________________________________________________________
- **Addresses risk**: Risk 1, Risk 2 *(reference above)*
- **Effectiveness**: ☐ Eliminates risk ☐ Substantially reduces ☐ Partially reduces
- **Implementation status**: ☐ Implemented ☐ Planned ☐ Under consideration

**Technical measures implemented or planned**:

**Encryption**:
- ☐ Data encrypted at rest (AWS KMS AES-256)
- ☐ Data encrypted in transit (TLS 1.2+)
- ☐ Encryption keys securely managed (30-day deletion window; rotation)

**Access Controls**:
- ☐ Authentication required (MFA for admin)
- ☐ Authorization (role-based access control)
- ☐ Least privilege principle
- ☐ Access logging (CloudTrail, CloudWatch)

**Data Minimization**:
- ☐ Collect only necessary data
- ☐ Pseudonymization where possible
- ☐ Aggregation / anonymization for analytics

**Monitoring and Detection**:
- ☐ Audit logs (CloudTrail 365 days, CloudWatch 90 days)
- ☐ Anomaly detection (GuardDuty)
- ☐ Compliance monitoring (Security Hub, Config)
- ☐ Incident alerting (SNS to ISMS Lead)

**Resilience**:
- ☐ Multi-AZ deployment
- ☐ Automated backups (daily + weekly)
- ☐ Disaster recovery tested
- ☐ Business continuity plan

**Testing**:
- ☐ Security testing (penetration test annually)
- ☐ Vulnerability scanning (monthly)
- ☐ Backup restoration testing (quarterly)

### 5.2 Organizational Measures

**Policies and Procedures**:
- ☐ Data Protection Policy
- ☐ Access Control Policy
- ☐ Incident Management Policy
- ☐ Data breach procedures
- ☐ Data subject rights procedures

**Staff Training**:
- ☐ GDPR awareness training (annual)
- ☐ Secure handling training
- ☐ Incident reporting training
- ☐ Role-specific training (developers, support)

**Supplier Management**:
- ☐ Data Processing Agreements with processors
- ☐ Supplier security assessments
- ☐ AWS DPA in place

**Governance**:
- ☐ DPO appointed (Akam Rahimi)
- ☐ Data protection responsibilities assigned
- ☐ Regular reviews and audits
- ☐ Continuous improvement process

### 5.3 Residual Risk Assessment

**After implementing measures, is residual risk**:
- ☐ **High** - Requires ICO consultation before proceeding
- ☐ **Medium** - Acceptable with ongoing monitoring
- ☐ **Low** - Well-managed; standard oversight sufficient

**If High Residual Risk**: ICO consultation required (GDPR Article 36); do not proceed until ICO consulted

---

## Section 6: ICO Consultation (if required)

**ICO Consultation Required?** ☐ Yes ☐ No

**If YES** (high residual risk):

**ICO Notification Date**: ________________________________  
**Information Submitted to ICO**:
- DPIA (this document)
- Measures to address risks
- Safeguards, security measures, mechanisms in place
- Data Protection Officer contact

**ICO Advice Received Date**: ________________________________  
**ICO Reference**: ________________________________  
**ICO Recommendations**:

________________________________________________________________
________________________________________________________________

**ICO Recommendations Implemented?** ☐ Yes ☐ Partially ☐ No

**If NO or Partially, explain**:

________________________________________________________________

---

## Section 7: Sign-Off and Approval

### Data Protection Officer Assessment

**DPIA Summary**:
- Processing type: ________________________________________________________________
- Risk level: ☐ High ☐ Medium ☐ Low
- Measures adequate: ☐ Yes ☐ No ☐ With conditions
- ICO consultation: ☐ Required ☐ Not required

**DPO Recommendation**: ☐ Proceed ☐ Proceed with conditions ☐ Do not proceed ☐ Consult ICO

**Conditions** *(if any)*:

________________________________________________________________

**DPO Signature**: ________________________________  
**Name**: Akam Rahimi  
**Date**: ________________________________

### Managing Director Approval

**I approve this processing activity and accept any residual risks, subject to the measures and conditions outlined in this DPIA.**

**Signature**: ________________________________  
**Name**: Akam Rahimi  
**Position**: Managing Director  
**Date**: ________________________________

**Approval Status**: ☐ Approved ☐ Approved with Conditions ☐ Rejected

---

## Section 8: Review and Monitoring

**DPIA Valid Until**: ________________________________ *(Annual review or when processing changes)*

**Next Review Date**: ________________________________

**Review Triggers** *(Re-assess if any occur)*:
- ☐ Significant change to processing
- ☐ New technology implemented
- ☐ Data breach or security incident
- ☐ Regulatory guidance changes
- ☐ Complaints from data subjects
- ☐ Audit findings

**Monitoring Plan**:

________________________________________________________________
________________________________________________________________

**Ongoing Compliance Checks**:
- ☐ Quarterly data minimization review
- ☐ Access log reviews (monthly)
- ☐ Security testing (annual penetration test)
- ☐ Data subject rights request tracking
- ☐ Incident monitoring (any data breaches?)

---

## Section 9: Integration with Information Security

**ISMS Risk Assessment** *(Link to risk register)*: RISK-YYYY-NNN (if applicable)

**Security controls aligned with DPIA**:
- ☐ Encryption (Cryptography Policy)
- ☐ Access controls (Access Control Policy)
- ☐ Monitoring (Security Monitoring Policy)
- ☐ Incident response (Incident Management Policy)
- ☐ Backup and recovery (Business Continuity Policy)

**ISO 27001 Controls Applied**: ________________________________________________________________

---

## Appendices

### Appendix A: Data Flow Diagram
*(Attach diagram showing how personal data flows through systems)*

### Appendix B: Data Processing Record
*(Link to Article 30 record in data processing register)*

### Appendix C: Consultation Outcomes
*(If data subjects or relevant stakeholders consulted)*

### Appendix D: Supporting Evidence
*(Risk assessments, security test results, supplier DPAs, etc.)*

---

**File Location**: /policies/dpias/DPIA-YYYY-NNN.pdf  
**Retention**: Duration of processing + 3 years  
**Confidentiality**: CONFIDENTIAL - DPO and Senior Management Only

---

**For questions about this DPIA, contact**:  
Akam Rahimi, Data Protection Officer  
Email: akam@epact.co.uk  
Phone: [TO BE COMPLETED]

