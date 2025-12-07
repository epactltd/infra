# Security Incident Report Form

**EPACT LTD** - Information Security Incident Report

---

## Incident Identification

**Incident ID**: INC-YYYY-NNN *(Assigned by ISMS Lead)*  
**Report Date/Time (UTC)**: ________________________________  
**Reported By**: ________________________________  
**Reporter Email**: ________________________________  
**Reporter Phone**: ________________________________  

---

## Incident Classification

**Incident Title**: ________________________________________________________________

**Severity** *(Select one)*:
- ☐ **P1 - Critical** (Complete outage; confirmed data breach; active attack)
- ☐ **P2 - High** (Significant degradation; potential breach; malware detected)
- ☐ **P3 - Medium** (Limited impact; policy violation; unsuccessful attack)
- ☐ **P4 - Low** (Minimal impact; suspicious activity; near-miss)

**Incident Category** *(Select one or more)*:
- ☐ Unauthorized Access
- ☐ Data Breach / Data Loss
- ☐ Malware / Ransomware
- ☐ DDoS Attack
- ☐ Phishing / Social Engineering
- ☐ Insider Threat
- ☐ System Outage / Availability
- ☐ Configuration Error
- ☐ Policy Violation
- ☐ Physical Security
- ☐ Third-Party / Supplier Incident
- ☐ Other: ________________________________

---

## Incident Details

### What Happened?
**Brief Description** (2-3 sentences):

________________________________________________________________
________________________________________________________________
________________________________________________________________

**Detailed Description**:

________________________________________________________________
________________________________________________________________
________________________________________________________________
________________________________________________________________

### When Did It Happen?
**Incident Occurred** (UTC): ________________________________ *(When event actually happened)*  
**Incident Detected** (UTC): ________________________________ *(When we became aware)*

**How Was It Detected?** *(Select one)*:
- ☐ GuardDuty Alert
- ☐ CloudWatch Alarm
- ☐ Security Hub Finding
- ☐ AWS Config Rule Violation
- ☐ Employee Report
- ☐ Customer Report
- ☐ Log Review
- ☐ Penetration Test Finding
- ☐ External Security Researcher
- ☐ Other: ________________________________

### Where Did It Happen?
**Systems Affected** *(List all)*:
- ☐ AWS Account / IAM
- ☐ EC2 Instances: ________________________________
- ☐ RDS Database
- ☐ S3 Buckets: ________________________________
- ☐ Lambda Functions: ________________________________
- ☐ Application (specify): ________________________________
- ☐ Workstation/Laptop: ________________________________
- ☐ Mobile Device: ________________________________
- ☐ Email System
- ☐ Other: ________________________________

**AWS Resources** *(Specific IDs)*:
- Instance IDs: ________________________________
- Bucket names: ________________________________
- Database identifiers: ________________________________
- ARNs: ________________________________

### Who Was Affected?
**Users Affected**:
- ☐ No users affected
- ☐ Internal staff only *(Number: _______)*
- ☐ Customers/tenants *(Number: _______)*
- ☐ All users

**Data Affected**: ☐ Yes ☐ No

**If Yes, Data Classification**:
- ☐ PUBLIC
- ☐ INTERNAL
- ☐ CONFIDENTIAL
- ☐ RESTRICTED

**Personal Data Involved**: ☐ Yes ☐ No *(If yes, complete GDPR Breach Assessment Form)*

**Estimated Data Volume**:
- Records affected: ________________________________
- Files affected: ________________________________
- Data size: ________________________________

---

## Impact Assessment

### Confidentiality Impact
**Was sensitive data disclosed?** ☐ Yes ☐ No ☐ Unknown

**If Yes**:
- What data: ________________________________
- To whom: ________________________________
- How many records: ________________________________

### Integrity Impact
**Was data modified or corrupted?** ☐ Yes ☐ No ☐ Unknown

**If Yes**:
- What data: ________________________________
- Extent of modifications: ________________________________

### Availability Impact
**Were services unavailable or degraded?** ☐ Yes ☐ No

**If Yes**:
- Which services: ________________________________
- Duration: ________________________________
- Customer impact: ☐ None ☐ Minor ☐ Moderate ☐ Severe

### Business Impact
- **Financial**: £ ________________________________ *(estimated direct costs)*
- **Reputational**: ☐ None ☐ Minor ☐ Moderate ☐ Severe
- **Regulatory**: ☐ None ☐ Reportable to ICO ☐ Other regulators: ________________
- **Legal**: ☐ None ☐ Potential breach of contract ☐ Potential legal action
- **Customer**: Number of customers affected: ________________________________

---

## Initial Response Actions Taken

**Immediate Actions** *(List everything done within first 30 minutes)*:

1. ________________________________________________________________
2. ________________________________________________________________
3. ________________________________________________________________
4. ________________________________________________________________

**Evidence Preserved** *(Check all that apply)*:
- ☐ CloudTrail logs exported
- ☐ CloudWatch logs exported
- ☐ EC2 snapshots created
- ☐ RDS snapshots created
- ☐ Screenshots taken
- ☐ VPC Flow Logs saved
- ☐ GuardDuty findings exported
- ☐ Email headers saved
- ☐ Other: ________________________________

**Evidence Location**: ________________________________________________________________

---

## Incident Response Team

**IRT Activated?** ☐ Yes ☐ No

**If Yes, IRT Members Notified**:
- ☐ Incident Manager (ISMS Lead): Akam Rahimi
- ☐ Technical Lead (Senior Developer): ________________________________
- ☐ Communications Lead (Business Dev Director): ________________________________
- ☐ Support Lead: ________________________________
- ☐ Legal Counsel (if needed): ________________________________

**Incident Communication Channel**: ________________________________ *(Slack #incident-YYYY-NNN)*

**Managing Director Notified?** ☐ Yes (Date/Time: __________) ☐ No ☐ N/A (low severity)

---

## Containment Actions

**Short-Term Containment** *(Stop the bleeding)*:

________________________________________________________________
________________________________________________________________
________________________________________________________________

**Systems Isolated?** ☐ Yes ☐ No  
**Accounts Disabled?** ☐ Yes ☐ No  
**IP Addresses Blocked?** ☐ Yes ☐ No  
**Credentials Rotated?** ☐ Yes ☐ No

**Long-Term Containment** *(Maintain business operations)*:

________________________________________________________________
________________________________________________________________

---

## Investigation Findings

**Root Cause Analysis**:

________________________________________________________________
________________________________________________________________
________________________________________________________________

**Attack Vector / How It Happened**:

________________________________________________________________
________________________________________________________________

**Timeline of Events**:

| Time (UTC) | Event |
|------------|-------|
| | |
| | |
| | |

**Indicators of Compromise (IOCs)**:
- IP Addresses: ________________________________
- File Hashes: ________________________________
- Domains: ________________________________
- User Agents: ________________________________

---

## Eradication and Recovery

**Eradication Actions** *(Remove the threat)*:

________________________________________________________________
________________________________________________________________

**Recovery Actions** *(Restore normal operations)*:

________________________________________________________________
________________________________________________________________

**Recovery Verification**:
- ☐ Systems restored and operational
- ☐ Data integrity verified
- ☐ Security controls operational
- ☐ Monitoring and logging functional
- ☐ No residual malicious activity detected

**Recovery Completion Date/Time (UTC)**: ________________________________

---

## Communication

### Internal Communication
**Status Updates Sent?** ☐ Yes ☐ No  
**All Staff Notified?** ☐ Yes ☐ No ☐ N/A  
**Frequency**: Every ________ hours

### Customer Communication
**Customers Notified?** ☐ Yes ☐ No ☐ N/A (no customer impact)  
**Notification Date/Time**: ________________________________  
**Notification Method**: ☐ Email ☐ Status Page ☐ Phone ☐ In-App  
**Number of Customers Notified**: ________________________________  
**Follow-up Communication Sent?** ☐ Yes ☐ No

### Regulatory Notification
**ICO Notification Required?** ☐ Yes ☐ No ☐ Under Assessment  
**ICO Notification Date**: ________________________________ *(Must be within 72 hours of awareness)*  
**ICO Reference Number**: ________________________________

**Other Regulatory Notifications**:
- ☐ None required
- ☐ FCA: ________________________________
- ☐ Other: ________________________________

---

## Metrics

**Mean Time to Detect (MTTD)**: ________ *(Time from incident occurrence to detection)*  
**Mean Time to Respond (MTTR)**: ________ *(Time from detection to initial response)*  
**Mean Time to Recover (MTTR)**: ________ *(Time from detection to full recovery)*  
**Total Incident Duration**: ________ *(From occurrence to resolution)*

---

## Lessons Learned

### What Worked Well?

________________________________________________________________
________________________________________________________________

### What Could Be Improved?

________________________________________________________________
________________________________________________________________

### Action Items for Improvement

| Action | Owner | Due Date | Status |
|--------|-------|----------|--------|
| | | | |
| | | | |
| | | | |

### Policy/Procedure Updates Required

________________________________________________________________
________________________________________________________________

### Training Recommendations

________________________________________________________________
________________________________________________________________

---

## Post-Incident Review

**Post-Incident Review Meeting Date**: ________________________________  
**Attendees**: ________________________________________________________________

**Review Findings**: *(Attach detailed post-incident review report)*

________________________________________________________________
________________________________________________________________

**Corrective Actions**: *(Assigned and tracked in action log)*

________________________________________________________________
________________________________________________________________

---

## Approvals and Sign-Off

**Incident Report Prepared By**:  
Name: ________________________________  
Position: ________________________________  
Date: ________________________________  
Signature: ________________________________

**Reviewed and Approved By** (ISMS Lead):  
Name: Akam Rahimi  
Position: ISMS Lead  
Date: ________________________________  
Signature: ________________________________

**Final Approval** (Managing Director for P1/P2):  
Name: Akam Rahimi  
Position: Managing Director  
Date: ________________________________  
Signature: ________________________________

---

**Incident Status**: ☐ Open ☐ Closed ☐ Under Investigation

**Incident Closure Date**: ________________________________

**Related Documents**:
- Evidence Files: ________________________________
- GDPR Breach Assessment: BR-YYYY-NNN (if applicable)
- Customer Communications: ________________________________
- ICO Submission: ________________________________
- Post-Incident Review Report: ________________________________

---

**CONFIDENTIAL - Internal Use Only**

*File Location*: /policies/incident-reports/INC-YYYY-NNN-incident-report.pdf  
*Retention*: 12 months after closure (minimum); longer if legal or audit requirements

