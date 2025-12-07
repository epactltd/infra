# Asset Management Policy

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
| **Owner** | Senior Developer |
| **Reviewer** | Akam Rahimi, ISMS Lead |
| **Contact** | akam@epact.co.uk |
| **ISO 27001 Reference** | A.5.9, A.5.10, A.5.11, A.5.12 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy ensures that information assets are identified, classified, inventoried, and protected according to their value and importance to EPACT LTD's business operations.

### 1.2 Scope
All information assets including:
- **Physical**: Servers, workstations, laptops, mobile devices, network equipment, paper documents
- **Digital**: Software, data, databases, source code, documentation
- **Cloud**: AWS resources (EC2, RDS, S3, Lambda, etc.)
- **Information**: Customer data, business data, intellectual property
- **Services**: AWS services, SaaS applications, managed services

---

## 2. Asset Inventory

### 2.1 Asset Register
EPACT maintains comprehensive asset inventory containing:
- **Asset ID**: Unique identifier
- **Asset name**: Descriptive name
- **Asset type**: Physical/digital/cloud/information/service
- **Classification**: Public/Internal/Confidential/Restricted
- **Owner**: Person responsible for asset
- **Custodian**: Person managing day-to-day operations
- **Location**: Physical location or AWS region/account
- **Status**: Active/Decommissioned/Archived
- **Value**: Replacement cost or business value
- **Last reviewed**: Date

### 2.2 AWS Cloud Asset Inventory

**Managed via Terraform and AWS Resource Tagging**:

| **Asset Type** | **Inventory Method** | **Owner** | **Criticality** |
|---------------|---------------------|----------|-----------------|
| VPC and subnets | Terraform state; AWS Resource Groups | Senior Developer | High |
| EC2 instances (ASG) | Auto Scaling Group tags; AWS Systems Manager | Senior Developer | High |
| RDS database | Terraform state; AWS console | Senior Developer | Critical |
| S3 buckets (tenant data) | AWS S3 inventory; tags | Senior Developer | Critical |
| Lambda functions | Terraform state; CloudWatch | Developer | Medium |
| IAM roles and policies | Terraform state; AWS IAM console | ISMS Lead | Critical |
| KMS keys | Terraform state; AWS KMS console | ISMS Lead | Critical |
| CloudWatch alarms | Terraform state | Support team | Medium |
| Backup vault | AWS Backup console | ISMS Lead | Critical |

**AWS Resource Tags** (mandatory):
```hcl
tags = {
  Environment = "prod"              # dev/staging/prod
  Project     = "multi-tenant-app"  # Project name
  ManagedBy   = "Terraform"         # How provisioned
  Compliance  = "ISO27001,ISO9001,GDPR"  # Compliance requirements
  Owner       = "senior.developer"  # Asset owner
  Backup      = "true"              # Include in backup plan
}
```

### 2.3 Physical Asset Inventory

| **Asset Type** | **Quantity** | **Location** | **Owner** |
|---------------|-------------|-------------|----------|
| Laptops (MacBooks) | [Number] | Remote offices | Managing Director (allocation) |
| Workstations | [Number] | Office/remote | Development team |
| Mobile phones | [Number] | Remote | Individual employees |
| Network equipment | [If applicable] | Office | ISMS Lead |
| Paper records | [File boxes] | Office secure storage | ISMS Lead |

**Physical Asset Register**: Maintained in spreadsheet with:
- Asset tag number (physical sticker on device)
- Serial number
- Assigned to (employee name)
- Issue date
- Return date (if applicable)
- Condition
- Encryption status

### 2.4 Software Asset Inventory

| **Software** | **Version** | **License Type** | **Expiry** | **Owner** |
|-------------|-----------|-----------------|----------|----------|
| Terraform | ≥1.5.0 | Open Source (MPL) | N/A | Senior Developer |
| AWS CLI | Latest | Open Source (Apache 2.0) | N/A | Development team |
| Operating Systems | [Specify] | Commercial | [Dates] | ISMS Lead |
| Development tools | [List] | Various | [Dates] | Development team |
| SaaS subscriptions | [List] | Subscription | [Renewal dates] | Managing Director |

---

## 3. Information Classification

### 3.1 Classification Scheme

#### 3.1.1 RESTRICTED
**Definition**: Highest sensitivity; unauthorized disclosure causes severe damage to EPACT or customers

**Examples**:
- Customer tenant databases (all tenant data)
- Encryption keys (KMS keys, AWS access keys)
- Authentication credentials (passwords, tokens, certificates)
- Personal data (GDPR-protected)
- Financial records (banking details, payment information)
- Trade secrets and proprietary algorithms
- Security vulnerability reports
- Audit reports and internal assessments

**Handling Requirements**:
- Encryption at rest (AWS KMS) and in transit (TLS 1.2+)
- Access: Need-to-know basis; MFA required; ISMS Lead approval
- Storage: AWS eu-west-2 only; encrypted S3 buckets or RDS
- Transmission: Encrypted channels only (TLS, VPN)
- Disposal: Secure deletion; verify removal; document in disposal log
- Labeling: Documents marked "RESTRICTED" in footer/header
- Logging: All access logged to CloudTrail (365-day retention)
- No email: Unless encrypted (PGP or secure file transfer)

#### 3.1.2 CONFIDENTIAL
**Definition**: Internal business information; unauthorized disclosure causes significant damage

**Examples**:
- Business plans and strategy documents
- Financial reports and projections
- Customer contracts and agreements
- Terraform source code and infrastructure design
- Application source code
- Internal project documentation
- Employee information (non-sensitive)
- Supplier agreements

**Handling Requirements**:
- Encryption in transit (TLS)
- Access: EPACT employees and authorized contractors only
- Storage: Company systems only (no personal devices)
- Transmission: Secure email or file sharing with access controls
- Disposal: Secure deletion or shredding
- Labeling: "CONFIDENTIAL" in footer/header
- External sharing: Requires NDA

#### 3.1.3 INTERNAL
**Definition**: General business information; unauthorized disclosure causes limited damage

**Examples**:
- Internal policies and procedures
- Meeting notes and minutes
- Internal announcements
- Training materials
- General project documentation
- Non-confidential email

**Handling Requirements**:
- Access: EPACT personnel only (no public access)
- Storage: Company systems preferred
- Transmission: Standard email acceptable within company
- Disposal: General recycling or delete
- External sharing: Case-by-case approval

#### 3.1.4 PUBLIC
**Definition**: Information approved for public disclosure

**Examples**:
- Marketing materials
- Public website content
- Press releases
- Published documentation (if applicable)
- Public social media posts

**Handling Requirements**:
- No special protection required
- Must be formally approved for publication
- Accuracy and brand compliance required

### 3.2 Classification Responsibility
- **Data Owner**: Determines classification at creation
- **Default classification**: INTERNAL (if unsure, classify higher)
- **Re-classification**: Allowed if justified; document change
- **Aggregation**: Multiple INTERNAL items together may become CONFIDENTIAL

### 3.3 Classification Marking

**Digital Documents**:
- Footer on every page: "Classification: [LEVEL] - EPACT LTD Confidential"
- Filename prefix: [RESTRICTED], [CONFIDENTIAL], [INTERNAL], [PUBLIC]
- Metadata tags: Document properties include classification

**Email**:
- Subject line prefix: [RESTRICTED], [CONFIDENTIAL] if applicable
- Email footer: "This email contains [classification] information"

**Physical Documents**:
- Header and footer on each page
- Cover sheet with classification
- Stored in locked cabinets if RESTRICTED/CONFIDENTIAL

**AWS Resources**:
- Tags: Classification = Restricted/Confidential/Internal
- Resource names: Avoid including sensitive info in names

---

## 4. Asset Ownership

### 4.1 Roles and Responsibilities

#### 4.1.1 Asset Owner
**Responsibilities**:
- Determine asset classification
- Approve access to asset
- Ensure appropriate security controls applied
- Review asset security quarterly
- Approve asset disposal
- Maintain asset documentation

**Asset Owners** (by type):
- **AWS Infrastructure**: Senior Developer
- **Customer/tenant data**: ISMS Lead (as Data Controller)
- **Application code**: Senior Developer
- **Physical devices**: Managing Director (allocation); ISMS Lead (security)
- **Policies and procedures**: ISMS Lead

#### 4.1.2 Asset Custodian
**Responsibilities**:
- Implement security controls defined by owner
- Perform day-to-day asset management
- Monitor asset health and performance
- Report issues to owner
- Execute backup and maintenance procedures

**Asset Custodians** (by type):
- **EC2/RDS**: Support team (monitoring); Development team (configuration)
- **S3 buckets**: Development team
- **Laptops**: Individual employees (self-custody)
- **Documentation**: Document creators

#### 4.1.3 Asset Users
**Responsibilities**:
- Use assets only for authorized business purposes
- Comply with classification handling requirements
- Report loss, theft, or suspected compromise immediately
- Return assets when no longer needed or upon termination

---

## 5. Acceptable Use of Assets

### 5.1 Authorized Use
**Information assets** used exclusively for:
- EPACT business purposes
- Approved personal use (reasonable, non-interfering)
- Professional development relevant to role
- Compliance with all policies

### 5.2 Prohibited Use
**Strictly prohibited**:
- Illegal activities
- Unauthorized disclosure of confidential information
- Copyright infringement or piracy
- Harassment, discrimination, or offensive content
- Personal commercial activities
- Crypto-currency mining
- Unauthorized software installation
- Bypassing security controls
- Sharing credentials
- Downloading malware or visiting malicious sites

**Violations**: Subject to disciplinary action (see Acceptable Use Policy for details)

### 5.3 Monitoring and Enforcement
- System usage monitored for policy compliance
- CloudTrail logs reviewed for unauthorized actions
- GuardDuty detects malicious activity
- Violations investigated and addressed
- Repeat violations escalated to Managing Director

---

## 6. Asset Lifecycle Management

### 6.1 Asset Acquisition

**Physical Assets**:
1. Business justification documented
2. Approval by Managing Director (budget)
3. Security requirements specified (encryption, compliance)
4. Procurement from approved suppliers
5. Receipt and asset tag assignment
6. Registration in asset register
7. Security configuration before use
8. Assignment to user with acknowledgment

**Cloud Resources**:
1. Business case and sizing justification
2. Terraform code developed and peer-reviewed
3. Security review by ISMS Lead
4. Deployment to development for testing
5. Approval for production deployment
6. Infrastructure deployed via Terraform
7. Tags applied and documentation updated
8. Monitoring configured (CloudWatch alarms)

**Software/SaaS**:
1. Business need identified
2. Security and privacy assessment
3. Budget approval
4. Licensing compliance verified
5. Subscription created
6. User training provided
7. Usage monitored for optimization

### 6.2 Asset Operation and Maintenance

**Physical Assets**:
- Regular maintenance (laptops: quarterly security updates)
- Hardware faults reported and repaired
- Asset location updated in register if moved
- Security settings maintained (encryption, password)

**Cloud Assets**:
- Monitored via CloudWatch and Security Hub
- Patched per vulnerability management schedule
- Resized based on capacity reviews
- Configuration managed via Terraform
- Backed up per backup policy

**Software**:
- Licensed appropriately for users
- Updated regularly for security patches
- Usage monitored for compliance
- Renewals tracked and timely

### 6.3 Asset Transfer

**Between Employees**:
1. Previous user de-assigns in asset register
2. Asset wiped or data removed (if necessary)
3. Asset re-assigned to new user
4. New user acknowledges receipt and acceptable use
5. Asset register updated

**Between Environments** (e.g., dev to staging):
1. Configuration reviewed for environment appropriateness
2. Sensitive data removed (production data not in dev)
3. Security settings verified
4. Documentation updated
5. Change management process followed

### 6.4 Asset Disposal

**Criteria for Disposal**:
- End of life (hardware obsolescence)
- No longer needed for business
- Replaced by newer asset
- Damaged beyond repair
- Security risk (compromised device)

**Disposal Process**:

**Step 1: Approval**
- Asset owner approves disposal
- ISMS Lead approval for RESTRICTED assets
- Managing Director approval for high-value assets (>£1000)

**Step 2: Data Sanitization**
- **RESTRICTED data**: Secure wipe (DoD 5220.22-M standard) or physical destruction
- **CONFIDENTIAL data**: Secure wipe or factory reset
- **Physical destruction**: Hard drive shredding for RESTRICTED
- **Verification**: Certificate of destruction obtained

**Step 3: Physical Disposal**
- **E-waste**: Use certified WEEE disposal service
- **Donation/resale**: Only after secure wipe; no RESTRICTED assets
- **Recycling**: Via approved vendor with certificate
- **Paper**: Shredding service for confidential documents

**Step 4: Documentation**
- Asset removed from register (status = "Disposed")
- Disposal date, method, and certificate filed
- Disposal log maintained for audit

**AWS Resource Disposal**:
- Terraform destroy (after approval)
- Final snapshots taken before deletion (retained per retention policy)
- S3 buckets: Empty all versions before deletion
- IAM users/roles: Disabled then deleted after 30 days
- KMS keys: Scheduled for deletion (30-day window)
- Documentation: Remove from infrastructure docs; retain in Git history

---

## 7. AWS Resource Tagging Standards

### 7.1 Mandatory Tags
**All AWS resources** must have:

```hcl
tags = {
  Environment  = "prod"                      # REQUIRED: dev/staging/prod
  Project      = "multi-tenant-app"          # REQUIRED: Project name
  Owner        = "senior.developer"          # REQUIRED: Asset owner
  ManagedBy    = "Terraform"                 # REQUIRED: Provisioning method
  CostCenter   = "engineering"               # REQUIRED: For cost allocation
  Compliance   = "ISO27001,ISO9001,GDPR"     # REQUIRED: Compliance frameworks
}
```

### 7.2 Optional Tags
```hcl
tags = {
  Name         = "multi-tenant-app-prod-alb"  # Descriptive name
  Backup       = "true"                       # Include in backup plan
  Classification = "Restricted"               # Data classification
  Description  = "Production application load balancer"
  Department   = "Technology"
  Application  = "multi-tenant-saas"
  Version      = "1.0"
  Tenant       = "tenant-12345"               # For tenant-specific resources
}
```

### 7.3 Tagging Enforcement
- **Terraform**: Default tags applied at provider level
- **AWS Config**: Rules detect untagged resources
- **Automated remediation**: Tagging Lambda function (future)
- **Monthly audit**: Identify and tag untagged resources
- **Cost allocation**: Accurate billing by project/environment/cost center

---

## 8. Information Asset Protection

### 8.1 Customer Tenant Data (RESTRICTED)
**Assets**:
- RDS MySQL database (tenant tables)
- Per-tenant S3 buckets (multi-tenant-app-tenant-*)
- Application data and documents
- Tenant configuration and metadata

**Protection Measures**:
- Encryption at rest (AWS KMS with customer-managed keys)
- Encryption in transit (TLS 1.2+)
- Multi-tenant isolation (per-tenant S3 buckets, database RLS)
- Access controls (IAM least privilege, MFA)
- Backup (daily 30-day + weekly 365-day retention)
- Monitoring (GuardDuty, CloudTrail, CloudWatch)
- Geographic restriction (eu-west-2 only; no cross-region replication)

### 8.2 Application Source Code (CONFIDENTIAL)
**Assets**:
- Git repository (GitHub/GitLab)
- Terraform infrastructure code
- Lambda function code (Python)
- Application code (Laravel/Nuxt)
- Configuration files

**Protection Measures**:
- Private repository (no public access)
- Access control (authenticated developers only)
- Branch protection (main branch requires PR and approval)
- Commit signing (GPG signatures for critical repos)
- No secrets in code (use AWS Secrets Manager, environment variables)
- Regular dependency scanning (Dependabot, Snyk)
- Backup (Git provider's backup + local clones)

### 8.3 Business Information (CONFIDENTIAL/INTERNAL)
**Assets**:
- Financial records
- Customer contracts
- Business strategy documents
- Employee records
- Operational documentation

**Protection Measures**:
- Stored on company-approved platforms (Google Workspace, OneDrive, etc.)
- Access controls (role-based)
- Encryption (at rest and in transit)
- Version control for critical documents
- Retention per document retention schedule
- Secure disposal (shredding for paper)

### 8.4 Cryptographic Assets (RESTRICTED)
**Assets**:
- AWS KMS keys (security, RDS, flow logs, state)
- TLS certificates (ACM)
- SSH keys (if used)
- API keys and tokens
- Terraform state files (contain sensitive outputs)

**Protection Measures**:
- KMS keys: 30-day deletion window, annual rotation, access logged
- Certificates: Auto-renewal (ACM), expiry monitoring
- API keys: 90-day rotation, stored in AWS Secrets Manager
- State files: S3 encryption with KMS, versioning, access restricted
- No keys in code or version control (use .gitignore)

---

## 9. Asset Classification Handling Requirements

### 9.1 RESTRICTED Data Handling

**Storage**:
- AWS S3 with KMS encryption + versioning + public access block
- AWS RDS with KMS encryption + Multi-AZ
- Encrypted EBS volumes only
- No local storage on laptops (cloud-only)

**Transmission**:
- TLS 1.2+ only (S3 bucket policies enforce)
- VPN for remote access to internal systems
- No email transmission (use secure file sharing with MFA)

**Access**:
- MFA mandatory
- Least privilege IAM policies
- CloudTrail logging
- Access requests approved by ISMS Lead
- Quarterly access reviews

**Disposal**:
- Secure deletion (all S3 versions)
- Database record deletion with verification
- KMS key deletion (30-day recovery window)
- Disposal logged and auditable

**Backups**:
- Encrypted backups in AWS Backup vault
- Backup access restricted (IAM policies)
- Retention: Daily 30-day, weekly 365-day

### 9.2 CONFIDENTIAL Data Handling

**Storage**:
- Company-approved systems (AWS, Google Workspace)
- Encryption recommended
- Access controls enforced

**Transmission**:
- Encrypted channels (HTTPS, VPN)
- Standard email acceptable within company
- External: Requires NDA or secure sharing

**Access**:
- EPACT employees and authorized contractors
- Authentication required
- Access logged

**Disposal**:
- Secure deletion (empty recycle bin)
- Paper shredding

### 9.3 INTERNAL Data Handling

**Storage**:
- Company systems
- Personal devices if needed (encrypted)

**Transmission**:
- Standard email acceptable
- External sharing: Case-by-case approval

**Access**:
- EPACT personnel
- Basic authentication

**Disposal**:
- Standard deletion
- Paper recycling

### 9.4 PUBLIC Data Handling

**Storage**: Any location

**Transmission**: No restrictions

**Access**: Public

**Disposal**: No special requirements

**Approval**: Must be formally approved for public release

---

## 10. Removable Media

### 10.1 Policy
Use of removable media (USB drives, external hard drives, CDs/DVDs) **discouraged**.

### 10.2 Authorized Use
**When necessary** (approved by ISMS Lead):
- Encrypted USB drives only (hardware-encrypted)
- Business justification documented
- Media registered in asset register
- Data classification limits (no RESTRICTED data on removable media)
- Secure disposal when no longer needed

### 10.3 Prohibited Actions
- Storing company data on personal USB drives
- Using untrusted USB devices on company systems
- Transferring RESTRICTED data via removable media
- Auto-run enabled for removable media

### 10.4 Lost or Stolen Media
- Report immediately to ISMS Lead
- Incident investigation
- Data breach assessment (if RESTRICTED/CONFIDENTIAL data)
- Remote wipe if capability exists
- Regulatory notification if personal data

---

## 11. Clear Desk and Clear Screen

### 11.1 Clear Desk Policy
**Requirements**:
- No confidential documents left on desk when unattended
- Lock documents in drawer or cabinet at end of day
- Shred confidential waste; do not leave in general trash
- Visitor access areas: Always clear desk

**Enforcement**:
- Periodic desk audits (quarterly)
- Violations addressed through management

### 11.2 Clear Screen Policy
**Requirements**:
- Lock screen when leaving workstation (Windows + L, Cmd + Ctrl + Q)
- Automatic screen lock: 5 minutes of inactivity
- Password-protected screen saver
- Privacy screens for laptops in public spaces

**Meetings and Shared Spaces**:
- No confidential information on whiteboards overnight
- Photograph whiteboards and erase after meetings
- Shared screens: Minimize visible confidential information

---

## 12. Return of Assets

### 12.1 Employee Termination
**Timeline**: All assets returned on last working day (or sooner)

**Assets to Return**:
- Laptop/workstation
- Mobile phone
- Security tokens (MFA devices)
- Access cards (if applicable)
- Company documents (paper and digital copies)
- Any other company property

**Process**:
1. Exit checklist completed by line manager
2. Assets returned to ISMS Lead or designated person
3. Physical inspection of asset condition
4. Data wiped (see disposal procedures)
5. Asset register updated (de-assigned)
6. Access revoked (AWS IAM, applications, physical access)
7. Confirmation signed by employee and ISMS Lead

### 12.2 Contractor End of Engagement
- Same process as employee termination
- Contract terms specify asset return requirements
- No final payment until assets returned
- Remote contractors: Return via courier (tracked and insured)

### 12.3 Non-Return Consequences
- Withhold final paycheck (if legally permissible)
- Invoice for replacement cost
- Police report for theft (if suspected)
- Legal action for recovery or damages

---

## 13. Cloud Asset Management (AWS-Specific)

### 13.1 Resource Naming Conventions
**Format**: `{project}-{resource-type}-{environment}-{purpose}`

**Examples**:
- `multi-tenant-app-alb-prod` (Application Load Balancer)
- `multi-tenant-app-db-prod` (RDS Database)
- `multi-tenant-app-tenant-12345` (Tenant S3 bucket)
- `multi-tenant-app-prod-backup-vault` (AWS Backup Vault)

**Benefits**:
- Easy identification in AWS console
- Cost allocation accuracy
- Automated policy application
- Clear ownership

### 13.2 Resource Lifecycle

**Creation**:
- Terraform code developed
- Peer reviewed
- Deployed to dev/staging for testing
- Change request for production deployment
- Terraform apply with approval
- Tags applied automatically
- Registered in asset inventory (Terraform state)

**Monitoring**:
- CloudWatch metrics and alarms
- AWS Config compliance checks
- Cost anomaly detection
- Utilization tracking

**Modification**:
- Via Terraform only (no console changes)
- Change management process
- Version controlled in Git

**Decommissioning**:
- Business justification (no longer needed)
- Final backups taken
- Terraform destroy (approved by ISMS Lead)
- Grace period for recovery (30 days for critical resources)
- Documentation archived
- Asset register updated

### 13.3 Orphaned Resource Detection
**Monthly Review**:
- Resources not in Terraform state (manually created)
- Resources without required tags
- Unused resources (idle EC2, empty S3 buckets)
- Detached EBS volumes
- Unused Elastic IPs

**Remediation**:
- Import into Terraform or document exception
- Add missing tags
- Delete unused resources (after approval)
- Investigate why resource orphaned

---

## 14. Intellectual Property

### 14.1 Company Intellectual Property
**EPACT owns**:
- All work product created by employees (employment contracts specify)
- Custom-developed software and source code
- Business processes and methodologies
- Customer lists and business intelligence
- Trademarks and branding

**Protection**:
- Confidential classification
- Access controls
- NDAs with employees, contractors, partners
- Copyright notices on source code
- Trade secret protection

### 14.2 Third-Party IP
**Respect for others' IP**:
- Use only licensed software
- Comply with open-source licenses
- Attribution where required
- No copyright infringement
- License compliance audits annually

### 14.3 Customer IP
- Customer owns their data and content
- EPACT does not claim ownership of tenant data
- Data Processing Agreement clarifies ownership
- Return or delete customer data upon contract termination

---

## 15. Information and Asset Handling Procedures

### 15.1 Printing
- Print only when necessary (digital preferred)
- Collect printouts immediately from printer
- Confidential printouts: Use secure/follow-me printing
- Disposal: Shred confidential documents

### 15.2 Copying/Scanning
- No scanning of confidential documents at public facilities
- Company scanner/copier only
- Digital copies classified same as original
- Dispose of originals securely after scanning

### 15.3 Transmission
**Internal** (within EPACT):
- Email, Slack, shared drives acceptable for CONFIDENTIAL and below
- RESTRICTED: Encrypted file sharing or AWS secure transfer

**External**:
- Email: CONFIDENTIAL or below with recipient verification
- RESTRICTED: Encrypted file sharing (password-protected, MFA)
- Large files: Secure file transfer service or temporary S3 presigned URLs
- Customer data: Via application API only (not email)

### 15.4 Storage
**Company-Approved Storage**:
- AWS S3 (for application and tenant data)
- Google Workspace (for business documents) [if applicable]
- Company file servers (if applicable)
- Git repository (for code)

**Prohibited Storage**:
- Personal email accounts (Gmail, Hotmail for company data)
- Personal cloud storage (Dropbox personal, iCloud personal)
- Unencrypted laptops
- USB drives (unless approved encrypted drives)

---

## 16. Asset Inventory Audits

### 16.1 Physical Asset Audits
**Frequency**: Annually

**Process**:
1. ISMS Lead distributes asset list to employees
2. Each employee verifies assets in their possession
3. Physical inspection of assets (asset tag verification)
4. Discrepancies investigated
5. Asset register updated
6. Missing assets reported; replacement or disciplinary action

### 16.2 Digital Asset Audits
**Frequency**: Quarterly

**Process**:
1. Terraform state exported (terraform state list)
2. AWS Resource Groups tag-based query
3. Compare against asset register
4. Identify discrepancies (missing tags, orphaned resources, undocumented)
5. Remediate issues
6. Update documentation

### 16.3 Software License Audits
**Frequency**: Annually

**Process**:
1. Inventory all installed software (via endpoint management or manual survey)
2. Compare against purchased licenses
3. Identify unlicensed software
4. Purchase additional licenses or remove software
5. Document compliance for audit

---

## 17. Information Asset Dependencies

### 17.1 Asset Dependency Mapping
**Critical asset dependencies documented**:

**Example**: RDS Database depends on:
- VPC and subnets
- Security group (db-sg)
- KMS key (rds_kms_key)
- Backup vault
- CloudWatch alarms
- Application tier (depends on it)

**Purpose**:
- Impact analysis for changes
- Disaster recovery planning
- Root cause analysis for incidents
- Capacity planning

### 17.2 Single Points of Failure
**Identified and mitigated**:
- RDS: Multi-AZ deployment
- EC2: Auto Scaling Group (minimum 2 instances)
- NAT Gateway: One per AZ (2 total)
- Terraform state: S3 versioning and replication (future)

**Accept or Mitigate**: Document decision in risk register

---

## 18. Asset Value Assessment

### 18.1 Valuation Criteria

**Financial Value**:
- Replacement cost for physical assets
- Licensing costs for software
- AWS resource costs (monthly spend)

**Business Value** (if asset lost/compromised):
- **Critical**: Business operations cease; customer impact severe
- **High**: Major business disruption; customer impact significant
- **Medium**: Moderate disruption; manageable with workarounds
- **Low**: Minimal impact; easily replaced

**Examples**:
- RDS database: **Critical** (all tenant data; business stops if lost)
- Terraform state: **Critical** (infrastructure cannot be managed)
- KMS keys: **Critical** (data inaccessible if lost)
- Individual EC2 instance: **Medium** (ASG replaces automatically)
- CloudWatch dashboard: **Low** (can be recreated)

### 18.2 Value-Based Protection
Higher-value assets receive stronger controls:
- Critical assets: Multi-AZ, encrypted, monitored, backed up daily and weekly
- High assets: Encrypted, monitored, backed up weekly
- Medium assets: Standard controls, backup optional
- Low assets: Minimal controls, no backup required

---

## 19. Documentation Assets

### 19.1 Technical Documentation
**Assets**:
- Infrastructure documentation (docs/*.md)
- Architecture diagrams (docs/diagrams/)
- Runbooks and procedures
- API documentation
- Code comments and README files

**Classification**: CONFIDENTIAL (contains architecture details)

**Storage**: Git repository (private)

**Access**: Development and Support teams

**Backup**: Git provider + local clones

**Review**: Updated with infrastructure changes; reviewed quarterly for accuracy

### 19.2 Policy and Procedure Documents
**Assets**: This policy and all other ISO 27001 policies

**Classification**: INTERNAL (policies); CONFIDENTIAL (detailed procedures)

**Storage**: policies/ directory in Git; management system

**Access**: All employees (policies); relevant roles (procedures)

**Versioning**: Version control in Git

**Review**: Annual minimum; after incidents or regulatory changes

---

## 20. Compliance and Audit

### 20.1 Audit Requirements
**Evidence for Auditors**:
- Asset register (current and historical)
- Asset classification decisions
- Disposal logs and certificates
- Tagging compliance reports (AWS Config)
- Asset audit findings and remediation
- Asset handling procedures

### 20.2 Asset-Related Compliance
- **GDPR**: Personal data inventory (part of asset register)
- **ISO 27001**: Asset accountability (A.5.9)
- **ISO 9001**: Quality records management
- **Financial compliance**: Asset depreciation records (accounting)

---

## 21. Related Documents

- Information Security Policy
- Data Protection and Privacy Policy
- Operations Security Policy
- Acceptable Use Policy
- Physical and Environmental Security Policy
- Asset Register (maintained separately; restricted access)
- Asset Disposal Log (maintained separately)

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
| 1.0 | [Date] | Senior Developer | Initial policy creation | Akam Rahimi |

---

**END OF POLICY**

