# EPACT LTD - Templates

**ISO 27001 & GDPR Compliance Templates**

---

## Overview

This directory contains templates for implementing security and data protection policies. These templates ensure consistent, compliant documentation across EPACT's ISMS operations.

**Owner**: Akam Rahimi, ISMS Lead  
**Contact**: akam@epact.co.uk

---

## Template Index

| Template Name | File | Purpose | Used By | Frequency |
|--------------|------|---------|---------|-----------|
| **DPIA Template** | `dpia-template.md` | Data Protection Impact Assessment for high-risk processing | DPO | As needed for new processing |
| **Risk Treatment Plan** | `risk-treatment-plan-template.md` | Detailed plan for treating identified risks | ISMS Lead | Per medium/high risk |
| **Customer Notifications** | `customer-incident-notification-template.md` | Incident and breach notifications to customers | ISMS Lead, Business Dev | Per customer-affecting incident |
| **Supplier Security Questionnaire** | `supplier-security-questionnaire.md` | Assess supplier security before engagement | ISMS Lead | Per new supplier |

---

## Template Descriptions

### 1. DPIA Template (`dpia-template.md`)

**Purpose**: GDPR Article 35 - Data Protection Impact Assessment

**When Required**:
- New processing likely to result in high risk to individuals
- Large-scale processing of special category data
- Systematic monitoring
- Automated decision-making with legal/significant effects
- New technologies
- Significant changes to existing processing

**Sections**:
1. Processing description (nature, scope, context, purposes)
2. Necessity and proportionality assessment
3. Data subject rights considerations
4. Risk identification (risks to individuals)
5. Measures to address risks (technical and organizational)
6. ICO consultation (if high residual risk)
7. Sign-off and approval (DPO and Managing Director)
8. Review and monitoring plan

**Completion Time**: 2-4 hours (simple processing); 1-2 days (complex)

**Output**: Approved DPIA document filed in /policies/dpias/

**Triggers**:
- New tenant data processing feature
- New analytics or profiling capabilities
- Integration with third-party data processors
- Expansion to new data categories
- Significant infrastructure changes affecting personal data

---

### 2. Risk Treatment Plan Template (`risk-treatment-plan-template.md`)

**Purpose**: Detailed plan for addressing identified information security risks

**When Required**:
- Medium risks (score 5-12) or higher from Risk Register
- Risks requiring mitigation (not simple acceptance)
- New infrastructure or application deployments
- Compliance gaps identified in audits

**Sections**:
1. Risk summary (from risk register)
2. Current risk assessment (inherent and residual)
3. Treatment decision (mitigate/accept/transfer/avoid)
4. Treatment plan (controls, timeline, resources)
5. Implementation tracking
6. Post-implementation review
7. Approvals (ISMS Lead, Managing Director)

**Completion Time**: 1-2 hours (simple); half-day (complex)

**Output**: Approved treatment plan; actions tracked; risk register updated

**Example Uses**:
- Implementing AWS Shield Advanced for DDoS protection
- Multi-region DR deployment for region failure risk
- Enhanced access controls for insider threat risk
- Supplier security improvements

---

### 3. Customer Incident Notification Templates (`customer-incident-notification-template.md`)

**Purpose**: Consistent, professional customer communications during incidents

**Templates Included**:

**Template 1: Initial Incident Notification** (Service Outage)
- Within 2 hours of confirmed customer-affecting incident
- What happened, impact, estimated resolution, next update timing

**Template 2: Service Restoration Notification**
- Immediately upon resolution
- Summary, duration, root cause, verification, next steps

**Template 3: Data Breach Notification** (GDPR Article 34 - High Risk to Individuals)
- If GDPR breach likely to result in high risk
- Clear language, potential consequences, recommended actions, rights information

**Template 4: Data Breach Notification** (Controller to Processor)
- EPACT as processor notifying customer (controller) of breach
- Enables customer to meet their 72-hour ICO obligation

**Template 5: Security Maintenance Notification** (Scheduled Downtime)
- 7 days advance notice
- Maintenance window, impact, recommendations

**Template 6: All-Clear Update**
- 24-48 hours after resolution
- Enhanced monitoring complete, no further issues

**Customization Required**:
- [Bracketed placeholders] replaced with actual details
- Specific times and dates
- Affected services and customer impact
- Contact information

**Approval Process**:
- Templates 1, 2, 5, 6: ISMS Lead approval
- Templates 3, 4: Managing Director + DPO approval

---

### 4. Supplier Security Questionnaire (`supplier-security-questionnaire.md`)

**Purpose**: Standardized security assessment of suppliers before engagement

**When Used**:
- Before engaging new supplier
- Annual review of critical/important suppliers
- If supplier services/risk profile changes significantly
- As part of supplier onboarding process

**Sections**:
1. Supplier information
2. General information security (policies, management)
3. Compliance and certifications (ISO 27001, SOC 2, GDPR)
4. Data protection and privacy (DPO, DPA, data location)
5. Security controls (access, encryption, network)
6. Monitoring and incident response
7. Physical and environmental security
8. Backup and business continuity
9. Vulnerability and patch management
10. Personnel security
11. Third-party and supply chain
12. Audit and transparency
13. Insurance
14. EPACT-specific requirements (AWS, multi-tenancy, data deletion)
15. Security incidents (last 24 months)

**Scoring**: 100-point scale
- 90-100: Excellent
- 75-89: Good
- 60-74: Adequate (with conditions)
- <60: Insufficient (concerns)

**Output**:
- Completed questionnaire (supplier responses)
- EPACT assessment and score
- Recommendation (Approve/Approve with Conditions/Reject)
- Entry in Supplier Register

**Timeline**:
- Send to supplier: 2 weeks to complete
- EPACT assessment: 1 week after receipt
- Managing Director approval: 3 days

---

## Template Usage Guidelines

### General Principles

**Consistency**: Use templates for all similar situations (ensures consistency)

**Customization**: Templates are starting points; customize for specific situations

**Approval**: Obtain required approvals before using (especially customer communications)

**Record Keeping**: Save completed templates (evidence for audits)

**Version Control**: Templates may be updated; use latest version

**Legal Review**: Customer-facing communications reviewed by legal counsel (recommended)

### Quality Control

**Before Using Template**:
1. ☑ Latest version of template used
2. ☑ All [placeholders] customized
3. ☑ Dates and times accurate (UTC and local)
4. ☑ Contact information current
5. ☑ Tone appropriate for situation
6. ☑ Technical accuracy verified
7. ☑ Legal/compliance review (if significant)
8. ☑ Approval obtained
9. ☑ Spell-checked and proofread
10. ☑ Saved in appropriate location

---

## Additional Templates Needed (Future Development)

**Planned Templates**:
- [ ] Internal Audit Plan Template
- [ ] Management Review Meeting Agenda/Minutes Template
- [ ] Security Control Testing Checklist
- [ ] Penetration Test Scope Document Template
- [ ] Supplier DPA (Data Processing Agreement) Template
- [ ] Customer DPA Template
- [ ] Employee Exit Checklist Template
- [ ] New Hire Security Onboarding Checklist
- [ ] Policy Acknowledgment Form (consolidated)
- [ ] Quarterly Access Review Report Template
- [ ] Security Incident Playbooks (specific scenarios)

**To Request New Template**:
- Email ISMS Lead with use case and proposed structure
- ISMS Lead develops or approves template
- Managing Director approves customer-facing templates
- Added to this directory with documentation

---

## Template Maintenance

### Review Schedule
- **Annual review**: All templates reviewed for relevance and accuracy
- **Post-use review**: Feedback after using template (was it helpful?)
- **Triggered review**: After regulatory changes or major incidents

### Version Control
- Templates in Git repository (version history maintained)
- Version number in document header
- Change log in template README or revision history
- Superseded templates archived (not deleted; retained for reference)

### Updates and Changes
1. Identify need for change (feedback, audit finding, regulatory update)
2. Draft updated template
3. Review with stakeholders
4. Approve (ISMS Lead for internal; Managing Director for customer-facing)
5. Replace old version
6. Notify users of template changes
7. Update training materials if significant change

---

## Integration with Forms and Registers

**Templates → Forms → Registers**:

**Example Flow 1 (Incident)**:
1. Incident detected
2. Use **Incident Report Form** (forms/incident-report-form.md)
3. Information entered into **Incident Register** (registers/incident-register.csv)
4. If data breach: Use **GDPR Breach Assessment Form** → **Data Breach Register**
5. If customer notification: Use **Customer Notification Template**

**Example Flow 2 (Risk)**:
1. Risk identified (assessment, incident, audit)
2. Risk entered in **Risk Register**
3. If medium/high risk: Create **Risk Treatment Plan** (this template)
4. Track implementation in risk register
5. Post-implementation: Update risk register with new risk score

**Example Flow 3 (Supplier)**:
1. New supplier proposed
2. Send **Supplier Security Questionnaire** (this template)
3. Assess responses and score
4. If approved: Enter in **Supplier Register**
5. Annual review: Re-send questionnaire; update register

---

## Quality Assurance

### Template Quality Criteria

**Clear Purpose**: Each template has obvious use case and trigger

**Complete**: All necessary sections and fields included

**Compliant**: Meets ISO 27001, GDPR, legal requirements

**Usable**: Can be completed without excessive effort or expertise

**Consistent**: Similar structure and formatting across templates

**Approved**: Formally approved by appropriate authority

**Current**: Reviewed and updated regularly

**Accessible**: Available to those who need them

### Feedback Mechanism

**After using a template**, provide feedback:
- Was template helpful? ☐ Yes ☐ Partially ☐ No
- What worked well? ________________________________
- What was confusing or missing? ________________________________
- Suggestions for improvement? ________________________________

**Send feedback to**: akam@epact.co.uk (ISMS Lead)

---

## Training on Template Usage

### Template Training Included In:

**Annual Security Awareness** (all staff):
- Overview of available templates
- When to use customer notification templates
- How to request DPIA

**Role-Specific Training**:
- **ISMS Lead**: All templates (deep dive)
- **Senior Developer**: Risk treatment, change request, technical templates
- **Support Team**: Incident forms, access request forms
- **Business Development**: Customer communication templates

**New Hire Training**:
- Templates relevant to role
- Where to find templates
- Who to contact for help

---

## Compliance and Audit

### Audit Evidence

**Templates demonstrate**:
- Systematic approach to security management
- Compliance with ISO 27001 requirements
- GDPR accountability principle
- Consistent processes
- Management oversight (approvals)

**Auditors review**:
- Templates themselves (quality, completeness)
- Completed templates (evidence of use)
- Register entries showing templates used
- Approval trails

---

## Related Documents

**Policies**: ../policies/*.md (20 ISO 27001 policies)  
**Forms**: ../forms/*.md (Incident, Access, Change, Disposal forms)  
**Registers**: ../registers/*.csv (Risk, Asset, Incident, etc.)  
**Technical Docs**: ../../docs/ (Infrastructure and procedures)

---

**Document Owner**: Akam Rahimi, ISMS Lead  
**Last Updated**: [Date]  
**Next Review**: [Date + 12 months]

---

**For template support or to request new templates**:  
Email: akam@epact.co.uk

