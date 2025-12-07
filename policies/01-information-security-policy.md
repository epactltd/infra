# Information Security Policy

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
| **Owner** | Akam Rahimi, Managing Director & ISMS Lead |
| **Contact** | akam@epact.co.uk |
| **ISO 27001 Reference** | A.5.1, Clause 5.2 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This Information Security Policy establishes EPACT LTD's commitment to protecting the confidentiality, integrity, and availability of information assets. It provides the framework for our Information Security Management System (ISMS) and guides all security-related activities within the organization.

### 1.2 Scope
This policy applies to:
- All EPACT LTD employees, contractors, consultants, and third parties
- All information in any form (digital, physical, verbal)
- All information systems, networks, and infrastructure (including AWS cloud services)
- All locations where EPACT business is conducted
- The multi-tenant SaaS platform deployed on AWS eu-west-2 region
- All customer and tenant data processed or stored by EPACT

### 1.3 Exclusions
- Personal data processing on personal devices for non-work purposes
- Third-party systems that EPACT does not own or control (governed by supplier agreements)

---

## 2. Management Commitment

The Managing Director and senior leadership of EPACT LTD are committed to:

1. **Establishing and maintaining** an effective Information Security Management System (ISMS) aligned with ISO 27001:2022
2. **Providing adequate resources** (financial, human, technical) for information security
3. **Setting clear security objectives** that align with business strategy and regulatory requirements
4. **Leading by example** in following security policies and promoting security awareness
5. **Continuously improving** our security posture through regular reviews and updates
6. **Ensuring accountability** at all organizational levels for information security
7. **Communicating** the importance of effective information security to all stakeholders

---

## 3. Information Security Objectives

EPACT LTD's information security objectives are to:

### 3.1 Confidentiality
- Protect customer and tenant data from unauthorized disclosure
- Maintain strict data isolation between tenants in our multi-tenant platform
- Encrypt sensitive data at rest and in transit using industry-standard cryptography
- Implement role-based access controls (RBAC) and least privilege principles

### 3.2 Integrity
- Ensure accuracy and completeness of information and processing methods
- Protect systems and data from unauthorized modification
- Maintain audit trails for critical operations using AWS CloudTrail
- Implement version control for all Infrastructure-as-Code (Terraform)

### 3.3 Availability
- Maintain system availability targets of 99.9% uptime for production services
- Deploy multi-AZ architecture for resilience and fault tolerance
- Implement automated backup and recovery procedures (daily and weekly schedules)
- Ensure rapid response to incidents affecting service availability

### 3.4 Compliance
- Comply with GDPR and UK Data Protection Act 2018
- Maintain ISO 27001 and ISO 9001 certifications
- Meet PCI DSS requirements if processing payment card data
- Adhere to contractual obligations with customers and suppliers

---

## 4. Information Security Framework

### 4.1 Risk-Based Approach
EPACT adopts a risk-based approach to information security:
- **Risk assessments** conducted annually and after significant changes
- **Risk treatment plans** developed for identified risks
- **Residual risks** documented and formally accepted by management
- **Risk appetite** defined as: No tolerance for high risks affecting customer data; moderate tolerance for operational risks with compensating controls

### 4.2 Defense in Depth
Multiple layers of security controls:
1. **Perimeter Security**: AWS WAF, network segmentation, VPC isolation
2. **Network Security**: Security groups, NACLs, TLS encryption, VPC Flow Logs
3. **Host Security**: EBS encryption, IMDSv2, OS hardening, patch management
4. **Application Security**: Secure coding, input validation, authentication, authorization
5. **Data Security**: KMS encryption, data classification, backup encryption
6. **Monitoring**: GuardDuty, Security Hub, CloudWatch, CloudTrail

### 4.3 Shared Responsibility Model
- **AWS Responsibility**: Physical security, infrastructure, hypervisor, network infrastructure
- **EPACT Responsibility**: Operating systems, applications, data, IAM, encryption, network configuration, security groups

---

## 5. Organizational Security Structure

### 5.1 Roles and Responsibilities

#### 5.1.1 Managing Director (Akam Rahimi)
- Ultimate accountability for information security
- ISMS Lead and Data Protection Officer
- Approves security policies and risk acceptance decisions
- Allocates resources for security initiatives
- Reviews security performance metrics quarterly

#### 5.1.2 Business Development Director
- Ensures security requirements in customer contracts
- Communicates security commitments to customers
- Reports security-related customer concerns to ISMS Lead
- Supports security awareness in customer-facing activities

#### 5.1.3 Development Team (Senior Developer, Developer)
- Implements secure coding practices
- Conducts peer code reviews for security
- Manages Infrastructure-as-Code (Terraform) securely
- Performs vulnerability assessments and remediation
- Maintains development, test, production environment separation
- Implements security controls in application design
- Monitors security alerts (CloudWatch, GuardDuty, Security Hub)
- Responds to security incidents following incident response procedures

#### 5.1.4 Support Team
- Manages access requests and account provisioning
- Maintains system logs and audit trails
- Escalates security concerns to ISMS Lead

#### 5.1.5 All Employees
- Comply with all information security policies and procedures
- Complete annual security awareness training
- Report suspected security incidents immediately
- Protect credentials and access tokens
- Handle information according to its classification
- Sign and adhere to Acceptable Use Policy

---

## 6. Legal and Regulatory Requirements

### 6.1 Data Protection
- **General Data Protection Regulation (GDPR)**
- **UK Data Protection Act 2018**
- **Privacy and Electronic Communications Regulations (PECR)**
- Data Processing Agreements (DPAs) with customers

### 6.2 Standards and Frameworks
- **ISO 27001:2022** - Information Security Management
- **ISO 9001** - Quality Management
- **PCI DSS** - Payment Card Industry Data Security Standard (if applicable)
- **CIS AWS Foundations Benchmark**

### 6.3 Contractual Obligations
- Customer Service Level Agreements (SLAs)
- Supplier and vendor security requirements
- AWS Business Associate Agreement (if processing health data)
- Non-Disclosure Agreements (NDAs)

### 6.4 Industry Best Practices
- OWASP Top 10 for web application security
- NIST Cybersecurity Framework
- AWS Well-Architected Framework (Security Pillar)
- Terraform security best practices

---

## 7. Information Classification

### 7.1 Classification Levels

| **Level** | **Description** | **Examples** | **Handling Requirements** |
|-----------|----------------|--------------|--------------------------|
| **RESTRICTED** | Highest sensitivity; unauthorized disclosure causes severe damage | Customer databases, encryption keys, authentication credentials, personal data | Encrypted at rest and in transit; MFA required; access logged; need-to-know basis only |
| **CONFIDENTIAL** | Internal information; unauthorized disclosure causes significant damage | Business plans, financial data, contracts, system architecture, source code | Encrypted in transit; access controls; employee/contractor access only |
| **INTERNAL** | General business information; unauthorized disclosure causes limited damage | Internal procedures, meeting notes, project documentation | Access controls; employee access; not for public distribution |
| **PUBLIC** | Information approved for public release | Marketing materials, public website content, press releases | No special protection required; approved for external distribution |

### 7.2 Data Handling Requirements
- All customer tenant data classified as **RESTRICTED**
- AWS KMS encryption required for RESTRICTED and CONFIDENTIAL data
- TLS 1.2+ encryption required for data in transit
- Multi-factor authentication (MFA) required for RESTRICTED data access
- CloudTrail logging for all access to RESTRICTED data

---

## 8. Security Policy Framework

This master policy is supported by the following specific policies:

### 8.1 People Security
- Access Control Policy
- Human Resources Security Policy
- Remote Working Policy
- Acceptable Use Policy
- Mobile Device and Teleworking Policy

### 8.2 Technical Security
- Operations Security Policy
- Communications Security Policy
- Cryptography Policy
- System Acquisition, Development, and Maintenance Policy
- Security Monitoring and Logging Policy

### 8.3 Organizational Security
- Asset Management Policy
- Risk Management Policy
- Business Continuity and Disaster Recovery Policy
- Incident Management Policy
- Information Backup Policy

### 8.4 External Parties
- Supplier Relationships Policy
- Data Protection and Privacy Policy
- Compliance and Legal Policy

### 8.5 Physical Security
- Physical and Environmental Security Policy

---

## 9. Risk Management Approach

### 9.1 Risk Assessment Methodology
- **Annual** comprehensive risk assessments
- **Ad-hoc** assessments for new systems, major changes, or incidents
- **Methodology**: Qualitative risk assessment (likelihood × impact)
- **Risk matrix**: 5×5 matrix (likelihood and impact rated 1-5)
- **Tools**: AWS Security Hub, AWS Config, vulnerability scanners

### 9.2 Risk Treatment Options
1. **Mitigate**: Implement controls to reduce risk (preferred option)
2. **Accept**: Formally accept residual risk (documented and approved by Managing Director)
3. **Transfer**: Transfer risk through insurance or contracts
4. **Avoid**: Eliminate the risk-causing activity

### 9.3 Risk Acceptance Criteria
- **Low risks** (score 1-4): Accepted with standard controls
- **Medium risks** (score 5-12): Require compensating controls and quarterly review
- **High risks** (score 13-20): Require immediate mitigation; escalation to Managing Director
- **Critical risks** (score 21-25): Not acceptable; activity must be stopped until mitigated

---

## 10. Incident Management

### 10.1 Security Incident Definition
Any event that:
- Compromises confidentiality, integrity, or availability of information
- Violates security policies or legal requirements
- Threatens business operations or reputation
- May impact customer data or services

### 10.2 Incident Reporting
- **Immediate reporting** to ISMS Lead: akam@epact.co.uk
- **24/7 escalation**: Via SNS alerts to on-call team
- **No blame culture**: Encourage reporting without fear of reprisal
- **GDPR compliance**: Personal data breaches assessed within 24 hours; reported to ICO within 72 hours if required

### 10.3 Incident Response
- Incident Response Team coordinates response
- Evidence preservation using AWS CloudTrail logs
- Root cause analysis for all incidents
- Lessons learned documented and policies updated

---

## 11. Business Continuity and Disaster Recovery

### 11.1 Objectives
- **Recovery Time Objective (RTO)**: 4 hours for critical services
- **Recovery Point Objective (RPO)**: 24 hours maximum data loss
- **Multi-AZ deployment**: Automatic failover for RDS and EC2
- **Backup strategy**: Daily (30-day retention) and weekly (365-day retention)

### 11.2 Testing
- **Backup restoration tests**: Quarterly
- **Disaster recovery exercises**: Annually (see disaster-recovery-test.md)
- **Business continuity plan review**: Annually or after significant changes

---

## 12. Compliance and Audit

### 12.1 Internal Audits
- **Frequency**: At least annually
- **Scope**: All ISMS processes and controls
- **Independence**: Conducted by personnel independent of the audited area
- **Findings**: Documented, tracked, and remediated within agreed timescales

### 12.2 External Audits
- **ISO 27001 certification audits**: Annually by accredited certification body
- **Customer audits**: As per contractual agreements
- **Third-party assessments**: Periodic penetration tests and security assessments

### 12.3 Compliance Monitoring
- AWS Config rules for infrastructure compliance
- Security Hub standards (CIS Benchmark, PCI DSS)
- Automated compliance checks in CI/CD pipeline (terraform validate, tflint, Checkov)
- Quarterly compliance reviews by ISMS Lead

---

## 13. Security Awareness and Training

### 13.1 Mandatory Training
- **All employees**: Annual security awareness training (minimum 2 hours)
- **New hires**: Security induction within first week
- **Privileged users**: Additional specialized training (AWS security, Terraform, secure coding)
- **Annual refresher**: Updated training on emerging threats

### 13.2 Training Content
- Information security policy overview
- Data classification and handling
- Password security and MFA
- Phishing and social engineering awareness
- Incident reporting procedures
- GDPR and data protection responsibilities
- Secure remote working practices
- Acceptable use of systems

### 13.3 Training Records
- Training completion tracked and documented
- Certificates retained for audit purposes
- Training effectiveness assessed through tests and simulations
- Non-completion escalated to line management

---

## 14. Third-Party Security

### 14.1 Cloud Service Provider (AWS)
- AWS SOC 2, ISO 27001, ISO 9001, PCI DSS certifications verified
- AWS Shared Responsibility Model documented and understood
- AWS security services utilized (GuardDuty, Security Hub, CloudTrail, Config)
- Regular review of AWS security bulletins and advisories

### 14.2 Other Suppliers
- Security assessment before engagement
- Security requirements in contracts
- Access limited to minimum necessary
- Regular security reviews for critical suppliers
- Incident notification requirements in agreements

---

## 15. Policy Violations

### 15.1 Consequences
Policy violations may result in:
- Verbal or written warning
- Suspension of access privileges
- Suspension or termination of employment/contract
- Legal action (criminal or civil proceedings)
- Regulatory reporting (if required by law)

### 15.2 Investigation
- All suspected violations investigated promptly and fairly
- Evidence collected and preserved
- Findings documented
- Corrective actions implemented
- Lessons learned incorporated into policy updates

---

## 16. Policy Review and Maintenance

### 16.1 Review Schedule
- **Annual review**: Mandatory, led by ISMS Lead
- **Triggered reviews**: After significant incidents, regulatory changes, or infrastructure changes
- **Version control**: All changes documented with version history
- **Approval**: Managing Director approves all policy updates

### 16.2 Communication
- Policy updates communicated to all affected parties
- Training provided on significant changes
- Policies accessible via company intranet/document management system
- Acknowledgment required from all employees annually

### 16.3 Continuous Improvement
- Security metrics reviewed quarterly:
  - Number of incidents and mean time to detect/respond
  - Audit findings and closure rates
  - Training completion rates
  - Backup restoration success rates
  - System availability and uptime
- Management review meetings: Quarterly
- External benchmarking against industry standards

---

## 17. Related Documents

- Access Control Policy
- Risk Management Policy
- Incident Management Policy
- Data Protection and Privacy Policy
- All other security policies listed in Section 8
- Technical documentation (docs/readme.md, docs/infrastructure.md)
- IAM Matrix (docs/iam-matrix.csv)
- Disaster Recovery Test Plan (docs/disaster-recovery-test.md)

---

## 18. Policy Acknowledgment

By signing below, I acknowledge that I have read, understood, and agree to comply with EPACT LTD's Information Security Policy. I understand that violations may result in disciplinary action up to and including termination of employment or contract.

**Employee/Contractor Name**: ________________________________

**Signature**: ________________________________

**Date**: ________________________________

**Position**: ________________________________

---

## 19. Management Approval

**Approved by**:

**Name**: Akam Rahimi  
**Position**: Managing Director & ISMS Lead  
**Signature**: ________________________________  
**Date**: ________________________________

---

## Revision History

| **Version** | **Date** | **Author** | **Description of Changes** | **Approved By** |
|------------|----------|------------|---------------------------|-----------------|
| 1.0 | [Date] | Akam Rahimi | Initial policy creation | Akam Rahimi |
| | | | | |
| | | | | |

---

**END OF POLICY**

*This policy will be reviewed annually or sooner if required by business, regulatory, or technological changes.*

*For questions or clarifications, contact: Akam Rahimi, akam@epact.co.uk*

