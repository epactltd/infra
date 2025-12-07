# Access Request Form

**EPACT LTD** - User Access Request

---

## Request Information

**Request ID**: ACC-YYYY-NNN *(Assigned by ISMS Lead)*  
**Request Date**: ________________________________  
**Request Type**:
- ☐ New Access (new hire or new system access)
- ☐ Modify Access (change in role or responsibilities)
- ☐ Temporary Access (time-limited, specific purpose)
- ☐ Remove Access (termination or no longer needed)

---

## User Information

**Full Name**: ________________________________  
**Employee ID**: ________________________________ *(Leave blank for new hires)*  
**Email**: ________________________________  
**Position/Role**: ________________________________  
**Department/Team**: ________________________________  
**Manager/Supervisor**: ________________________________  
**Employment Type**: ☐ Employee ☐ Contractor ☐ Consultant ☐ Temporary Staff  
**Start Date**: ________________________________  
**End Date** *(If contractor or temporary)*: ________________________________

---

## Access Requirements

### System Access Requested

**AWS Access**:
- ☐ AWS Console Access
  - Access Level: ☐ AdministratorAccess ☐ PowerUserAccess ☐ ReadOnlyAccess ☐ Custom (specify): ________________
  - Environments: ☐ Production ☐ Staging ☐ Development
  - MFA Device: ☐ Hardware token ☐ Software authenticator app

**Application Access**:
- ☐ Application Admin Panel
  - Role: ☐ Super Admin ☐ Admin ☐ Developer ☐ Support ☐ Business User ☐ Read-Only
  - Tenants: ☐ All tenants ☐ Specific tenants: ________________________________

**Database Access**:
- ☐ RDS MySQL Database
  - Environment: ☐ Production ☐ Staging ☐ Development
  - Permissions: ☐ Read-Only ☐ Read-Write ☐ DBA (full access)

**VPN Access**:
- ☐ VPN (for internal systems)
  - Purpose: ________________________________

**Other Systems**:
- ☐ Git Repository (GitHub/GitLab): ________________________________
- ☐ Email Account: ________________________________
- ☐ Shared Drives: ________________________________
- ☐ Monitoring Tools (CloudWatch, etc.): ________________________________
- ☐ Other: ________________________________________________________________

### Specific Permissions Needed

**Detailed Access Requirements** *(Be specific)*:

________________________________________________________________
________________________________________________________________
________________________________________________________________

---

## Business Justification

### Why is This Access Needed?

**Business Purpose** *(Required)*:

________________________________________________________________
________________________________________________________________

**Tasks Requiring This Access**:
- ________________________________________________________________
- ________________________________________________________________
- ________________________________________________________________

**Duration of Need**:
- ☐ Permanent (ongoing role requirement)
- ☐ Temporary (specify end date): ________________________________
- ☐ Project-based (project: _______________; estimated end: _____________)

### Data Classification Access

**Will user access RESTRICTED data?** ☐ Yes ☐ No

**If YES**:
- Data types: ________________________________
- Business justification for RESTRICTED access: ________________________________________________________________

**Will user access personal data (GDPR)?** ☐ Yes ☐ No

**If YES**:
- Purpose: ________________________________
- Lawful basis: ☐ Contract ☐ Legitimate interests ☐ Legal obligation ☐ Consent

---

## Security Requirements

### User Obligations (User to acknowledge)

I understand and agree to:
- ☐ Comply with EPACT's Acceptable Use Policy
- ☐ Comply with Access Control Policy
- ☐ Use access only for authorized business purposes
- ☐ Maintain confidentiality of credentials (no sharing)
- ☐ Enable and maintain Multi-Factor Authentication (MFA)
- ☐ Report suspected security incidents immediately
- ☐ Attend required security training
- ☐ Accept that access may be monitored for security/compliance
- ☐ Return all access upon termination or when no longer needed

**User Signature**: ________________________________  
**Date**: ________________________________

### Pre-Access Requirements Completed

**For New Hires / Contractors**:
- ☐ Employment contract signed (includes confidentiality clauses)
- ☐ NDA signed
- ☐ Background check completed *(if required for role)*
- ☐ Security awareness training completed
- ☐ Policy acknowledgments signed (Information Security, Acceptable Use)
- ☐ MFA device provided and enrolled

**For Existing Users** (access modification):
- ☐ Change justified by new role/responsibilities
- ☐ Previous access reviewed (remove what's no longer needed)

---

## Approvals

### Line Manager Approval

**I confirm that this access is necessary for the user to perform their job duties.**

**Manager Name**: ________________________________  
**Manager Email**: ________________________________  
**Manager Signature**: ________________________________  
**Approval Date**: ________________________________

### ISMS Lead Approval (Required for AWS Production, RESTRICTED Data, Privileged Access)

**Security Review**:
- ☐ Access follows least privilege principle
- ☐ Business justification is valid
- ☐ User has completed required training
- ☐ Risk assessed and acceptable
- ☐ Segregation of duties considered

**ISMS Lead Approval**: ☐ Approved ☐ Approved with Conditions ☐ Rejected

**Name**: Akam Rahimi  
**Signature**: ________________________________  
**Date**: ________________________________  

**Conditions / Comments**:

________________________________________________________________

### Managing Director Approval (Required for AdministratorAccess or High-Risk Access)

**Managing Director Approval**: ☐ Approved ☐ Rejected

**Name**: Akam Rahimi  
**Signature**: ________________________________  
**Date**: ________________________________

---

## Access Provisioning

**Provisioned By**: ________________________________ *(Support Team)*  
**Provisioning Date**: ________________________________  
**Provisioning Steps Completed**:
- ☐ AWS IAM user created / permissions modified
- ☐ MFA device enrolled
- ☐ Application account created / role assigned
- ☐ Database user created (if applicable)
- ☐ VPN access enabled
- ☐ Temporary password provided securely (not via email)
- ☐ User access register updated
- ☐ Asset register updated (if new device issued)

**Account Details**:
- AWS IAM Username: ________________________________
- Application Username: ________________________________
- Database Username: ________________________________ *(if applicable)*

**Credentials Provided**: ☐ Temporary password (must change on first login) ☐ SSO ☐ Other

**User Notified**: ☐ Yes (Date: __________) ☐ No

---

## Access Review

**Quarterly Access Review**:

| Review Date | Reviewed By | Still Required? | Action Taken | Next Review |
|------------|------------|----------------|-------------|------------|
| | | ☐ Yes ☐ No | | |
| | | ☐ Yes ☐ No | | |
| | | ☐ Yes ☐ No | | |

**Access Modification History**:

| Date | Change Made | Authorized By | Reason |
|------|------------|---------------|--------|
| | | | |
| | | | |

---

## Access Termination

**Termination Date**: ________________________________  
**Termination Reason**:
- ☐ Employment/contract ended
- ☐ Role change (no longer needed)
- ☐ Temporary access expired
- ☐ Security incident (access revoked)
- ☐ Other: ________________________________

**Access Removal Actions**:
- ☐ AWS IAM user disabled (then deleted after 30 days)
- ☐ Application account disabled
- ☐ Database user removed
- ☐ VPN access revoked
- ☐ MFA device de-registered
- ☐ Group memberships removed
- ☐ Email forwarding configured (if needed for business continuity)
- ☐ Shared credentials rotated (if user had access)
- ☐ Equipment returned (laptop, phone, security tokens)

**Terminated By**: ________________________________  
**Termination Date**: ________________________________  
**Verified By** *(ISMS Lead)*: ________________________________

---

## Change Request Status

**Status**:
- ☐ Submitted (awaiting approval)
- ☐ Approved (awaiting provisioning)
- ☐ Provisioned (active)
- ☐ Rejected (reason: _______________________________)
- ☐ Revoked (access removed)
- ☐ Expired (temporary access ended)

**Notes / Additional Information**:

________________________________________________________________
________________________________________________________________

---

**File Location**: /policies/access-requests/ACC-YYYY-NNN.pdf  
**Retention**: Duration of access + 3 years (audit requirement)

---

**CONFIDENTIAL - HR and IT Use Only**

