# Risk Management Policy

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
| **Owner** | Akam Rahimi, ISMS Lead |
| **Contact** | akam@epact.co.uk |
| **ISO 27001 Reference** | Clause 6.1.2, Clause 6.1.3 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy establishes EPACT LTD's approach to identifying, assessing, treating, and monitoring information security risks. It ensures that risks are managed consistently and aligned with business objectives.

### 1.2 Scope
This policy covers:
- All information security risks affecting EPACT operations
- AWS cloud infrastructure risks (eu-west-2 region)
- Multi-tenant platform security risks
- Third-party and supply chain risks
- Physical and environmental risks
- Human and organizational risks
- Legal, regulatory, and compliance risks

---

## 2. Risk Management Principles

### 2.1 Core Principles
1. **Proactive**: Identify and address risks before they materialize
2. **Comprehensive**: Consider all types of risks (technical, organizational, external)
3. **Risk-Based**: Allocate resources based on risk severity and likelihood
4. **Continuous**: Ongoing monitoring and review, not one-time activity
5. **Integrated**: Risk management embedded in all business processes
6. **Evidence-Based**: Decisions based on data from AWS Security Hub, Config, GuardDuty

### 2.2 Risk Appetite Statement
EPACT LTD's risk appetite:
- **Zero tolerance** for risks that could:
  - Cause unauthorized disclosure of customer/tenant data
  - Result in regulatory non-compliance (GDPR violations)
  - Compromise system availability for >4 hours
  - Damage company reputation or customer trust

- **Low tolerance** for risks that could:
  - Cause temporary service degradation
  - Impact single tenant without data loss
  - Require security incident response

- **Moderate tolerance** for risks that:
  - Can be mitigated with compensating controls
  - Have minimal customer impact
  - Are operational in nature with rapid recovery

---

## 3. Risk Assessment Methodology

### 3.1 Risk Assessment Frequency
- **Annual**: Comprehensive risk assessment covering all ISMS scope
- **Quarterly**: Targeted assessments for high-risk areas (production infrastructure)
- **Ad-hoc**: Triggered by:
  - New system deployment or major infrastructure changes
  - Security incidents or near-misses
  - Regulatory changes
  - Significant business changes
  - New threat intelligence
  - Audit findings

### 3.2 Risk Identification

#### 3.2.1 Risk Identification Methods
- **Asset-based**: Identify threats to critical assets (customer data, infrastructure)
- **Scenario-based**: Consider attack scenarios (data breach, DDoS, insider threat)
- **Compliance-based**: Gaps in meeting regulatory requirements
- **Vulnerability scanning**: AWS Inspector, Security Hub findings
- **Threat intelligence**: AWS security bulletins, CVE databases
- **Incident analysis**: Lessons learned from past incidents

#### 3.2.2 Risk Categories
1. **Infrastructure Risks**:
   - Misconfigured security groups or IAM policies
   - Unpatched vulnerabilities in EC2 AMIs
   - AWS service outages or degradation
   - Terraform state corruption or unauthorized changes
   - DDoS attacks on ALB

2. **Application Risks**:
   - SQL injection, XSS, or other OWASP Top 10 vulnerabilities
   - Broken authentication or session management
   - Insufficient tenant isolation
   - Insecure API endpoints
   - Dependency vulnerabilities

3. **Data Risks**:
   - Unauthorized data access or exfiltration
   - Data loss due to deletion or corruption
   - Insufficient backup or failed restoration
   - Encryption key loss or compromise
   - Multi-tenant data leakage

4. **Operational Risks**:
   - Human error during deployments
   - Insider threats (malicious or negligent employees)
   - Inadequate change management
   - Insufficient monitoring or delayed incident detection
   - Capacity or performance issues

5. **Third-Party Risks**:
   - AWS service provider vulnerabilities
   - Supply chain attacks (compromised dependencies)
   - Vendor access abuse
   - SaaS integration vulnerabilities

6. **Compliance Risks**:
   - GDPR violations (data breach, inadequate consent)
   - Failure to meet ISO 27001 requirements
   - Contractual SLA breaches
   - Audit findings not remediated

### 3.3 Risk Analysis

#### 3.3.1 Likelihood Assessment
Probability that a threat will exploit a vulnerability:

| **Rating** | **Level** | **Description** | **Frequency** |
|-----------|-----------|----------------|---------------|
| 5 | Very High | Almost certain to occur | > Once per month |
| 4 | High | Likely to occur | Once per quarter |
| 3 | Medium | Possible but not likely | Once per year |
| 2 | Low | Unlikely but possible | Once every 2-5 years |
| 1 | Very Low | Rare or improbable | Once every 5+ years |

#### 3.3.2 Impact Assessment
Severity of consequences if risk materializes:

| **Rating** | **Level** | **Business Impact** | **Examples** |
|-----------|-----------|---------------------|-------------|
| 5 | Very High | Catastrophic; business survival threatened | Complete customer database breach; multi-day outage; regulatory fines >£100k |
| 4 | High | Severe impact on business | Single tenant data breach; 4+ hour outage; significant financial loss |
| 3 | Medium | Moderate impact; manageable | Service degradation; minor data exposure; recovery within 2 hours |
| 2 | Low | Minor impact; minimal disruption | Single user account compromise; <1 hour downtime |
| 1 | Very Low | Negligible impact | Cosmetic issues; no data or availability impact |

#### 3.3.3 Risk Score Calculation
**Risk Score = Likelihood × Impact** (Range: 1-25)

**Risk Matrix**:
```
        Impact
      1   2   3   4   5
    ┌───────────────────┐
  5 │ 5  10  15  20  25 │
  4 │ 4   8  12  16  20 │
L 3 │ 3   6   9  12  15 │
i 2 │ 2   4   6   8  10 │
  1 │ 1   2   3   4   5 │
    └───────────────────┘
```

**Risk Levels**:
- **Critical (21-25)**: Immediate action required; escalate to Managing Director
- **High (13-20)**: Senior management attention; mitigation plan within 7 days
- **Medium (5-12)**: Action plan required; mitigate within 30 days
- **Low (1-4)**: Monitor; accept with standard controls

### 3.4 Risk Evaluation
- Compare risk score against risk acceptance criteria
- Prioritize risks for treatment
- Consider cumulative and cascading risks
- Document all risk assessment decisions in risk register

---

## 4. Risk Treatment

### 4.1 Risk Treatment Options

#### 4.1.1 Risk Mitigation (Reduce)
**Preferred Option**: Implement security controls to reduce likelihood or impact

**Examples**:
- Deploy AWS WAF to mitigate DDoS risk
- Enable GuardDuty to detect unauthorized access
- Implement MFA to reduce credential compromise
- Add S3 lifecycle policies to reduce storage cost risk
- Configure CloudWatch alarms to detect issues early

**Controls Selection**:
- Preventive controls (security groups, encryption, MFA)
- Detective controls (CloudTrail, GuardDuty, Config)
- Corrective controls (AWS Backup, incident response)
- Cost-effective and proportionate to risk

#### 4.1.2 Risk Acceptance (Retain)
**When Used**: Risk is low; cost of mitigation exceeds benefit; residual risk after controls

**Requirements**:
- Documented justification
- Managing Director formal approval
- Reviewed quarterly
- Acceptance time-limited (maximum 12 months)
- Monitoring plan for accepted risks

**Example**: Accept risk of NAT Gateway failure (medium impact, low likelihood) because multi-AZ deployment provides redundancy

#### 4.1.3 Risk Transfer (Share)
**When Used**: Risk can be shared with third party

**Examples**:
- Cyber insurance for data breach financial impact
- AWS Shared Responsibility Model (physical security transferred to AWS)
- Contractual liability limitations with customers
- SLA penalties in supplier contracts

**Requirements**:
- Contract clearly defines transferred responsibilities
- Residual risk assessed and managed
- Supplier capability verified

#### 4.1.4 Risk Avoidance (Eliminate)
**When Used**: Risk is too high and cannot be adequately mitigated

**Examples**:
- Do not store payment card data (use third-party payment processor instead)
- Do not process special category personal data without legal basis
- Avoid deploying services in unsupported AWS regions

### 4.2 Risk Treatment Plans
Each risk rated Medium or above requires:
- **Risk ID**: Unique identifier (e.g., RISK-2024-001)
- **Risk owner**: Individual accountable for managing the risk
- **Treatment option**: Mitigate/Accept/Transfer/Avoid
- **Controls**: Specific security controls to be implemented
- **Timeline**: Implementation deadline
- **Resources**: Budget and personnel required
- **Success criteria**: How effectiveness will be measured
- **Review date**: When risk will be reassessed

---

## 5. Risk Register

### 5.1 Risk Register Contents
EPACT maintains a centralized risk register containing:
- **Risk ID**: Unique identifier
- **Risk description**: Clear description of threat and vulnerability
- **Asset(s) affected**: Systems, data, or processes at risk
- **Threat source**: External attacker, insider, natural disaster, etc.
- **Existing controls**: Current security measures in place
- **Likelihood rating**: 1-5 scale
- **Impact rating**: 1-5 scale
- **Inherent risk score**: Likelihood × Impact (before controls)
- **Control effectiveness**: How well existing controls reduce risk
- **Residual risk score**: Risk remaining after controls
- **Risk treatment**: Chosen treatment option
- **Risk owner**: Accountable individual
- **Status**: Open, In Progress, Closed, Accepted
- **Review date**: Next scheduled review
- **Last updated**: Date and by whom

### 5.2 Risk Register Maintenance
- **Owner**: ISMS Lead maintains central register
- **Format**: Spreadsheet or GRC tool
- **Updates**: Monthly or after significant events
- **Access**: Available to senior management; restricted to authorized personnel
- **Backup**: Risk register backed up with other critical business documents

### 5.3 Example Risk Entries (Infrastructure-Specific)

**RISK-001**: Unauthorized Access to Terraform State
- **Asset**: Terraform state file (S3 bucket)
- **Threat**: External attacker or malicious insider
- **Vulnerability**: Misconfigured S3 bucket permissions
- **Existing Controls**: S3 bucket encryption (KMS), versioning, access logging (CloudTrail), IAM policies
- **Likelihood**: 2 (Low) - Strong controls in place
- **Impact**: 5 (Very High) - State contains sensitive infrastructure details
- **Inherent Risk**: 10 (Medium)
- **Residual Risk**: 6 (Medium) - After controls
- **Treatment**: Accept with monitoring (CloudWatch alarms for unauthorized access)
- **Owner**: ISMS Lead
- **Review**: Quarterly

**RISK-002**: Multi-Tenant Data Leakage
- **Asset**: Customer tenant data in S3 buckets
- **Threat**: Application logic flaw or SQL injection
- **Vulnerability**: Insufficient tenant_id validation in queries
- **Existing Controls**: Database row-level security, input validation, WAF, per-tenant S3 buckets, code reviews
- **Likelihood**: 2 (Low) - Multiple layers of isolation
- **Impact**: 5 (Very High) - Customer data breach; GDPR violation
- **Inherent Risk**: 10 (Medium)
- **Residual Risk**: 6 (Medium) - After controls
- **Treatment**: Mitigate with annual penetration testing and continuous monitoring
- **Owner**: Senior Developer
- **Review**: Quarterly

**RISK-003**: RDS Database Failure
- **Asset**: MySQL RDS instance
- **Threat**: Hardware failure, corruption, or AWS service outage
- **Vulnerability**: Single point of failure for data storage
- **Existing Controls**: Multi-AZ deployment, automated backups (7-day + AWS Backup 30/365-day), CloudWatch monitoring
- **Likelihood**: 2 (Low) - AWS SLA 99.95% for Multi-AZ
- **Impact**: 4 (High) - Service unavailable during failover (~2 minutes)
- **Inherent Risk**: 8 (Medium)
- **Residual Risk**: 4 (Low) - After controls
- **Treatment**: Accept with monitoring and tested disaster recovery procedures
- **Owner**: Senior Developer
- **Review**: Quarterly

---

## 6. Risk Monitoring and Review

### 6.1 Continuous Monitoring
- **AWS Security Hub**: Daily review of compliance findings
- **AWS GuardDuty**: Real-time threat detection with SNS alerts
- **AWS Config**: Configuration compliance monitoring
- **CloudWatch Alarms**: Operational risk indicators (CPU, disk, error rates)
- **Vulnerability scanning**: Monthly scans of application and infrastructure

### 6.2 Risk Review Meetings
**Monthly Operations Review**:
- Review new risks identified
- Update risk register with changes
- Track risk treatment implementation progress
- Escalate risks exceeding appetite

**Quarterly Management Review**:
- Review risk register with Managing Director
- Assess effectiveness of risk treatments
- Approve risk acceptance decisions
- Allocate budget for risk mitigation projects
- Review risk trends and emerging threats

**Annual ISMS Review**:
- Comprehensive review of all risks
- Assess ISMS effectiveness
- Update risk assessment methodology if needed
- Strategic risk planning for next 12 months

### 6.3 Risk Reporting
**To Managing Director**:
- Monthly risk dashboard (top 10 risks, trends, treatment status)
- Immediate escalation of critical risks
- Quarterly comprehensive risk report

**To All Staff**:
- Quarterly security newsletter highlighting key risks and controls
- Training on specific risks relevant to roles

**To Customers** (as appropriate):
- Annual security posture summary
- Notification of risks affecting their services
- Incident reports for material incidents

---

## 7. AWS Infrastructure-Specific Risks

### 7.1 Cloud-Specific Risk Categories

#### 7.1.1 Configuration Risks
- **Threat**: Misconfigured security groups, S3 buckets, IAM policies
- **Mitigation**:
  - Terraform Infrastructure-as-Code (peer review required)
  - AWS Config rules for compliance
  - Automated scanning with Checkov/tfsec
  - Quarterly manual configuration review

#### 7.1.2 Identity and Access Risks
- **Threat**: Compromised credentials, excessive permissions, privilege escalation
- **Mitigation**:
  - MFA enforced for all AWS console access
  - Least privilege IAM policies
  - Quarterly access reviews
  - CloudTrail logging and GuardDuty monitoring
  - No long-lived access keys

#### 7.1.3 Data Protection Risks
- **Threat**: Encryption key loss, data exfiltration, unauthorized access
- **Mitigation**:
  - KMS customer-managed keys (30-day deletion window)
  - Encryption at rest (S3, RDS, EBS) and in transit (TLS 1.2+)
  - S3 bucket public access blocked
  - VPC private subnets for data storage
  - GuardDuty S3 protection

#### 7.1.4 Availability Risks
- **Threat**: Service outages, DDoS attacks, resource exhaustion
- **Mitigation**:
  - Multi-AZ deployment (RDS, EC2 ASG, NAT gateways)
  - Auto Scaling (min 2, max 10 instances)
  - AWS WAF rate limiting (2000 req/IP/5min)
  - Health checks and automatic failover
  - Daily and weekly backups

#### 7.1.5 Compliance Risks
- **Threat**: GDPR violations, failed audits, data residency issues
- **Mitigation**:
  - Data location restricted to eu-west-2
  - CloudTrail audit logging
  - Security Hub CIS Benchmark compliance
  - Documented policies and procedures
  - Regular compliance monitoring

---

## 8. Risk Treatment Planning

### 8.1 Risk Treatment Plan Template
For each risk requiring treatment:

**Risk ID**: RISK-YYYY-NNN  
**Risk Title**: [Descriptive title]  
**Risk Owner**: [Name and position]  
**Treatment Option**: Mitigate / Accept / Transfer / Avoid  
**Target Completion Date**: [Date]  
**Budget Allocated**: [Amount]

**Current Situation**:
- Existing controls: [List]
- Current risk score: [Score]
- Gaps identified: [Description]

**Proposed Treatment**:
- Control(s) to implement: [Detailed description]
- Implementation steps: [Numbered list]
- Resources required: [Personnel, budget, tools]
- Dependencies: [Any prerequisites]

**Expected Outcome**:
- Target risk score: [Score after treatment]
- Measurable success criteria: [How to verify effectiveness]
- Monitoring approach: [How ongoing effectiveness will be tracked]

**Approval**:
- Prepared by: [Name], [Date]
- Reviewed by: ISMS Lead, [Date]
- Approved by: Managing Director, [Date]

### 8.2 Control Selection Criteria
Controls selected based on:
- **Effectiveness**: How well control reduces risk
- **Cost**: Implementation and ongoing costs
- **Feasibility**: Technical and organizational capability
- **Compliance**: Alignment with ISO 27001 and regulatory requirements
- **Maturity**: Proven vs. experimental controls
- **Integration**: Compatibility with existing systems

### 8.3 Compensating Controls
When standard controls cannot be implemented:
- Document reason for exception
- Identify alternative controls providing equivalent protection
- Assess residual risk with compensating controls
- Managing Director approval required
- Review every 6 months

---

## 9. Residual Risk Management

### 9.1 Residual Risk Definition
Risk remaining after controls are implemented and operating effectively.

### 9.2 Residual Risk Acceptance
**Acceptance Criteria**:
- Residual risk score ≤ 8 (Medium or below)
- All reasonable mitigation steps taken
- Business justification documented
- Monitoring plan in place

**Approval Authority**:
- **Low risks (1-4)**: ISMS Lead
- **Medium risks (5-12)**: Managing Director
- **High risks (13-20)**: Not acceptable; require further mitigation
- **Critical risks (21-25)**: Not acceptable; activity must cease

### 9.3 Residual Risk Register
- Separate section in risk register for accepted residual risks
- Reviewed quarterly to ensure acceptance criteria still valid
- Changes in threat landscape may require re-evaluation
- Customer notification for risks affecting their data

---

## 10. Specific Risk Scenarios and Treatments

### 10.1 Data Breach Risk
**Scenario**: Unauthorized access to customer tenant data

**Inherent Risk**: Likelihood 3 × Impact 5 = 15 (High)

**Controls Implemented**:
- Per-tenant S3 bucket isolation
- KMS encryption at rest
- TLS-only bucket policies
- IAM least privilege
- GuardDuty anomaly detection
- CloudTrail audit logging
- WAF protection
- Application-level tenant_id validation
- Database row-level security

**Residual Risk**: Likelihood 2 × Impact 5 = 10 (Medium - Accepted)

**Monitoring**: GuardDuty findings, CloudWatch alarms, quarterly penetration testing

---

### 10.2 Terraform State Tampering Risk
**Scenario**: Malicious or accidental modification of Terraform state

**Inherent Risk**: Likelihood 2 × Impact 4 = 8 (Medium)

**Controls Implemented**:
- S3 bucket versioning (rollback capability)
- KMS encryption
- DynamoDB locking (prevents concurrent modifications)
- IAM policies (limited to authorized users)
- CloudTrail logging
- Peer review for infrastructure changes
- Git version control for Terraform code

**Residual Risk**: Likelihood 1 × Impact 4 = 4 (Low - Accepted)

**Monitoring**: CloudTrail alerts for S3 bucket modifications

---

### 10.3 DDoS Attack Risk
**Scenario**: Distributed Denial of Service attack on public ALB

**Inherent Risk**: Likelihood 4 × Impact 3 = 12 (Medium)

**Controls Implemented**:
- AWS WAF rate limiting (2000 req/IP/5min)
- AWS Shield Standard (included with AWS)
- Auto Scaling Group (scales to handle legitimate load spikes)
- CloudWatch alarms for abnormal traffic
- ALB health checks and automatic failover

**Residual Risk**: Likelihood 3 × Impact 2 = 6 (Medium - Accepted)

**Future Enhancement**: Consider AWS Shield Advanced for large-scale attacks

---

### 10.4 Insider Threat Risk
**Scenario**: Malicious employee exfiltrates customer data

**Inherent Risk**: Likelihood 2 × Impact 5 = 10 (Medium)

**Controls Implemented**:
- Least privilege access (IAM policies)
- MFA required for all access
- CloudTrail logging of all actions
- GuardDuty behavioral analysis
- Quarterly access reviews
- Data classification and handling training
- NDAs for all employees
- Background checks for employees with privileged access

**Residual Risk**: Likelihood 1 × Impact 5 = 5 (Medium - Accepted)

**Monitoring**: GuardDuty anomaly detection, manual review of bulk data access

---

## 11. Emerging Risks and Threat Intelligence

### 11.1 Threat Intelligence Sources
- **AWS Security Bulletins**: Monitored by Support team
- **CVE Databases**: Weekly review for infrastructure components
- **OWASP**: Quarterly review of Top 10 web vulnerabilities
- **UK NCSC**: National Cyber Security Centre alerts
- **Industry groups**: Cloud Security Alliance, SANS Institute
- **AWS re:Inforce**: Annual security conference insights

### 11.2 Emerging Risk Assessment
- New threats assessed within 5 business days of identification
- Impact on EPACT infrastructure evaluated
- Treatment plan developed if risk score ≥ 8
- Customers notified if risk affects their data or services

---

## 12. Risk Communication

### 12.1 Internal Communication
- **Risk register**: Accessible to senior management
- **Risk dashboard**: Monthly update to all staff
- **Training**: Risks included in security awareness training
- **Incident learnings**: Communicated promptly to relevant teams

### 12.2 External Communication
- **Customers**: Annual security summary; incident notifications
- **Auditors**: Full risk register access during audits
- **Regulators**: Risk information as required (e.g., ICO for data protection)
- **Suppliers**: Shared risks discussed and jointly managed

---

## 13. Integration with Business Processes

### 13.1 Change Management
- All infrastructure changes require risk assessment
- Terraform changes reviewed for security impact
- High-risk changes require change advisory board approval
- Rollback plans documented for risky changes

### 13.2 Project Management
- Security risk assessment in project initiation phase
- Security requirements defined in project scope
- Risk register updated with project-specific risks
- Security testing before production deployment

### 13.3 Supplier Onboarding
- Security risk assessment before engaging supplier
- Contract includes security requirements
- Ongoing monitoring of supplier security posture
- Annual supplier security reviews

---

## 14. Compliance and Audit

### 14.1 ISO 27001 Compliance
Risk management process must satisfy:
- Clause 6.1.2: Information security risk assessment
- Clause 6.1.3: Information security risk treatment
- Evidence of systematic risk management approach
- Regular reviews and continuous improvement

### 14.2 Audit Evidence
Maintained for auditor review:
- Risk assessment reports (annual and ad-hoc)
- Risk register (current and historical)
- Risk treatment plans
- Risk acceptance forms (signed by Managing Director)
- Monitoring reports
- Review meeting minutes

---

## 15. Roles and Responsibilities

| **Role** | **Responsibilities** |
|---------|---------------------|
| **Managing Director** | Approve risk appetite; accept high risks; allocate resources; review quarterly reports |
| **ISMS Lead** | Maintain risk register; conduct risk assessments; coordinate treatments; report to management |
| **Senior Developer** | Identify technical risks; implement controls; conduct infrastructure risk assessments |
| **Development Team** | Report risks; implement secure coding; participate in risk assessments |
| **Support Team** | Monitor security events; report incidents; assist with risk identification |
| **All Staff** | Report potential risks; comply with controls; participate in training |

---

## 16. Policy Review

This policy shall be reviewed:
- Annually by ISMS Lead
- After significant security incidents
- After major business or infrastructure changes
- When regulatory requirements change
- When risk assessment methodology updated

---

## 17. Related Documents

- Information Security Policy
- Incident Management Policy
- Business Continuity and Disaster Recovery Policy
- Operations Security Policy
- Risk Register (maintained separately)
- AWS Infrastructure Documentation (docs/readme.md)
- Disaster Recovery Test Plan (docs/disaster-recovery-test.md)

---

## 18. Management Approval

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

---

**END OF POLICY**

