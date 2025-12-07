# Remote Working Policy

**EPACT LTD** | Company Registration: 11977631

## Document Control
| Version | 1.0 | Owner | Managing Director |
|---------|-----|-------|-------------------|
| **ISO 27001 Ref** | A.6.7 | **Approved** | Akam Rahimi |

---

## 1. Purpose

Define security requirements for employees working remotely to protect company and customer information.

---

## 2. Remote Work Locations

### 2.1 Approved Locations
- **Home office**: Primary remote work location
- **Client sites**: With customer permission and security review
- **Co-working spaces**: Professional spaces with security measures
- **Hotels**: For business travel; limited to essential work

### 2.2 Prohibited Locations
- Public areas with sensitive work (cafes for RESTRICTED data access)
- Locations with security risks (unattended, unsecured)
- Non-secure networks for production access

---

## 3. Equipment Security

### 3.1 Company-Provided Equipment
**Standard Issue**:
- Encrypted laptop (FileVault/BitLocker)
- Mobile phone (for MFA and communication)
- Hardware MFA token (for administrators)

**Security Requirements**:
- Full disk encryption verified
- Screen lock: 2-minute timeout
- Automatic updates enabled
- Endpoint protection installed
- VPN client configured
- Company-managed (MDM if applicable)

### 3.2 Personal Device Use (BYOD)
**Limited use** for:
- Email access (via web browser)
- MFA (authenticator app)
- Communication (Slack, Teams)

**Prohibited on Personal Devices**:
- Accessing RESTRICTED data
- Downloading company files
- Production system administration
- Storing company data

**Requirements if Allowed**:
- Device encryption
- Screen lock
- Antivirus/security software
- Agreement signed (BYOD policy)
- Right to wipe company data remotely

---

## 4. Network Security

### 4.1 Home Network
**Requirements**:
- Router password changed from default
- WPA2/WPA3 encryption
- Firmware updates applied
- Guest network for visitors (isolated from work devices)

**Recommendations**:
- Strong WiFi password (minimum 16 characters)
- Disable WPS
- Change default SSID
- Router admin interface accessible only from LAN

### 4.2 VPN Usage
**Mandatory** for:
- Accessing internal systems
- Production infrastructure (AWS console, database)
- Terraform state bucket access
- Confidential file access

**VPN Configuration**:
- Company-approved VPN client
- MFA required for connection
- All traffic routed through VPN (no split tunneling)
- Auto-reconnect if connection drops

### 4.3 Public WiFi
**If necessary** (business travel):
- VPN required before accessing any company system
- HTTPS-only websites
- No production work or RESTRICTED data access
- Personal hotspot preferred over public WiFi

---

## 5. Physical Security

### 5.1 Workspace Security
- **Private workspace**: Avoid working in view of others (shoulder surfing)
- **Secure storage**: Lock laptop and documents when not in use
- **Clean desk**: No confidential documents left visible
- **Screen privacy**: Privacy filter for laptop in public areas

### 5.2 Device Security
- Never leave devices unattended (cafes, airports, cars)
- Lock screen when leaving device
- Cable lock for laptop in semi-public areas
- Keep devices in sight during travel

### 5.3 Visitor Access
**If family/visitors in home office**:
- Lock screen before leaving desk
- No viewing of confidential information by visitors
- No use of company devices by family members
- Headphones for confidential calls

---

## 6. Data Handling

### 6.1 Remote Data Access
**Cloud-First**:
- Access data via cloud services (AWS, SaaS applications)
- No local storage of RESTRICTED data
- Sync folders: Disabled for confidential data

**Local Storage**:
- INTERNAL data: Permitted on encrypted laptop
- CONFIDENTIAL data: Case-by-case approval; encrypted; deleted after use
- RESTRICTED data: Prohibited on local devices

### 6.2 Printing
- Minimize printing (digital-first)
- Home printer: Acceptable for INTERNAL documents only
- CONFIDENTIAL/RESTRICTED: Office printer only or no printing
- Secure disposal: Home shredder or bring to office for shredding

### 6.3 Video Conferencing
- Use company-approved tools (Zoom, Teams, Google Meet)
- Mute when not speaking
- Background blur/virtual background (hide home office details)
- Screen sharing: Be careful not to show confidential data in background windows
- Record meetings: Only with participant consent; delete after 30 days

---

## 7. Communication Security

### 7.1 Phone/Video Calls
- **Confidential discussions**: Private location; not in public
- **Customer calls**: Professional setting; minimal background noise
- **Secure calls**: End-to-end encrypted apps for highly sensitive (Signal, WhatsApp)

### 7.2 Email and Messaging
- Company email account only (no personal email for company business)
- No confidential information in SMS (use encrypted messaging)
- Slack/Teams: Acceptable for INTERNAL and CONFIDENTIAL
- RESTRICTED data: Secure channels only (encrypted file share, VPN)

---

## 8. Incident Reporting from Remote Locations

### 8.1 Security Incidents
**Report immediately** to ISMS Lead (akam@epact.co.uk):
- Lost or stolen devices
- Suspected malware
- Phishing emails
- Unauthorized access attempts
- Accidental data disclosure (email to wrong person)
- Device compromise suspected

### 8.2 Lost/Stolen Device Procedure
1. Report to ISMS Lead immediately (phone call)
2. ISMS Lead remotely wipes device (if capability available)
3. AWS access revoked (IAM user disabled)
4. Application passwords reset
5. Police report filed (for theft)
6. Assess data breach (if RESTRICTED data on device)
7. Customer notification (if required by GDPR)
8. Incident report completed

---

## 9. Ergonomics and Wellbeing

### 9.1 Home Office Setup
- Ergonomic chair and desk (expenses reimbursed per company policy)
- Proper lighting
- Minimizing distractions
- Regular breaks (every hour)

### 9.2 Work-Life Balance
- Defined work hours (no expectation of 24/7 availability except on-call)
- Right to disconnect outside work hours
- Respecting time zones for distributed teams

---

## 10. Compliance and Monitoring

### 10.1 Acceptable Monitoring
**Employees informed** that remote work may involve:
- System access logging (CloudTrail, application logs)
- Network traffic monitoring (VPN logs)
- Email scanning (malware and phishing detection)
- Productivity tracking (optional; with transparency)

**Privacy Balance**:
- Monitoring focused on security, not surveillance
- Personal privacy respected
- No covert monitoring
- Data minimization (only necessary monitoring data collected)

### 10.2 Audit and Compliance
- Remote work security self-assessment (annual)
- Random security checks (device encryption verification)
- Compliance with policy acknowledged annually

---

## 11. Related Documents
- Acceptable Use Policy
- Access Control Policy
- Mobile Device and Teleworking Policy
- Human Resources Security Policy

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

