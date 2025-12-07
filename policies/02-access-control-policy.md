# Access Control Policy

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
| **ISO 27001 Reference** | A.5.15, A.5.18, A.8.2, A.8.3 |

---

## 1. Purpose and Scope

### 1.1 Purpose
This policy establishes requirements for controlling access to EPACT LTD's information systems and data, ensuring that only authorized users can access specific resources based on legitimate business needs.

### 1.2 Scope
This policy applies to:
- All EPACT employees, contractors, consultants, and third parties
- All information systems (AWS infrastructure, applications, databases, workstations)
- All access methods (console, API, SSH, database, application)
- Logical and physical access controls
- User account lifecycle (creation, modification, suspension, deletion)

---

## 2. Access Control Principles

### 2.1 Least Privilege
- Users granted minimum access necessary for job functions
- Elevated privileges granted temporarily and reviewed regularly
- Default deny approach for all access requests
- Separation of duties for critical operations

### 2.2 Need-to-Know Basis
- Access granted only when business justification exists
- Access requests require approval from line manager and ISMS Lead
- Access automatically revoked when business need expires
- Regular access reviews to identify and remove unnecessary permissions

### 2.3 Defense in Depth
- Multiple authentication factors for sensitive systems
- Network segmentation (VPC, security groups)
- Application-level access controls
- Database-level access controls
- Audit logging for all access attempts

---

## 3. User Access Management

### 3.1 User Registration and De-registration

#### 3.1.1 New User Access Request
**Procedure**:
1. Line manager submits access request specifying required systems and justification
2. ISMS Lead reviews and approves based on role requirements
3. Support team creates account with least privilege
4. User credentials provided securely (not via email)
5. User required to change temporary password on first login
6. Access logged in user access register

**Required Information**:
- Employee/contractor name and position
- Start date and (if applicable) end date
- Systems and resources required
- Business justification
- Approval from line manager
- ISMS Lead approval for AWS production access

#### 3.1.2 User Access Modification
**Triggers**:
- Role change or promotion
- Project assignment change
- Business need change
- Incident-related suspension

**Procedure**:
- Request submitted by line manager
- ISMS Lead approval required for elevated privileges
- Changes documented in user access register
- User notified of changes
- Previous access revoked if no longer needed

#### 3.1.3 User De-registration
**Triggers**:
- Employment/contract termination
- Extended leave (>30 days)
- Prolonged inactivity
- Security incident

**Procedure** (Immediate actions):
1. Disable all user accounts (AWS IAM, application, database)
2. Revoke MFA devices and access tokens
3. Retrieve company equipment (laptops, phones, access cards)
4. Change shared passwords/credentials user had access to
5. Remove from email distribution lists and shared drives
6. Document access removal in user access register
7. Review user's recent access logs for anomalies

**Timeline**:
- Termination: All access revoked within 1 hour of notification
- Extended leave: Access suspended on last working day
- Return from leave: Access restored upon verification

---

## 4. AWS Cloud Access Management

### 4.1 AWS IAM User Accounts
- **IAM users**: Limited to named individuals only (no shared accounts)
- **Root account**: Secured with MFA; used only for emergency account recovery
- **Naming convention**: firstname.lastname@epact.co.uk
- **Console access**: Requires MFA (virtual or hardware token)
- **Programmatic access**: Uses temporary credentials via AWS STS when possible

### 4.2 AWS IAM Roles
- **EC2 instance roles**: Defined in Terraform; follow least privilege
- **Lambda execution roles**: Scoped to specific resources (e.g., s3:::multi-tenant-app-tenant-*)
- **Cross-account roles**: Only if required; with external ID for security
- **Service-linked roles**: AWS-managed; reviewed for appropriateness

### 4.3 AWS Access Levels
| **Level** | **Who** | **Permissions** | **MFA Required** |
|-----------|---------|----------------|------------------|
| **Read-Only** | Support team | View resources, logs, metrics | Yes |
| **Developer** | Development team | Manage development environment resources | Yes |
| **Power User** | Senior Developer | Manage staging resources; read production | Yes |
| **Administrator** | Managing Director, ISMS Lead | Full access to all resources | Yes (Hardware token) |

### 4.4 Terraform State Access
- **State bucket**: Access restricted to Terraform execution role and administrators
- **Encryption**: KMS key `alias/terraform-state-key`
- **Versioning**: Enabled for rollback capability
- **DynamoDB locking**: Prevents concurrent modifications
- **Access logging**: CloudTrail tracks all state file access

---

## 5. Password Policy

### 5.1 Password Requirements
- **Minimum length**: 14 characters
- **Complexity**: Must include uppercase, lowercase, numbers, and special characters
- **No dictionary words**: Avoid common words or patterns
- **No personal information**: No names, birthdays, company name
- **Unique passwords**: Different for each system
- **Password managers**: Approved and encouraged (1Password, Bitwarden, AWS Secrets Manager)

### 5.2 Password Lifecycle
- **Initial passwords**: Temporary; must be changed on first login
- **Password age**: Maximum 90 days for privileged accounts; 180 days for standard accounts
- **Password history**: Cannot reuse last 12 passwords
- **Forgotten passwords**: Self-service reset via MFA; or contact Support team
- **Locked accounts**: Auto-lock after 5 failed login attempts; 30-minute lockout

### 5.3 Password Storage
- **Never store** passwords in plain text
- **Application passwords**: Stored in AWS Secrets Manager with rotation
- **Infrastructure secrets**: Terraform variables (sensitive=true); never in Git
- **Database credentials**: AWS Secrets Manager with automatic rotation (future enhancement)
- **API keys**: Rotated every 90 days

### 5.4 Password Sharing
- **Prohibited**: Password sharing is strictly forbidden
- **Shared accounts**: Not permitted except approved service accounts
- **Service accounts**: Managed by ISMS Lead; credentials stored in AWS Secrets Manager
- **Emergency access**: Break-glass procedures documented; access logged and reviewed

---

## 6. Multi-Factor Authentication (MFA)

### 6.1 MFA Requirements
**Mandatory MFA** for:
- All AWS console access
- Production system access (RDS, EC2 via SSM)
- Terraform state bucket access
- VPN access to internal network
- Email accounts
- Code repository access (GitHub, GitLab)

**MFA Methods** (in order of preference):
1. Hardware security keys (YubiKey, Titan Security Key)
2. Authenticator apps (Google Authenticator, Microsoft Authenticator, Authy)
3. SMS-based OTP (only if no other option available; not for admin access)

### 6.2 MFA Management
- **Enrollment**: Mandatory during account creation
- **Backup codes**: Provided and securely stored
- **Lost MFA device**: Emergency access via ISMS Lead; device revoked immediately
- **MFA device recovery**: Identity verification required
- **Device registration**: Limited to company-approved devices

---

## 7. Privileged Access Management

### 7.1 Administrative Accounts
- **Separate admin accounts**: Different from standard user accounts
- **Naming convention**: admin.firstname.lastname
- **Enhanced MFA**: Hardware tokens required (not software)
- **Access logging**: All admin actions logged to CloudTrail
- **Session recording**: AWS CloudTrail tracks all API calls
- **Just-in-Time (JIT) access**: Temporary elevation using AWS STS assumed roles (where possible)

### 7.2 AWS Root Account
- **Usage**: Emergency account recovery only
- **Protection**:
  - Hardware MFA device
  - Credentials stored in physical safe
  - No access keys created
  - Email address monitored 24/7
  - Account activity alarms via CloudWatch
- **Access logging**: All root account usage requires incident report

### 7.3 Database Administrator (DBA) Access
- **RDS master credentials**: Stored in AWS Secrets Manager
- **Access method**: IAM database authentication preferred; temporary credentials via STS
- **Audit logging**: All database queries logged; sensitive queries reviewed
- **Production access**: Requires approval; logged and time-limited

### 7.4 SSH/Systems Access
- **SSM Session Manager**: Preferred method for EC2 access (no SSH keys)
- **SSH keys**: Prohibited in production; only in development with justification
- **Bastion hosts**: Not deployed (SSM Session Manager replaces)
- **Session logging**: All terminal sessions logged to CloudWatch

---

## 8. Access Review and Recertification

### 8.1 Quarterly Access Reviews
**Process**:
1. ISMS Lead generates access reports from AWS IAM, application systems
2. Line managers review team member access lists
3. Confirm each access is still required with business justification
4. Identify and remove orphaned accounts, unused permissions
5. Document review findings and actions taken
6. Report summary to Managing Director

**Review Checklist**:
- AWS IAM users and roles
- Application user accounts
- Database user accounts
- VPN access
- Shared drives and collaboration tools
- Privileged access and admin accounts

### 8.2 Annual Comprehensive Review
- Full audit of all user accounts across all systems
- Review of access control policy effectiveness
- Assessment of control implementation
- Recommendations for improvement

---

## 9. Network and System Access Control

### 9.1 Network Segmentation
- **Public subnets**: ALB and NAT gateways only
- **Private subnets**: Application servers (EC2) and databases (RDS)
- **Security groups**: Whitelist approach; deny by default
- **NACLs**: Additional subnet-level controls (future enhancement)
- **VPC Flow Logs**: All network traffic logged for 90 days

### 9.2 Firewall Rules
**ALB Security Group**:
- Inbound: Port 443 (HTTPS) and 80 (HTTP redirect) from 0.0.0.0/0
- Outbound: All traffic

**Application Security Group**:
- Inbound: Ports 80/443 from ALB security group only
- Inbound: Port 22 (SSH) from internal VPC only (10.0.0.0/16)
- Outbound: All traffic

**RDS Security Group**:
- Inbound: Port 3306 from application security group only
- Outbound: None required

### 9.3 Remote Access
- **VPN required**: For access to internal systems from external networks
- **MFA enforced**: On VPN connections
- **Approved VPN clients**: [Specify company-approved VPN solution]
- **Split tunneling**: Prohibited; all traffic via VPN
- **VPN logging**: Connection logs retained for 90 days

---

## 10. Application Access Control

### 10.1 Multi-Tenant Isolation
- **Tenant ID verification**: Every request validated
- **Database-level isolation**: Row-level security by tenant_id
- **Storage isolation**: Per-tenant S3 buckets (multi-tenant-app-tenant-{tenant_id})
- **API authentication**: JWT or OAuth 2.0 with tenant claim
- **Authorization**: Role-based permissions within tenant context

### 10.2 Application Authentication
- **Minimum password**: 12 characters for end users
- **MFA**: Recommended for tenant administrators
- **Session timeout**: 30 minutes of inactivity
- **Concurrent sessions**: Limited to 3 per user
- **Failed login protection**: Account lock after 5 attempts

### 10.3 API Access
- **API keys**: Rotated every 90 days
- **Rate limiting**: Enforced via AWS WAF (2000 requests per IP per 5 minutes)
- **OAuth tokens**: Short-lived (1 hour); refresh tokens rotated
- **IP whitelisting**: For high-privilege API operations

---

## 11. Data Access Controls

### 11.1 Data Classification-Based Access
| **Classification** | **Access Requirements** |
|-------------------|------------------------|
| **RESTRICTED** | MFA required; CloudTrail logging; need-to-know basis; ISMS Lead approval |
| **CONFIDENTIAL** | Employee/contractor access only; business justification required |
| **INTERNAL** | Employee access; standard authentication |
| **PUBLIC** | No access restrictions |

### 11.2 Production Data Access
- **Production database**: Read access requires approval; write access restricted to application only
- **Sensitive data masking**: PII masked in non-production environments
- **Data export**: Requires approval; logged and audited
- **Backup access**: Restoration requires change management approval

---

## 12. Access Monitoring and Logging

### 12.1 Access Logging Requirements
**All access attempts logged**:
- Successful and failed login attempts
- Privileged operations (sudo, admin panels)
- Data exports or bulk downloads
- Configuration changes
- Access to RESTRICTED data

**Log Details**:
- Timestamp (UTC)
- User identity
- Source IP address
- Action performed
- Resource accessed
- Result (success/failure)

### 12.2 AWS Access Logging
- **CloudTrail**: All API calls logged (90-day retention minimum)
- **VPC Flow Logs**: Network connections logged (365-day lifecycle)
- **RDS audit logs**: Database queries logged (slow query log enabled)
- **S3 access logs**: Bucket access logged for tenant buckets
- **CloudWatch**: Application logs retained for 90 days

### 12.3 Log Review
- **Automated monitoring**: CloudWatch alarms for suspicious patterns
- **GuardDuty**: Real-time threat detection
- **Security Hub**: Compliance findings reviewed weekly
- **Manual review**: Privileged access logs reviewed monthly
- **Incident investigation**: Logs preserved for 365 days for forensics

---

## 13. Account Management

### 13.1 Account Types

#### 13.1.1 Individual User Accounts
- Assigned to specific person
- Never shared between individuals
- Disabled immediately upon termination
- Reviewed quarterly for activity

#### 13.1.2 Service Accounts
- Used by applications and automated processes
- Managed by ISMS Lead
- Credentials stored in AWS Secrets Manager
- Documented in service account register
- Reviewed quarterly

#### 13.1.3 Emergency/Break-Glass Accounts
- Used only during emergency when standard access unavailable
- Credentials sealed in physical envelope; stored securely
- Usage triggers automatic incident report
- Password changed immediately after use
- Requires Managing Director notification within 24 hours

### 13.2 Account Naming Standards
**AWS IAM Users**: firstname.lastname  
**Admin Accounts**: admin.firstname.lastname  
**Service Accounts**: svc-{service-name} (e.g., svc-tenant-provisioner)  
**Terraform Execution**: terraform-ci-cd  
**Application Users**: Tenant-specific; follows application schema

---

## 14. AWS IAM Policy Standards

### 14.1 IAM Policy Design
- **Explicit deny**: Takes precedence over allow
- **Least privilege**: Start with no permissions; add as needed
- **Conditions**: Use condition keys (IP address, MFA, time) where applicable
- **Resource scoping**: Limit to specific ARNs (e.g., arn:aws:s3:::multi-tenant-app-tenant-*)
- **No wildcards**: Avoid * in resource ARNs unless absolutely necessary

### 14.2 Example IAM Policies (from Infrastructure)
**EC2 Application Instance Role**:
```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:ListBucket"],
  "Resource": ["arn:aws:s3:::multi-tenant-app-deploy/*"]
}
```

**Tenant Provisioner Lambda**:
```json
{
  "Effect": "Allow",
  "Action": ["s3:CreateBucket", "s3:PutBucket*"],
  "Resource": "arn:aws:s3:::multi-tenant-app-tenant-*"
}
```

### 14.3 Prohibited IAM Practices
- ❌ Creating access keys for root account
- ❌ Embedding access keys in application code or version control
- ❌ Sharing IAM user credentials between people
- ❌ Using long-lived credentials when temporary credentials available
- ❌ Granting AdministratorAccess policy without justification

---

## 15. Role-Based Access Control (RBAC)

### 15.1 Defined Roles

#### 15.1.1 Managing Director
**Access Level**: Full Administrator  
**AWS IAM**: AdministratorAccess (MFA required)  
**Responsibilities**: Ultimate accountability; approves policy changes; emergency access  
**Review Frequency**: Annually

#### 15.1.2 ISMS Lead (Akam Rahimi)
**Access Level**: Security Administrator  
**AWS IAM**: Security audit and management permissions  
**Responsibilities**: Policy management; incident response; access approvals; compliance monitoring  
**Review Frequency**: Quarterly

#### 15.1.3 Senior Developer
**Access Level**: Power User  
**AWS IAM**: EC2, RDS, S3, Lambda read/write (dev/staging); read-only production  
**Responsibilities**: Infrastructure development; code review; deployment to non-production  
**Review Frequency**: Quarterly

#### 15.1.4 Developer
**Access Level**: Developer  
**AWS IAM**: Limited EC2, S3, Lambda in development environment only  
**Responsibilities**: Code development; testing; documentation  
**Review Frequency**: Quarterly

#### 15.1.5 Support Team
**Access Level**: Support User  
**AWS IAM**: CloudWatch read; application logs; monitoring dashboards  
**Responsibilities**: Monitor alerts; respond to incidents; user support  
**Review Frequency**: Quarterly

#### 15.1.6 Business Development Director
**Access Level**: Business User  
**AWS IAM**: CloudWatch dashboards (read-only); no infrastructure access  
**Responsibilities**: Customer engagement; business reporting  
**Review Frequency**: Annually

---

## 16. Third-Party and External Access

### 16.1 Contractor Access
- **Background checks**: Required for contractors with system access
- **Time-limited**: Access expires on contract end date
- **Segregation**: Separate IAM accounts from employees
- **Monitoring**: Contractor activity logged and reviewed monthly
- **NDA required**: Before granting any system access

### 16.2 Vendor/Supplier Access
- **Minimize access**: Only when absolutely necessary
- **Escorted access**: Vendor actions supervised by EPACT employee
- **Temporary credentials**: Short-lived (maximum 8 hours)
- **Activity logging**: All vendor actions logged and reviewed
- **Access revocation**: Immediate upon completion of work

### 16.3 Customer Access
- **Tenant isolation**: Customers access only their tenant data
- **Authentication**: Customer-managed authentication methods
- **Authorization**: Enforced by application logic and database RLS
- **Audit logs**: Customer access available via tenant dashboard

---

## 17. Segregation of Duties

### 17.1 Critical Operations Requiring Separation
| **Operation** | **Role 1** | **Role 2** |
|--------------|-----------|-----------|
| Terraform infrastructure changes | Developer (code) | Senior Developer or ISMS Lead (approval/apply) |
| AWS IAM policy changes | Request from team member | ISMS Lead approval |
| Production deployments | Senior Developer (initiate) | ISMS Lead (approve) |
| Backup restoration | Support team (request) | ISMS Lead (authorize and execute) |
| Security incident response | Incident detector | ISMS Lead (investigation and remediation) |

### 17.2 Enforcement
- Technical controls via AWS IAM policies
- Terraform state locking prevents concurrent changes
- Pull request reviews required before merging infrastructure code
- Change management system tracks approvals

---

## 18. Monitoring and Alerting

### 18.1 Access Anomaly Detection
**CloudWatch Alarms** configured for:
- Console login without MFA
- Root account usage
- Failed login attempts (>5 in 15 minutes)
- Access from unusual geographic locations
- API calls from unknown IP addresses
- IAM policy changes
- Security group modifications

### 18.2 GuardDuty Findings
- **High/Critical findings**: Immediate SNS alert to ISMS Lead
- **Medium findings**: Daily digest to Support team
- **Low findings**: Weekly review
- **Automated response**: Lambda functions for common threats (future)

### 18.3 Access Reports
- **Daily**: Failed login attempts summary
- **Weekly**: New user accounts and permissions changes
- **Monthly**: Privileged access usage report
- **Quarterly**: Comprehensive access review for recertification

---

## 19. Access Control Exceptions

### 19.1 Exception Process
1. Written request with business justification
2. Risk assessment by ISMS Lead
3. Compensating controls identified
4. Managing Director approval required
5. Exception documented with expiry date
6. Regular review (maximum 6-month validity)

### 19.2 Temporary Access Elevation
- Request via ticketing system
- Time-limited (maximum 72 hours)
- MFA required
- Activity logged and reviewed
- Automatic revocation after expiry

---

## 20. Compliance and Enforcement

### 20.1 Policy Compliance
- All access requests must follow this policy
- Exceptions require documented approval
- Non-compliance reported to ISMS Lead
- Repeat violations escalated to Managing Director

### 20.2 Violations and Consequences
| **Violation** | **First Offense** | **Repeat Offense** |
|--------------|------------------|-------------------|
| Password sharing | Written warning | Suspension or termination |
| Unauthorized access attempt | Written warning; access review | Termination |
| Granting unauthorized access | Suspension of privileges | Termination |
| Bypassing access controls | Immediate suspension | Termination; potential legal action |

---

## 21. Related Policies and Documents

- Information Security Policy (Master Policy)
- Acceptable Use Policy
- Remote Working Policy
- Human Resources Security Policy
- Operations Security Policy
- IAM Matrix (docs/iam-matrix.csv)
- Terraform Infrastructure Documentation (docs/readme.md)

---

## 22. Policy Acknowledgment

I acknowledge that I have read, understood, and agree to comply with this Access Control Policy.

**Employee/Contractor Name**: ________________________________  
**Signature**: ________________________________  
**Date**: ________________________________

---

## 23. Management Approval

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

