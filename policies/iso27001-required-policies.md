# ISO 27001 Required Company Policies

This document outlines the mandatory organizational policies required for ISO 27001:2022 compliance. These policies should be maintained separately from technical documentation and formally approved by executive management.

---

## 1. Information Security Policy (Master Policy)

**ISO 27001 Reference**: A.5.1, Clause 5.2

**Purpose**: Top-level statement of management commitment to information security

**Must Include**:
- Scope of the Information Security Management System (ISMS)
- Management commitment and leadership statement
- Organizational security objectives aligned with business strategy
- Legal, regulatory, and contractual compliance requirements (GDPR, ISO 9001, PCI DSS)
- Risk management approach and risk acceptance criteria
- Roles and responsibilities for information security
- Policy review and update schedule (at least annually)
- Consequences of policy violations

**Specific to Your Infrastructure**:
- AWS cloud infrastructure security scope (eu-west-2 region)
- Multi-tenant data isolation requirements
- Terraform Infrastructure-as-Code security controls
- Third-party service provider management (AWS services)

---

## 2. Access Control Policy

**ISO 27001 Reference**: A.5.15, A.5.18, A.8.2, A.8.3

**Purpose**: Define how users are granted, managed, and revoked access to systems and data

**Must Include**:
- User access provisioning and de-provisioning procedures
- Least privilege principle enforcement
- Role-Based Access Control (RBAC) methodology
- Multi-Factor Authentication (MFA) requirements
- Password complexity and rotation requirements
- Privileged access management (PAM) for administrative accounts
- Access review frequency (quarterly recommended)
- Remote access security requirements
- Segregation of duties requirements

**Specific to Your Infrastructure**:
- AWS IAM user and role management
- Terraform state access controls (S3 + DynamoDB locking)
- EC2 instance access via SSM Session Manager (no SSH keys)
- RDS database access controls
- Application-level tenant isolation
- CloudTrail audit logging for all access events

---

## 3. Asset Management Policy

**ISO 27001 Reference**: A.5.9, A.5.10

**Purpose**: Identify, classify, and protect organizational information assets

**Must Include**:
- Asset inventory maintenance procedures
- Information classification scheme (e.g., Public, Internal, Confidential, Restricted)
- Asset ownership and custodianship responsibilities
- Acceptable use guidelines for assets
- Asset labeling and handling requirements
- Asset disposal and destruction procedures
- Media handling and secure disposal

**Specific to Your Infrastructure**:
- AWS resource tagging standards (Environment, Project, ManagedBy, Compliance)
- Terraform-managed infrastructure inventory
- Customer tenant data classification (Restricted/Confidential)
- S3 bucket versioning and retention policies
- KMS key lifecycle management (30-day deletion windows)
- EBS volume encryption and secure deletion
- Backup vault asset protection

---

## 4. Human Resources Security Policy

**ISO 27001 Reference**: A.6.1, A.6.2, A.6.3, A.6.4

**Purpose**: Ensure personnel understand security responsibilities throughout employment lifecycle

**Must Include**:
- Pre-employment background screening requirements
- Security roles and responsibilities in job descriptions
- Confidentiality/Non-Disclosure Agreements (NDAs)
- Security awareness training requirements (annual minimum)
- Specialized training for privileged users (developers, ops, security)
- Disciplinary process for security violations
- Termination and role change procedures
- Contractor and third-party personnel security requirements

**Specific to Your Infrastructure**:
- AWS console access training
- Terraform code review and approval processes
- Secure coding practices for application development
- Incident response team roles
- On-call rotation security requirements

---

## 5. Physical and Environmental Security Policy

**ISO 27001 Reference**: A.7.1, A.7.2, A.7.3, A.7.4

**Purpose**: Protect physical facilities and equipment (including cloud infrastructure dependencies)

**Must Include**:
- Physical security perimeter controls
- Secure areas access controls (server rooms, offices)
- Equipment security and maintenance
- Clean desk and clear screen requirements
- Secure disposal of equipment
- Off-site equipment security
- Environmental controls (temperature, humidity, fire suppression)

**Specific to Your Infrastructure**:
- **AWS Shared Responsibility Model**: Physical security managed by AWS (SOC 2, ISO 27001 certified data centers)
- Office workspace security for remote development teams
- Secure disposal of laptops/workstations with access to production
- Protection of backup media and documentation
- Visiting personnel procedures

---

## 6. Operations Security Policy

**ISO 27001 Reference**: A.8.1, A.8.7, A.8.8, A.8.15, A.8.16, A.8.19

**Purpose**: Ensure correct and secure operation of information processing facilities

**Must Include**:
- Change management procedures
- Capacity management and performance monitoring
- Separation of development, test, and production environments
- Malware protection requirements
- Backup and restoration procedures
- Logging and monitoring requirements
- System and application hardening standards
- Vulnerability management and patching procedures
- Configuration management

**Specific to Your Infrastructure**:
- Terraform change management workflow (plan → review → apply)
- AWS Backup vault retention policies (daily 30d, weekly 365d)
- GuardDuty malware scanning (S3 + EBS)
- CloudWatch logging and 90-day retention
- Security Hub compliance monitoring (CIS Benchmark, PCI DSS)
- AMI patching and vulnerability scanning
- Infrastructure-as-Code version control (Git)
- WAF rule management and tuning
- KMS key rotation (annual)

---

## 7. Communications Security Policy

**ISO 27001 Reference**: A.8.20, A.8.21, A.8.22, A.8.23, A.8.24

**Purpose**: Protect information in networks and information systems

**Must Include**:
- Network segmentation and security zoning
- Network access controls
- Encryption requirements for data in transit
- Encryption requirements for data at rest
- Secure email and messaging requirements
- Secure file transfer procedures
- Network monitoring and intrusion detection
- Wireless network security

**Specific to Your Infrastructure**:
- VPC network isolation (10.0.0.0/16)
- Public/private subnet segregation
- Security group ingress/egress rules
- ALB TLS termination (ELBSecurityPolicy-TLS-1-2-2017-01)
- HTTP→HTTPS automatic redirect (301)
- RDS encryption at rest (KMS)
- S3 bucket encryption (KMS) and TLS-only policies
- VPC Flow Logs for network traffic monitoring
- WAF protection on ALB
- NAT Gateway for controlled egress

---

## 8. System Acquisition, Development, and Maintenance Policy

**ISO 27001 Reference**: A.8.25, A.8.26, A.8.27, A.8.28, A.8.29, A.8.30, A.8.31, A.8.32

**Purpose**: Ensure security is designed into systems throughout the lifecycle

**Must Include**:
- Secure development lifecycle (SDLC) requirements
- Security requirements analysis
- Secure coding standards
- Code review and testing procedures
- Vulnerability testing and security scanning
- Change control procedures
- Test data management and protection
- Supplier development oversight

**Specific to Your Infrastructure**:
- Terraform module development standards
- Infrastructure code review requirements (pull requests)
- Terraform validation and linting (`terraform validate`, `tflint`)
- Security scanning for infrastructure code (Checkov, tfsec)
- Immutable infrastructure principles
- Blue/green deployment strategies
- Lambda function code security (Python static analysis)
- Secrets management approach (avoid hardcoding in code)

---

## 9. Supplier Relationships Policy

**ISO 27001 Reference**: A.5.19, A.5.20, A.5.21, A.5.22, A.5.23

**Purpose**: Protect information accessible by suppliers and service providers

**Must Include**:
- Supplier security assessment procedures
- Supplier contract security requirements
- Service Level Agreement (SLA) security clauses
- Supply chain security risk management
- Supplier access controls
- Supplier performance monitoring
- Supplier incident management coordination

**Specific to Your Infrastructure**:
- AWS as primary cloud service provider (CSP)
  - Review AWS SOC 2, ISO 27001, PCI DSS certifications
  - AWS Shared Responsibility Model documentation
  - AWS Business Associate Agreement (BAA) for HIPAA if applicable
- Third-party integrations security assessment
- Terraform module source verification
- Container image supply chain security (if using Docker)
- SaaS application integrations (monitoring, logging, support tools)

---

## 10. Incident Management Policy

**ISO 27001 Reference**: A.5.24, A.5.25, A.5.26, A.6.8

**Purpose**: Ensure consistent and effective approach to security incidents

**Must Include**:
- Incident classification and severity levels
- Incident reporting channels (24/7 hotline/email)
- Incident response team roles and responsibilities
- Incident response procedures and playbooks
- Evidence collection and preservation
- Notification requirements (internal, customers, regulators)
- Post-incident review and lessons learned
- Legal and regulatory reporting obligations (GDPR breach notification within 72 hours)

**Specific to Your Infrastructure**:
- CloudWatch alarm response procedures
- GuardDuty finding investigation
- Security Hub alert triage
- SNS alert escalation workflow
- CloudTrail log analysis for forensics
- AWS Backup restoration procedures
- Communication plan for customer-impacting incidents
- Root cause analysis template

---

## 11. Business Continuity and Disaster Recovery Policy

**ISO 27001 Reference**: A.5.29, A.5.30

**Purpose**: Maintain business operations during disruptions and recover from disasters

**Must Include**:
- Business impact analysis (BIA) methodology
- Recovery Time Objective (RTO) and Recovery Point Objective (RPO) definitions
- Business continuity plans for critical processes
- Disaster recovery procedures
- Backup strategy and testing requirements
- Emergency contact lists and communication plans
- BC/DR testing schedule (at least annually)
- Plan maintenance and review procedures

**Specific to Your Infrastructure**:
- Multi-AZ architecture for high availability
- RDS Multi-AZ automatic failover
- Auto Scaling Group self-healing
- AWS Backup dual-schedule strategy:
  - Daily backups: 30-day retention (RPO: 24 hours)
  - Weekly backups: 365-day retention
- Backup restoration testing procedures (quarterly recommended)
- Cross-region backup replication (future enhancement)
- Terraform state backup and recovery
- Disaster recovery testing plan (`docs/disaster-recovery-test.md`)

---

## 12. Compliance and Legal Policy

**ISO 27001 Reference**: A.5.31, A.5.32, A.5.33, A.5.34, A.5.36, A.5.37

**Purpose**: Ensure compliance with legal, statutory, regulatory, and contractual requirements

**Must Include**:
- Applicable legal and regulatory requirements inventory
- Compliance monitoring and review procedures
- Data protection and privacy requirements (GDPR, DPA 2018)
- Intellectual property rights protection
- Records retention and disposal schedules
- Independent compliance reviews and audits
- Regulatory reporting procedures

**Specific to Your Infrastructure**:
- GDPR compliance for EU customer data:
  - Data residency (eu-west-2 region)
  - VPC Flow Logs 90-day retention (GDPR compliance)
  - Right to erasure procedures
  - Data Processing Agreement (DPA) with customers
- ISO 9001 quality management integration
- PCI DSS if processing payment card data
- CloudTrail audit logging (tamper-proof)
- AWS Config compliance tracking
- Security Hub standards (CIS, PCI DSS)

---

## 13. Cryptography Policy

**ISO 27001 Reference**: A.8.24

**Purpose**: Define proper use of cryptographic controls to protect information

**Must Include**:
- Encryption algorithm standards (AES-256, RSA-2048+)
- Key generation and strength requirements
- Key storage and protection procedures
- Key lifecycle management (rotation, archival, destruction)
- Cryptographic protocol requirements (TLS 1.2+)
- Key escrow and recovery procedures
- Hardware Security Module (HSM) requirements if applicable

**Specific to Your Infrastructure**:
- KMS key management:
  - Customer-managed keys (CMKs) for all encryption
  - 30-day deletion window for accidental deletion protection
  - Annual key rotation enabled
  - Separate keys per purpose (security, RDS, flow logs, state)
- TLS 1.2+ enforcement on ALB (ELBSecurityPolicy-TLS-1-2-2017-01)
- S3 bucket TLS-only policies (deny aws:SecureTransport=false)
- RDS encryption at rest (AES-256)
- EBS volume encryption (AES-256)
- Terraform state encryption with KMS
- SNS topic encryption for alerts

---

## 14. Data Protection and Privacy Policy

**ISO 27001 Reference**: A.5.33, A.5.34, A.8.10, A.8.11, A.8.12

**Purpose**: Protect personal data and ensure privacy rights

**Must Include**:
- Personal data identification and inventory
- Lawful basis for processing (GDPR Article 6)
- Data subject rights procedures (access, rectification, erasure, portability)
- Data minimization principles
- Privacy by design requirements
- Data breach notification procedures (72-hour GDPR requirement)
- International data transfer safeguards
- Data retention and deletion schedules
- Privacy impact assessments (PIAs)

**Specific to Your Infrastructure**:
- Multi-tenant data isolation (per-tenant S3 buckets)
- Tenant data encryption (KMS)
- Data location (eu-west-2 only)
- Tenant data backup and recovery
- Tenant data deletion procedures
- Application-level data access controls
- Pseudonymization where applicable
- Data processing records (GDPR Article 30)

---

## 15. Remote Working Policy

**ISO 27001 Reference**: A.6.7

**Purpose**: Secure information when working from remote locations

**Must Include**:
- Approved remote work locations and scenarios
- Remote access security requirements (VPN, MFA)
- Equipment security for remote workers
- Home network security guidelines
- Physical security of remote workspaces
- Acceptable use of personal devices (BYOD policy)
- Data storage and transfer restrictions
- Cloud service usage requirements

**Specific to Your Infrastructure**:
- AWS console access via corporate VPN + MFA
- Terraform execution from secured workstations only
- SSH key management (SSM Session Manager preferred)
- Laptop encryption requirements
- Screen lock and timeout policies
- Cloud-based development environments security

---

## 16. Acceptable Use Policy (AUP)

**ISO 27001 Reference**: A.5.10, A.6.2

**Purpose**: Define acceptable and unacceptable use of information systems

**Must Include**:
- Permitted uses of systems and data
- Prohibited activities (personal use limits, illegal activities)
- Internet and email usage guidelines
- Software installation restrictions
- Social media and external communication guidelines
- Personal data usage restrictions
- Monitoring and privacy expectations
- Consequences of policy violations

---

## 17. Mobile Device and Teleworking Policy

**ISO 27001 Reference**: A.6.7, A.8.9

**Purpose**: Protect information on mobile devices and during remote work

**Must Include**:
- Approved mobile device types
- Mobile Device Management (MDM) requirements
- Device encryption requirements
- Remote wipe capabilities
- Application whitelisting/blacklisting
- Public Wi-Fi security requirements
- Lost/stolen device reporting procedures
- BYOD vs. corporate-owned device distinctions

---

## 18. Risk Management Policy

**ISO 27001 Reference**: Clause 6.1.2, Clause 6.1.3

**Purpose**: Define how information security risks are identified, assessed, and treated

**Must Include**:
- Risk assessment methodology and frequency
- Risk criteria and acceptance levels
- Risk treatment options (mitigate, accept, transfer, avoid)
- Residual risk acceptance process
- Risk register maintenance
- Risk review and monitoring procedures
- Executive risk reporting

**Specific to Your Infrastructure**:
- AWS infrastructure risk assessment
- Terraform code security review
- Third-party service risk evaluation
- Multi-tenant isolation risks
- Cloud-specific risks (e.g., misconfiguration, over-privileged IAM)

---

## 19. Information Backup Policy

**ISO 27001 Reference**: A.8.13

**Purpose**: Ensure availability and recoverability of information and systems

**Must Include**:
- Backup frequency and schedules
- Backup retention periods
- Backup storage location and security
- Backup testing and restoration procedures
- Backup media handling and disposal
- Offsite/offline backup requirements
- Backup monitoring and alerting

**Specific to Your Infrastructure**:
- AWS Backup vault strategy:
  - Daily: 05:00 UTC, 30-day retention + 90-day copy
  - Weekly: 06:00 UTC Sundays, 365-day retention with cold storage after 30 days
- RDS native backups: 03:00-04:00 UTC, 7-day retention
- Terraform state versioning in S3
- S3 bucket versioning for tenant data
- Backup restoration testing (quarterly)
- Cross-region backup replication (future)

---

## 20. Security Monitoring and Logging Policy

**ISO 27001 Reference**: A.8.15, A.8.16

**Purpose**: Detect and respond to security events through effective monitoring

**Must Include**:
- Systems and events to be logged
- Log retention periods
- Log protection and integrity requirements
- Real-time monitoring and alerting
- Security event correlation and analysis
- Automated response capabilities
- Log review frequency and procedures
- SIEM (Security Information and Event Management) requirements

**Specific to Your Infrastructure**:
- CloudWatch Logs with 90-day retention
- CloudTrail audit logging (tamper-proof, KMS encrypted)
- VPC Flow Logs for network monitoring
- GuardDuty threat detection
- Security Hub aggregation
- AWS Config configuration monitoring
- WAF logging and metrics
- SNS alert distribution to ops team
- CloudWatch dashboard for key metrics

---

## Implementation Roadmap

### Priority 1 (Critical - Immediate):
1. Information Security Policy (Master Policy)
2. Access Control Policy
3. Risk Management Policy
4. Incident Management Policy
5. Data Protection and Privacy Policy

### Priority 2 (High - Within 3 months):
6. Operations Security Policy
7. Asset Management Policy
8. Business Continuity and Disaster Recovery Policy
9. Cryptography Policy
10. Compliance and Legal Policy

### Priority 3 (Medium - Within 6 months):
11. Communications Security Policy
12. Human Resources Security Policy
13. Security Monitoring and Logging Policy
14. Information Backup Policy
15. Supplier Relationships Policy

### Priority 4 (Standard - Within 12 months):
16. System Acquisition, Development, and Maintenance Policy
17. Remote Working Policy
18. Acceptable Use Policy
19. Mobile Device and Teleworking Policy
20. Physical and Environmental Security Policy

---

## Policy Management Requirements

### Executive Approval:
All policies must be:
- Reviewed and approved by C-level executive or board
- Signed with approval date
- Communicated to all relevant personnel

### Review Cycle:
- Annual review minimum
- After significant incidents
- After major infrastructure changes
- When regulatory requirements change

### Version Control:
- Maintain version history
- Document all changes
- Track approval dates and signatories

### Training and Awareness:
- All employees must acknowledge policies (annual)
- Specialized training for privileged users
- New hire onboarding includes policy review

### Compliance Monitoring:
- Internal audits (at least annually)
- External ISO 27001 certification audits
- Automated compliance checking (AWS Config, Security Hub)
- Regular policy effectiveness reviews

---

## Related Documentation

This policy framework supports your technical infrastructure documented in:
- `docs/readme.md` - Technical architecture overview
- `docs/infrastructure.md` - Detailed infrastructure design
- `docs/deployment.md` - Deployment procedures
- `docs/backup-restore-runbook.md` - Backup and recovery procedures
- `docs/disaster-recovery-test.md` - DR testing plan
- `docs/iam-matrix.csv` - IAM roles and permissions matrix

---

## Notes

1. **ISO 27001:2022 Update**: This policy list is based on the latest ISO 27001:2022 standard (93 controls in Annex A)
2. **Policy vs. Procedure**: Policies define "what" and "why"; procedures define "how" (step-by-step)
3. **Customization**: Each policy should be customized to your organization's size, culture, and risk appetite
4. **Legal Review**: Have policies reviewed by legal counsel, especially data protection and compliance policies
5. **Continuous Improvement**: ISO 27001 requires ongoing improvement - policies should evolve with threats and business changes

---

**Document Control**:
- **Created**: [Date]
- **Version**: 1.0
- **Next Review**: [Date + 12 months]
- **Owner**: Chief Information Security Officer (CISO)
- **Approver**: Chief Executive Officer (CEO)

