# Change Request Form

**EPACT LTD** - Infrastructure and System Change Request

---

## Change Identification

**Change ID**: CHG-YYYY-NNN *(Assigned by Change Manager)*  
**Request Date**: ________________________________  
**Requested By**: ________________________________  
**Email**: ________________________________  
**Department/Team**: ________________________________

---

## Change Classification

**Change Type** *(Select one)*:
- ☐ **Emergency** - System outage or active security incident (verbal approval; document post-change)
- ☐ **Major** - Significant infrastructure changes; new services; schema changes (CAB approval required)
- ☐ **Standard** - Application updates; minor config changes (Senior Developer approval)
- ☐ **Normal** - Routine changes; automated deployments (CI/CD approval)

**Change Category**:
- ☐ Infrastructure (Terraform, AWS services)
- ☐ Application (code deployment)
- ☐ Database (schema, configuration)
- ☐ Security (IAM, security groups, WAF)
- ☐ Network (VPC, subnets, routing)
- ☐ Monitoring (CloudWatch, alarms)
- ☐ Other: ________________________________

---

## Change Details

### What is Changing?

**Summary** *(One sentence)*:

________________________________________________________________

**Detailed Description**:

________________________________________________________________
________________________________________________________________
________________________________________________________________

**Systems/Resources Affected** *(Be specific)*:
- AWS Resources: ________________________________
- Terraform files: ________________________________
- Application components: ________________________________
- Databases: ________________________________
- Other: ________________________________

### Why is This Change Needed?

**Business Justification**:

________________________________________________________________
________________________________________________________________

**Benefits**:
- ________________________________________________________________
- ________________________________________________________________

**Consequences if NOT Implemented**:

________________________________________________________________

---

## Impact Analysis

### Risk Assessment

**Change Risk Level**:
- ☐ **High** - Could cause outage; affects all customers; complex rollback
- ☐ **Medium** - Potential service degradation; affects some customers; rollback available
- ☐ **Low** - Minimal impact; internal only; easily reversible

**Security Impact**:
- ☐ Improves security posture
- ☐ No security impact
- ☐ Potential security implications (explain): ________________________________

**Customer Impact**:
- ☐ No customer impact (internal change)
- ☐ Minor - Some customers may notice (performance change)
- ☐ Moderate - Service degradation possible
- ☐ Significant - Requires customer notification (downtime/functionality change)

**Estimated Affected Customers**: ________________________________ *(Number or percentage)*

### Dependencies

**Systems that depend on this change**:

________________________________________________________________

**Changes that must happen first** *(Prerequisites)*:

________________________________________________________________

**Changes that should follow** *(Sequencing)*:

________________________________________________________________

---

## Implementation Plan

### Proposed Implementation

**Implementation Date/Time (UTC)**: ________________________________  
**Implementation Window**: Start: _____________ End: _____________  
**Estimated Duration**: ________________________________

**Implementation Steps** *(Detailed procedure)*:

1. ________________________________________________________________
2. ________________________________________________________________
3. ________________________________________________________________
4. ________________________________________________________________
5. ________________________________________________________________

**For Terraform Changes, attach**:
- ☐ Terraform plan output (`terraform plan -out=tfplan`)
- ☐ Git branch/PR link: ________________________________
- ☐ Peer review completed: ☐ Yes ☐ No
- ☐ Tested in staging: ☐ Yes ☐ No ☐ N/A

### Pre-Change Actions
**Before implementation** *(Checklist)*:
- ☐ Backup created (RDS snapshot, Terraform state backup, etc.)
- ☐ Stakeholders notified (customers if needed; change window communicated)
- ☐ Implementation procedure documented and reviewed
- ☐ Rollback procedure tested
- ☐ Monitoring enhanced (extra CloudWatch alarms if needed)
- ☐ Change window communicated to customers (if applicable)
- ☐ On-call team alerted (Support team, ISMS Lead)
- ☐ Emergency contacts confirmed
- ☐ Approval obtained (see below)

### Post-Change Actions
**After implementation** *(Checklist)*:
- ☐ Verify change successful (functional testing)
- ☐ Monitor for issues (minimum 2 hours; 24 hours for major changes)
- ☐ Update documentation (README, architecture diagrams)
- ☐ Communicate completion to stakeholders
- ☐ Close change request
- ☐ Lessons learned documented (if issues occurred)

---

## Rollback Plan

**Is Rollback Possible?** ☐ Yes ☐ No ☐ Partial

**If YES, Rollback Procedure**:

1. ________________________________________________________________
2. ________________________________________________________________
3. ________________________________________________________________

**Rollback Time Estimate**: ________________________________

**Rollback Decision Criteria** *(When to roll back)*:
- ________________________________________________________________
- ________________________________________________________________

**If NO rollback possible, Mitigation Plan**:

________________________________________________________________
________________________________________________________________

---

## Testing

**Testing Environment**: ☐ Development ☐ Staging ☐ N/A (emergency)

**Test Results**:
- ☐ Tests passed successfully
- ☐ Tests failed (explain): ________________________________
- ☐ Not tested (emergency change; test post-implementation)

**Test Evidence**: *(Attach test reports, screenshots)*

________________________________________________________________

---

## Communication Plan

### Stakeholder Notification

**Customers Require Notification?** ☐ Yes ☐ No

**If YES**:
- Notification method: ☐ Email ☐ Status page ☐ In-app
- Notification timing: ☐ 7 days prior ☐ 48 hours prior ☐ 24 hours prior
- Downtime expected: ☐ None ☐ ________ minutes ☐ ________ hours

**Internal Notification**:
- ☐ All staff (company-wide change)
- ☐ Development team only
- ☐ Support team (monitoring required)
- ☐ Management (awareness)

### Status Updates
**During Change**:
- Update frequency: Every ________ minutes/hours
- Communication channel: ☐ Slack #changes ☐ Email ☐ Status page
- Key stakeholders: ________________________________

---

## Approvals

### Technical Review
**Reviewed By**: ________________________________ *(Senior Developer)*  
**Review Date**: ________________________________  
**Technical Approval**: ☐ Approved ☐ Approved with conditions ☐ Rejected  
**Comments**: ________________________________________________________________

**Signature**: ________________________________

### Security Review (for infrastructure/security changes)
**Reviewed By**: Akam Rahimi *(ISMS Lead)*  
**Review Date**: ________________________________  
**Security Approval**: ☐ Approved ☐ Approved with conditions ☐ Rejected  
**Security Comments**: ________________________________________________________________

**Signature**: ________________________________

### Change Authority Approval

**For EMERGENCY Changes**:
**Verbal Approval By**: ________________________________ *(ISMS Lead or Managing Director)*  
**Date/Time**: ________________________________  
**Documented By**: ________________________________  
**Post-Implementation Approval**: ________________________________ *(Within 24 hours)*

**For MAJOR Changes**:
**Managing Director Approval**: Akam Rahimi  
**Approval Date**: ________________________________  
**Signature**: ________________________________

**For STANDARD Changes**:
**Senior Developer Approval**: ________________________________  
**Approval Date**: ________________________________  
**Signature**: ________________________________

**For NORMAL Changes**:
**Automated Approval**: ☐ CI/CD pipeline tests passed  
**Approval Date/Time**: ________________________________

---

## Implementation Record

**Implemented By**: ________________________________  
**Implementation Date/Time (UTC)**: ________________________________  
**Actual Duration**: ________________________________ *(vs. estimated: _________)*

**Implementation Notes** *(Issues encountered, deviations from plan)*:

________________________________________________________________
________________________________________________________________

**Implementation Successful?** ☐ Yes ☐ Partial ☐ No

**If NO or Partial**:
**Rollback Performed?** ☐ Yes ☐ No  
**Rollback Date/Time**: ________________________________  
**Rollback Successful?** ☐ Yes ☐ No

---

## Post-Implementation Review

**Monitoring Period**: ________________________________ *(Typically 2-24 hours)*

**Issues Detected?** ☐ No ☐ Yes (describe): ________________________________________________________________

**Performance Impact**:
- Response time: ☐ Improved ☐ No change ☐ Degraded
- Error rate: ☐ Decreased ☐ No change ☐ Increased
- Customer complaints: ☐ None ☐ Minor ☐ Significant

**Verification Checklist**:
- ☐ Functional testing passed
- ☐ Performance within acceptable range
- ☐ No increase in error rates
- ☐ Security controls operational
- ☐ Monitoring and alerting functional
- ☐ Backup jobs running successfully
- ☐ Documentation updated

**Change Successful?** ☐ Yes ☐ Yes with issues ☐ No (rolled back)

---

## Lessons Learned

**What Went Well**:

________________________________________________________________

**What Could Be Improved**:

________________________________________________________________

**Follow-Up Actions**:

| Action | Owner | Due Date |
|--------|-------|----------|
| | | |
| | | |

---

## Change Closure

**Change Status**: ☐ Implemented Successfully ☐ Rolled Back ☐ Partially Implemented ☐ Cancelled

**Closure Date**: ________________________________  
**Closed By**: ________________________________ *(Change Manager or ISMS Lead)*  
**Signature**: ________________________________

**Total Change Duration**: ________________________________ *(From request to closure)*

---

## Related Documents
- Terraform plan output (attach)
- Test reports (attach)
- Customer notifications (attach)
- Rollback documentation (if performed)
- Post-implementation review (if issues)

---

**File Location**: /policies/change-requests/CHG-YYYY-NNN.pdf  
**Retention**: 3 years (audit and compliance requirements)

---

**CONFIDENTIAL - Internal Use Only**

