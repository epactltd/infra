# Data Protection and Privacy Policy

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
| **Owner** | Akam Rahimi, Data Protection Officer & ISMS Lead |
| **Contact** | akam@epact.co.uk |
| **ISO 27001 Reference** | A.5.33, A.5.34, A.8.10, A.8.11, A.8.12 |
| **GDPR Reference** | Articles 5, 6, 13, 14, 15-22, 32-34 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy establishes EPACT LTD's commitment to protecting personal data and ensuring compliance with data protection legislation, including the UK General Data Protection Regulation (UK GDPR) and Data Protection Act 2018.

### 1.2 Scope
This policy applies to:
- All personal data processed by EPACT LTD (customers, employees, tenants, suppliers)
- Both automated and manual processing
- Personal data in any format (digital, paper, audio)
- All EPACT employees, contractors, and third parties processing personal data
- Multi-tenant SaaS platform and associated systems
- Data stored in AWS eu-west-2 region

### 1.3 Data Protection Officer (DPO)
**Name**: Akam Rahimi  
**Position**: Managing Director & ISMS Lead  
**Contact**: akam@epact.co.uk  
**Address**: International House, 36-38 Cornhill, London, England, EC3V 3NG  
**Responsibilities**: Oversee GDPR compliance, advise on data protection, cooperate with ICO, act as contact point

---

## 2. Data Protection Principles

EPACT processes all personal data in accordance with GDPR Article 5 principles:

### 2.1 Lawfulness, Fairness, and Transparency
- **Lawful basis** identified for all processing (Article 6)
- **Transparent** about data collection and use (privacy notices)
- **Fair processing**: No deceptive or unexpected uses

### 2.2 Purpose Limitation
- Personal data collected for **specified, explicit, and legitimate purposes**
- Not further processed in manner incompatible with purposes
- Documented purposes in data processing register

### 2.3 Data Minimisation
- Only collect personal data **adequate, relevant, and limited** to what is necessary
- Regular reviews to identify and delete unnecessary data
- Application design minimizes personal data collection

### 2.4 Accuracy
- Personal data kept **accurate and up to date**
- Inaccurate data rectified or erased without delay
- Customers can update their own data via platform
- Data quality checks implemented

### 2.5 Storage Limitation
- Personal data kept no longer than necessary for purposes
- **Retention schedules** defined per data type (see Section 8)
- Automated deletion where feasible
- Review and deletion procedures

### 2.6 Integrity and Confidentiality (Security)
- **Technical and organizational measures** to protect data:
  - Encryption at rest (AWS KMS)
  - Encryption in transit (TLS 1.2+)
  - Access controls (IAM, MFA, least privilege)
  - Multi-tenant isolation (per-tenant S3 buckets)
  - Security monitoring (GuardDuty, CloudTrail)
  - Regular security testing

### 2.7 Accountability
- **Demonstrate compliance** through documentation
- Data Protection Impact Assessments (DPIAs) for high-risk processing
- Records of processing activities (Article 30)
- Data protection policies and procedures
- Training records
- Audit trails (CloudTrail, CloudWatch logs)

---

## 3. Lawful Bases for Processing

### 3.1 GDPR Article 6 Lawful Bases

EPACT processes personal data under the following lawful bases:

#### 3.1.1 Contract (Article 6(1)(b))
**Processing necessary** for performance of contract with data subject

**Examples**:
- Customer account creation and management
- Service delivery to tenants
- Billing and payment processing
- Customer support and communications

**Data Types**: Name, email, company name, billing address, usage data

#### 3.1.2 Legitimate Interests (Article 6(1)(f))
**Processing necessary** for legitimate interests (balancing test conducted)

**Examples**:
- Fraud prevention and security monitoring
- System and network security (GuardDuty, CloudTrail logging)
- Direct marketing to existing customers (with opt-out)
- Analytics for service improvement

**Balancing Test**: Documented for each legitimate interest use case

#### 3.1.3 Legal Obligation (Article 6(1)(c))
**Processing necessary** to comply with legal obligation

**Examples**:
- Tax records retention (HMRC requirements)
- Financial record keeping (Companies Act)
- Regulatory compliance reporting
- Court orders and law enforcement requests

#### 3.1.4 Consent (Article 6(1)(a))
**Freely given, specific, informed, and unambiguous** consent

**Examples**:
- Marketing communications to prospects
- Non-essential cookies
- Sharing data with third parties for non-service purposes

**Requirements**:
- Clear consent request (pre-ticked boxes prohibited)
- Easy to withdraw consent
- Consent records maintained
- Consent reviewed annually

### 3.2 Special Category Data
EPACT **does not intentionally process** special category data (Article 9):
- Racial or ethnic origin
- Political opinions
- Religious or philosophical beliefs
- Trade union membership
- Genetic or biometric data
- Health data
- Sex life or sexual orientation

**If special category data discovered**:
- Assess legal basis (explicit consent, legal claims, etc.)
- Conduct DPIA before processing
- Implement additional safeguards
- Notify DPO immediately

---

## 4. Data Subject Rights

EPACT respects and facilitates the following data subject rights:

### 4.1 Right to Be Informed (Articles 13-14)
- **Privacy notices** provided at point of data collection
- Clear information about processing purposes, lawful basis, retention, rights
- Privacy policy available on website
- Updates communicated to data subjects

### 4.2 Right of Access (Article 15)
- **Subject Access Requests (SARs)** responded to within **1 month**
- Free of charge (unless manifestly unfounded or excessive)
- Provide copy of personal data and supplementary information
- Verify identity before disclosure

**Procedure**:
1. Request received by DPO (akam@epact.co.uk)
2. Verify identity (government ID or account authentication)
3. Search all systems (RDS database, S3 buckets, application logs, CloudTrail)
4. Compile personal data
5. Redact third-party personal data
6. Provide in commonly used electronic format
7. Log SAR in data subject rights register

### 4.3 Right to Rectification (Article 16)
- Inaccurate personal data corrected without undue delay
- Incomplete data completed
- Self-service rectification via customer portal (where feasible)
- Third parties notified if data shared

### 4.4 Right to Erasure / "Right to Be Forgotten" (Article 17)
**Grounds for erasure**:
- Data no longer necessary for purposes
- Consent withdrawn (and no other lawful basis)
- Objection to processing (and no overriding legitimate grounds)
- Data processed unlawfully
- Legal obligation to erase

**Exceptions** (erasure not required):
- Legal obligation to retain (tax records, audit trails)
- Legal claims or exercise/defense of legal claims
- Public interest or official authority tasks

**Procedure**:
1. Request reviewed by DPO within 5 business days
2. Assess grounds and exceptions
3. If approved:
   - Delete data from RDS database
   - Delete tenant S3 bucket and all versions
   - Delete backup recovery points (AWS Backup) where feasible
   - Anonymize CloudTrail logs (retain for audit but pseudonymize PII)
   - Confirm deletion to data subject
4. Document decision and actions in rights register

**Technical Implementation**:
- Tenant data deletion script (removes database records, S3 bucket, tags)
- Retention of anonymized metadata for legal/audit purposes
- Backup handling (ensure backups eventually expire per retention policy)

### 4.5 Right to Restrict Processing (Article 18)
- Suspend processing while verifying accuracy or assessing objection
- Mark data as "restricted" in database
- Processing only with consent or for legal claims
- Notify data subject before lifting restriction

### 4.6 Right to Data Portability (Article 20)
- Provide personal data in **structured, commonly used, machine-readable format** (JSON or CSV)
- Applies to data provided by data subject and processed by automated means
- Transmit directly to another controller if technically feasible
- Timeline: Within 1 month

**Implementation**:
- Export tenant data via API or admin function
- Format: JSON export of database records
- Includes: Account data, usage data, stored documents
- Excludes: Derived data, inferred data, other tenants' data

### 4.7 Right to Object (Article 21)
- Right to object to processing based on legitimate interests or direct marketing
- EPACT must stop processing unless compelling legitimate grounds override
- Absolute right to object to direct marketing

**Procedure**:
1. Objection logged with DPO
2. Assessment of grounds (within 5 business days)
3. Cease processing or demonstrate compelling grounds
4. Direct marketing objections: Immediate opt-out

### 4.8 Rights Response Timelines
- **Standard response**: Within 1 month of request
- **Extension**: Up to 2 additional months if complex/numerous requests (with notification)
- **Free of charge**: Unless manifestly unfounded or excessive
- **Identity verification**: Required before fulfilling requests
- **Refusal**: Must be justified and communicated with right to complain to ICO

---

## 5. Privacy by Design and by Default

### 5.1 Privacy by Design Principles
Security and privacy designed into systems from inception:

#### 5.1.1 Proactive not Reactive
- Privacy impact assessments before new processing
- Security controls built into architecture
- Risk assessments during design phase

#### 5.1.2 Privacy as Default Setting
- Highest privacy settings by default
- Data minimization in default configuration
- Opt-in rather than opt-out
- Clear privacy controls for users

#### 5.1.3 Privacy Embedded into Design
- Integral part of system functionality
- Not bolted on as afterthought
- Terraform infrastructure includes security from start (encryption, isolation, monitoring)

#### 5.1.4 Full Functionality (Positive-Sum)
- Privacy doesn't compromise functionality
- Security enhances trust and service quality
- Multi-tenant isolation enables better service

#### 5.1.5 End-to-End Security
- Data protected throughout lifecycle (collection → storage → processing → deletion)
- Encryption at rest and in transit
- Secure backups with retention limits
- Secure deletion procedures

#### 5.1.6 Visibility and Transparency
- Clear privacy notices
- Audit logs for accountability
- Customer-accessible activity logs
- Regular privacy reporting

#### 5.1.7 Respect for User Privacy
- User-centric design
- Easy-to-use privacy controls
- Clear communication
- Respect for data subject rights

### 5.2 Privacy by Default (Article 25(2))
- Only necessary personal data processed by default
- Automatic expiry of data after retention period
- Access restricted to minimum necessary
- Data not shared with third parties without consent (except service provision)

---

## 6. Data Processing Register (Article 30)

### 6.1 Records of Processing Activities
EPACT maintains comprehensive records containing:

#### 6.1.1 Controller Information
- Name and contact details: EPACT LTD, International House, 36-38 Cornhill, London
- Data Protection Officer: Akam Rahimi, akam@epact.co.uk

#### 6.1.2 Processing Purposes
| **Purpose** | **Lawful Basis** | **Data Categories** | **Data Subjects** |
|------------|-----------------|-------------------|------------------|
| Customer account management | Contract | Name, email, company, billing details | Customers (B2B) |
| Service delivery (multi-tenant platform) | Contract | Tenant data, usage logs, application data | End users of customer tenants |
| Security monitoring and incident response | Legitimate interests | IP addresses, access logs, CloudTrail logs | All users and customers |
| Billing and invoicing | Contract + Legal obligation | Company details, billing address, payment records | Customers |
| Marketing communications | Consent | Email address, company name, communication preferences | Prospects and customers |
| Employee administration | Contract + Legal obligation | Name, contact details, payroll data, NI number | Employees |

#### 6.1.3 Data Recipients
- **Internal**: Development team, Support team (role-based access only)
- **External**:
  - AWS (data processor - infrastructure provider)
  - Payment processors (if applicable)
  - Email service providers (if applicable)
  - Auditors (confidential basis)

#### 6.1.4 International Transfers
- **Primary location**: UK / EU (AWS eu-west-2 London region)
- **No routine transfers**: Data not transferred outside UK/EU
- **AWS global services**: If used (CloudFront, Route53), ensure adequacy decision or safeguards (Standard Contractual Clauses with AWS)

#### 6.1.5 Retention Periods
See Section 8 (Data Retention Schedule)

#### 6.1.6 Technical and Organizational Measures
See Section 9 (Security Measures)

### 6.2 Register Maintenance
- **Owner**: Data Protection Officer (Akam Rahimi)
- **Format**: Spreadsheet or data protection management tool
- **Updates**: When new processing activities commence or change
- **Review**: Annually
- **Access**: Available to ICO upon request

---

## 7. Privacy Notices and Transparency

### 7.1 Privacy Notice Requirements
EPACT provides clear privacy notices containing (Articles 13-14):
- Identity and contact details of controller (EPACT LTD)
- Contact details of Data Protection Officer (akam@epact.co.uk)
- Purposes of processing and lawful basis
- Legitimate interests (if applicable basis)
- Categories of personal data
- Recipients or categories of recipients
- Retention period or criteria
- Data subject rights
- Right to withdraw consent (if applicable)
- Right to lodge complaint with ICO
- Whether provision is statutory/contractual requirement
- Existence of automated decision-making (if any)

### 7.2 Privacy Notice Locations
- **Website**: Privacy Policy page (publicly accessible)
- **Application**: During account registration and in settings
- **Contracts**: Referenced in customer agreements
- **Forms**: On data collection forms
- **Employee handbook**: For employee data processing

### 7.3 Updates to Privacy Notices
- Material changes communicated to affected data subjects
- Consent re-obtained if basis of processing changes
- Version history maintained
- "Last updated" date displayed

---

## 8. Data Retention Schedule

### 8.1 Customer and Tenant Data

| **Data Type** | **Retention Period** | **Lawful Basis** | **Deletion Method** |
|--------------|---------------------|------------------|---------------------|
| Active customer account data | Duration of contract + 6 months | Contract | Secure deletion from RDS and S3 |
| Tenant application data | Duration of tenant subscription + 30 days | Contract | S3 bucket deletion (all versions) |
| Billing and invoicing records | 7 years | Legal obligation (HMRC) | Secure archival then deletion |
| Customer support communications | 3 years | Legitimate interests | Email and ticket deletion |
| Usage and analytics data | 2 years | Legitimate interests | Aggregated after 90 days; pseudonymized |
| Marketing communications | Until consent withdrawn + 30 days | Consent | Unsubscribe and delete from mailing lists |

### 8.2 Employee Data

| **Data Type** | **Retention Period** | **Lawful Basis** | **Deletion Method** |
|--------------|---------------------|------------------|---------------------|
| Employee HR records | Duration of employment + 6 years | Contract + Legal obligation | Secure deletion from HR system |
| Payroll records | 6 years after end of tax year | Legal obligation (HMRC) | Secure archival then deletion |
| Recruitment records (unsuccessful) | 6 months after recruitment process | Legitimate interests + Consent | Secure deletion from recruitment system |
| Training records | Duration of employment + 3 years | Legitimate interests | Deletion from training management system |
| Security access logs | 90 days (operational); 7 years (audit trails) | Legitimate interests + Legal obligation | CloudWatch/CloudTrail retention policies |

### 8.3 System and Audit Logs

| **Log Type** | **Retention Period** | **Purpose** | **Location** |
|-------------|---------------------|------------|-------------|
| CloudTrail audit logs | 365 days | Security and compliance | S3 with lifecycle policy |
| CloudWatch application logs | 90 days | Operations and troubleshooting | CloudWatch Logs |
| VPC Flow Logs | 365 days (30d→IA→90d→Glacier) | Network security monitoring | S3 with lifecycle policy |
| ALB access logs | 365 days (30d→IA→90d→Glacier) | Security and performance | S3 with lifecycle policy |
| RDS slow query logs | 30 days | Performance optimization | CloudWatch Logs |
| GuardDuty findings | 90 days (active); indefinite (archived) | Threat detection | Security Hub |

### 8.4 Automated Deletion
- S3 lifecycle policies enforce retention limits (see above)
- CloudWatch log expiration configured (90 days)
- Database cleanup scripts run monthly (delete expired records)
- Manual review quarterly to identify data for deletion

---

## 9. Security Measures (Article 32)

### 9.1 Technical Measures

#### 9.1.1 Encryption
- **At rest**: AWS KMS encryption for S3, RDS, EBS, SNS, CloudWatch Logs
- **In transit**: TLS 1.2+ for all connections (ALB, API, RDS)
- **Key management**: Customer-managed KMS keys; 30-day deletion window; annual rotation
- **Enforcement**: S3 bucket policies deny non-TLS access

#### 9.1.2 Access Controls
- **Authentication**: Multi-factor authentication (MFA) for all AWS and application access
- **Authorization**: IAM least privilege policies; role-based access control (RBAC)
- **Network isolation**: VPC private subnets; security groups; WAF
- **Tenant isolation**: Per-tenant S3 buckets; database row-level security by tenant_id

#### 9.1.3 Monitoring and Detection
- **AWS GuardDuty**: Real-time threat detection (S3, EC2, IAM)
- **AWS Security Hub**: Compliance monitoring (CIS Benchmark, PCI DSS)
- **CloudTrail**: Audit logging (all API calls logged for 365 days)
- **CloudWatch Alarms**: Anomaly detection (failed logins, unusual access patterns)
- **VPC Flow Logs**: Network traffic monitoring

#### 9.1.4 Availability and Resilience
- **Multi-AZ deployment**: RDS, EC2 Auto Scaling Group, NAT Gateways
- **Automated backups**: Daily (30-day retention) and weekly (365-day retention)
- **Auto Scaling**: Handles load spikes and instance failures
- **Health checks**: ALB monitors instance health; automatic failover
- **Disaster recovery**: Tested annually (see disaster-recovery-test.md)

#### 9.1.5 Secure Development
- **Infrastructure-as-Code**: Terraform with peer review and version control
- **Secure coding**: OWASP Top 10 awareness; input validation; parameterized queries
- **Dependency scanning**: Automated checks for vulnerable libraries
- **Security testing**: Annual penetration testing; regular vulnerability scans

### 9.2 Organizational Measures

#### 9.2.1 Staff Training
- **GDPR awareness**: Annual training for all staff
- **Data protection responsibilities**: Role-specific training
- **Secure handling**: Classification and handling procedures
- **Incident reporting**: How to recognize and report data breaches

#### 9.2.2 Access Management
- **Least privilege**: Access granted on need-to-know basis
- **Access reviews**: Quarterly recertification
- **Joiners/Leavers**: Documented procedures (see Access Control Policy)
- **Segregation of duties**: Critical operations require dual authorization

#### 9.2.3 Supplier Management
- **Data Processor Agreements** (DPAs) with all processors
- **AWS**: Standard AWS DPA accepted
- **Third-party services**: Security assessment before engagement
- **Supplier audits**: Annual reviews for critical processors

#### 9.2.4 Policies and Procedures
- Comprehensive security policies (20+ policies)
- Documented procedures for data handling
- Incident response procedures
- Business continuity and disaster recovery plans

---

## 10. Data Processing Agreements (DPAs)

### 10.1 EPACT as Data Controller
When EPACT processes customer personal data, customers are data subjects and EPACT is the controller.

**Responsibilities**:
- Determine purposes and means of processing
- Ensure lawful basis for processing
- Provide privacy notices
- Facilitate data subject rights
- Report data breaches to ICO if required

### 10.2 EPACT as Data Processor
When processing personal data on behalf of customers (tenants store end-user data in our platform), EPACT acts as processor and customer acts as controller.

**Processor Obligations** (Article 28):
- Process only on documented instructions from controller (customer)
- Ensure processing personnel under confidentiality obligations
- Implement appropriate security measures (see Section 9)
- Engage sub-processors only with controller consent
- Assist controller with data subject rights requests
- Assist with DPIAs and consultations with ICO
- Delete or return data at end of services (as directed by controller)
- Make available information to demonstrate compliance

**Standard DPA**:
- Included in customer Terms of Service
- Specifies subject matter, duration, nature, purpose of processing
- Lists sub-processors (AWS and any others)
- Details security measures implemented
- Audit rights for customers

### 10.3 Sub-Processors
**Primary Sub-Processor**: Amazon Web Services (AWS)
- **Service**: Cloud infrastructure (compute, storage, database, security)
- **Location**: eu-west-2 (London, UK)
- **Safeguards**: AWS Data Processing Addendum (DPA); ISO 27001, SOC 2 certified
- **Purpose**: Host and operate multi-tenant platform

**Additional Sub-Processors**:
[To be added as engaged]

**Change Notification**:
- Customers notified of new sub-processors
- 30-day notice period for objections
- Alternative solutions offered if customer objects

---

## 11. Data Protection Impact Assessments (DPIAs)

### 11.1 When DPIA Required (Article 35)
**Mandatory** for processing likely to result in high risk, including:
- Systematic and extensive automated decision-making with legal/significant effects
- Large-scale processing of special category data
- Systematic monitoring of publicly accessible areas (CCTV)
- New technologies or processing methods
- Processing that may prevent data subjects from exercising rights

**EPACT Specific Triggers**:
- New tenant data processing activities
- Significant changes to multi-tenant platform
- Implementation of AI/ML features
- New third-party integrations processing personal data

### 11.2 DPIA Process
**Steps**:
1. **Describe processing**: Nature, scope, context, purposes
2. **Assess necessity and proportionality**: Lawful basis, data minimization, retention
3. **Identify risks**: To data subject rights and freedoms
4. **Identify measures**: Controls to address risks
5. **Consult stakeholders**: DPO, security team, affected data subjects if appropriate
6. **Document outcomes**: DPIA report with risk assessment
7. **Review and approve**: Managing Director approval
8. **Consult ICO**: If high residual risk cannot be mitigated

**DPIA Template**: Available from DPO

### 11.3 DPIA Review
- Reviewed when processing changes significantly
- Re-assessed if new risks emerge
- Monitored for effectiveness of measures
- Updated annually minimum

---

## 12. Data Breach Management

### 12.1 Data Breach Definition
Any incident involving:
- Unauthorized or accidental access to personal data
- Unauthorized or accidental disclosure of personal data
- Unauthorized or accidental alteration of personal data
- Accidental or unlawful destruction or loss of personal data

### 12.2 Breach Detection
**Detection Sources**:
- AWS GuardDuty alerts (S3 data exfiltration, credential compromise)
- CloudWatch alarms (unusual access patterns)
- Security Hub findings
- Employee or customer reports
- Penetration test findings
- Third-party notifications

### 12.3 Breach Assessment (Within 24 Hours)
**DPO assesses**:
1. **Is it a personal data breach?** (Yes/No)
2. **What personal data affected?** (Categories: names, emails, financial, health, etc.)
3. **How many individuals?** (Approximate number)
4. **How did breach occur?** (Root cause)
5. **Is data encrypted?** (KMS keys compromised?)
6. **What is likelihood of harm?** (Low/Medium/High)
7. **ICO notification required?** (Yes/No/Uncertain)
8. **Individual notification required?** (If high risk to individuals)

**Assessment Form**: Completed and signed by DPO

### 12.4 ICO Notification (Within 72 Hours)
**Report to ICO if**:
- Breach likely to result in risk to individuals' rights and freedoms
- Uncertainty whether risk exists (report to be safe)

**Exceptions** (no notification required):
- Appropriate technical measures render data unintelligible (e.g., encrypted with keys not compromised)
- Subsequent measures ensure high risk unlikely
- Disproportionate effort (may use public communication instead)

**Notification Content**:
- Nature of breach (how it occurred)
- Categories and approximate number of data subjects
- Categories and approximate number of records
- Contact details of DPO
- Likely consequences
- Measures taken or proposed
- Measures to mitigate adverse effects

**Submission**: ICO online reporting tool (https://ico.org.uk/for-organisations/report-a-breach/)

**Phased Notification**: If information not available within 72 hours, provide initial notification then follow-up

### 12.5 Data Subject Notification (Without Undue Delay)
**Notify individuals if**:
- Breach likely to result in **high risk** to rights and freedoms
- Examples: Financial fraud risk, identity theft risk, discrimination risk, reputational damage

**Notification Content**:
- Description of breach (clear, plain language)
- Contact details of DPO (akam@epact.co.uk)
- Likely consequences
- Measures taken to address breach
- Measures to mitigate adverse effects
- **Recommendations for individuals**: E.g., change passwords, monitor accounts, credit monitoring

**Exceptions**:
- Technical protection measures applied (encryption with uncompromised keys)
- Subsequent measures ensure high risk no longer likely
- Disproportionate effort (public communication instead)

### 12.6 Breach Register
**All breaches logged**, including:
- Breach ID (BR-YYYY-NNN)
- Date and time detected
- Description of breach
- Data affected (categories and approximate numbers)
- Root cause
- Containment actions
- ICO notification (Yes/No, date if yes)
- Individual notification (Yes/No, date if yes)
- Measures to prevent recurrence
- Status (Open, Closed)

**Review**: DPO reviews breach register quarterly with Managing Director

---

## 13. International Data Transfers

### 13.1 Transfer Restrictions
- **Default position**: Personal data stays in UK/EU (AWS eu-west-2)
- **No routine transfers** to third countries or international organizations

### 13.2 If Transfer Required
**Safeguards** (in order of preference):
1. **Adequacy decision**: EU Commission adequacy decision for destination country
2. **Standard Contractual Clauses (SCCs)**: EU-approved SCCs with data importer
3. **Binding Corporate Rules**: If transfer within corporate group
4. **Derogations**: Only for specific situations (Article 49)

**Assessment Required**:
- Transfer Impact Assessment (TIA)
- DPO approval
- Customer notification if processing customer data
- Documentation in processing register

### 13.3 AWS Cross-Region Considerations
- **Primary region**: eu-west-2 (London, UK)
- **No cross-region replication**: Currently disabled
- **Future cross-region backups**: Will require assessment and safeguards
- **AWS global services**: Route53, CloudFront, IAM operate globally; AWS DPA provides safeguards

---

## 14. Data Minimization and Pseudonymization

### 14.1 Data Minimization Practices
- Collect only necessary personal data for stated purposes
- Application forms: Remove unnecessary fields
- Default settings: Minimize data sharing
- Regular audits: Identify and delete unnecessary data
- Data retention: Automatic expiry where feasible

**Implementation**:
- Database schema reviews (quarterly)
- Form field justification required
- Analytics use aggregated/anonymized data where possible
- User profiles: Optional fields clearly marked

### 14.2 Pseudonymization (Article 32)
**Definition**: Processing personal data so it can no longer be attributed to specific individual without additional information (kept separately)

**Use Cases**:
- Analytics and reporting: Use tenant IDs instead of customer names
- Development/testing: Pseudonymized production data copies
- Logging: User IDs instead of email addresses in application logs
- Research: Aggregated, pseudonymized data

**Benefits**:
- Reduces risk if data breached
- Enables broader use of data for legitimate purposes
- Easier to comply with data minimization

**Implementation**:
- Replace direct identifiers with pseudonyms (tenant_id, user_id)
- Store mapping separately with restricted access
- Use hashing (SHA-256) for one-way pseudonymization

### 14.3 Anonymization
**Complete anonymization**: Personal data transformed so individual no longer identifiable

**Use Cases**:
- Public reporting and statistics
- Long-term trend analysis
- Service improvement research

**Requirements**:
- Irreversible process
- Individual cannot be re-identified using reasonable means
- No longer subject to GDPR once truly anonymized

---

## 15. Multi-Tenant Data Isolation

### 15.1 Tenant Isolation Strategy
**Objective**: Ensure one tenant cannot access another tenant's data

**Technical Controls**:
1. **Application Layer**:
   - Every request validated for tenant_id
   - Database queries filtered by tenant_id (row-level security)
   - API authentication includes tenant claim (JWT)
   - Authorization checks tenant membership

2. **Database Layer**:
   - PostgreSQL/MySQL Row-Level Security (RLS) by tenant_id
   - Separate database schemas per tenant (if architecture supports)
   - Foreign key constraints prevent cross-tenant references

3. **Storage Layer**:
   - **Per-tenant S3 buckets**: `multi-tenant-app-tenant-{tenant_id}`
   - Bucket policies restrict access to tenant-specific IAM roles
   - Encryption with same KMS key (or per-tenant keys for higher isolation)
   - Versioning enabled for recovery from accidental deletion

4. **Network Layer**:
   - All tenants share same VPC (cost-efficient)
   - Application-level isolation (not network-level VPC-per-tenant)
   - Future consideration: VPC-per-tenant for high-security customers

### 15.2 Testing Tenant Isolation
- **Annual penetration testing**: Specifically test tenant isolation
- **Code reviews**: All tenant_id validation logic reviewed
- **Automated testing**: Unit and integration tests for authorization
- **Bug bounty**: Consider program rewarding security researchers

### 15.3 Tenant Data Deletion
**When tenant unsubscribes**:
1. Customer (controller) requests data deletion
2. Grace period: 30 days (configurable) for accidental cancellation recovery
3. After grace period:
   - Delete all tenant records from RDS database
   - Delete tenant S3 bucket (all versions)
   - Remove tenant from backups (or let backups expire per retention)
   - Delete CloudWatch Logs specific to tenant
   - Retain anonymized usage data for analytics (tenant_id hashed)
4. Confirmation sent to customer
5. Deletion logged in data processing register

---

## 16. Children's Data

### 16.1 Policy
EPACT's multi-tenant platform is **not intended for use by children** under 18.

**If children's data discovered**:
- Remove data immediately
- Notify parent/guardian if possible
- Review how data was collected
- Implement additional age verification if needed

### 16.2 Age Verification
- Terms of Service specify 18+ requirement
- Account registration includes age confirmation
- Customers responsible for ensuring their end users meet age requirements

---

## 17. Automated Decision-Making and Profiling

### 17.1 Current Use
EPACT **does not currently** use automated decision-making with legal or significant effects (Article 22).

**Partial Automation**:
- Auto Scaling based on metrics (operational, not personal data)
- Fraud detection rules (WAF rate limiting) - not solely automated

### 17.2 If Implemented in Future
**Requirements**:
- Explicit consent or contractual necessity
- Right to human intervention
- Right to contest decision
- Explanation of logic involved
- DPIA conducted
- Regular accuracy testing

---

## 18. Data Subject Rights Procedures

### 18.1 Rights Request Handling

**Receiving Requests**:
- Email to: akam@epact.co.uk
- Via customer portal (planned enhancement)
- In writing to company address
- Verbally (must be confirmed in writing)

**Identity Verification**:
- Government-issued ID (driving license, passport)
- Account authentication (username/password + MFA)
- Knowledge-based questions if ID unavailable
- Higher verification for sensitive rights (erasure)

**Timeline Tracking**:
- Log request receipt date
- Calculate 1-month deadline
- Set reminders at 7 days, 14 days, 28 days
- Communicate with data subject if extension needed

**Response**:
- Fulfill request or provide reasoned refusal
- Explain right to complain to ICO
- Document all actions in rights register

### 18.2 Common Scenarios

**Scenario 1: Customer Requests Access to Their Tenant Data**
1. Verify customer identity
2. Export tenant data from RDS (JSON format)
3. Export S3 bucket contents (zip file)
4. Provide metadata (creation date, last modified, data categories)
5. Redact any third-party personal data
6. Deliver via secure method (encrypted email or secure download link)

**Scenario 2: End User Requests Erasure**
1. Verify individual identity
2. Confirm customer (controller) approves deletion
3. Delete from customer's tenant database
4. Delete from S3 bucket if stored
5. Note: CloudTrail logs retained for audit (legitimate interests override)
6. Confirm deletion to individual

**Scenario 3: Marketing Opt-Out**
1. Immediate removal from mailing lists
2. Update preference in CRM
3. Confirm opt-out within 24 hours
4. Retain record of opt-out (legitimate interests for compliance)

---

## 19. Privacy Impact Considerations

### 19.1 High-Risk Processing Scenarios
**Require DPIA**:
- Storing health or biometric data (if future feature)
- Profiling or automated decision-making
- Large-scale monitoring (e.g., user behavior tracking)
- Processing vulnerable individuals' data (children, employees)
- Innovative use of technology (AI, machine learning)
- Cross-border data transfers to non-adequate countries

### 19.2 Consultation with ICO
**When required** (Article 36):
- DPIA indicates high residual risk
- Cannot identify sufficient measures to mitigate risk
- Before commencing high-risk processing

**Process**:
- Submit DPIA and supporting documentation to ICO
- Await ICO advice (up to 8 weeks; 14 weeks if complex)
- Implement ICO recommendations
- Do not commence processing until ICO consulted

---

## 20. Cookies and Tracking Technologies

### 20.1 Cookie Policy
**Essential Cookies** (no consent required):
- Session management
- Authentication tokens
- Load balancer routing (ALB session affinity)

**Non-Essential Cookies** (consent required):
- Analytics (Google Analytics, etc.)
- Marketing pixels
- Third-party integrations

**Cookie Banner**:
- Displayed on first visit
- Granular consent (category-by-category)
- Easy to withdraw consent
- Privacy policy link

### 20.2 Tracking and Analytics
- **Anonymize IP addresses**: Last octet removed
- **Respect Do Not Track**: Headers honored where feasible
- **Data retention**: Analytics data retained max 26 months
- **Third-party analytics**: DPA in place with provider

---

## 21. Employee Data Protection

### 21.1 Employee Privacy Notice
Provided at hiring and annually:
- What data collected (personal details, payroll, performance, access logs)
- Purposes (employment, legal compliance, security)
- Lawful bases (contract, legal obligation, legitimate interests)
- Recipients (HMRC, pension providers, IT support)
- Retention (6 years post-employment)
- Rights (access, rectification, objection)

### 21.2 Employee Monitoring
**Legitimate monitoring**:
- System access logs (CloudTrail, application logs)
- Email for security purposes (malware, phishing detection)
- Performance monitoring within reasonable bounds

**Employee Rights**:
- Informed of monitoring purposes
- Monitoring proportionate to purposes
- Privacy expectations balanced with business needs
- No covert monitoring without specific justification

---

## 22. Complaints and Requests for Information

### 22.1 Data Protection Complaints
**Internal Complaints**:
- Contact DPO: akam@epact.co.uk
- Response within 10 business days
- Investigation and resolution
- Escalation to Managing Director if unresolved

**External Complaints** (to ICO):
- Data subjects have right to lodge complaint with ICO
- ICO contact: https://ico.org.uk/ or 0303 123 1113
- EPACT cooperates fully with ICO investigations
- Opportunity to resolve complaints before ICO escalation

### 22.2 Freedom of Information Requests (if applicable)
- EPACT is private company (not public authority)
- FOI Act does not apply
- May receive requests; respond politely explaining not FOI authority
- If holding public authority data, forward to relevant authority

---

## 23. Compliance and Audit

### 23.1 Compliance Monitoring
- **Quarterly**: DPO reviews data protection compliance
- **Annually**: Comprehensive data protection audit
- **Ongoing**: AWS Config and Security Hub for technical compliance

### 23.2 Documentation for Auditors
- Data processing register (Article 30 records)
- DPIAs for high-risk processing
- Data protection policies and procedures
- Training records
- Breach register
- Data subject rights requests register
- DPAs with processors
- Consent records

---

## 24. Policy Review

This policy shall be reviewed:
- Annually by DPO
- After data breaches or significant incidents
- When GDPR guidance updated
- When processing activities change significantly
- When ICO provides new guidance

---

## 25. Related Documents

- Information Security Policy
- Access Control Policy
- Incident Management Policy
- Acceptable Use Policy
- Data Retention Schedule (Section 8)
- Privacy Notice (website)
- Data Processing Agreement (customer contracts)
- Employee Privacy Notice

---

## 26. Management Approval

**Approved by**:

**Name**: Akam Rahimi  
**Position**: Managing Director, ISMS Lead & Data Protection Officer  
**Signature**: ________________________________  
**Date**: ________________________________

---

## Revision History

| **Version** | **Date** | **Author** | **Description of Changes** | **Approved By** |
|------------|----------|------------|---------------------------|-----------------|
| 1.0 | [Date] | Akam Rahimi | Initial policy creation | Akam Rahimi |

---

**END OF POLICY**

**For data protection enquiries or to exercise your rights, contact**:  
Akam Rahimi, Data Protection Officer  
Email: akam@epact.co.uk  
Address: EPACT LTD, International House, 36-38 Cornhill, London, England, EC3V 3NG

