# Mobile Device and Teleworking Policy

**EPACT LTD** | Company Registration: 11977631

## Document Control
| Version | 1.0 | Owner | ISMS Lead |
|---------|-----|-------|-----------|
| **ISO 27001 Ref** | A.6.7, A.8.9 | **Approved** | Akam Rahimi |

---

## 1. Purpose

Define security requirements for mobile devices and teleworking to protect EPACT and customer information.

---

## 2. Mobile Device Policy

### 2.1 Company-Owned Mobile Devices
**Devices Provided**:
- Mobile phones (for MFA and business calls)
- Tablets (if role requires)

**Security Requirements**:
- **Device encryption**: Full device encryption enabled (iOS, Android)
- **Screen lock**: Password/PIN/biometric (6+ digit PIN minimum)
- **Auto-lock**: 2 minutes of inactivity
- **OS updates**: Automatic updates enabled; monthly manual check
- **Remote wipe**: Enabled (Find My iPhone, Android Device Manager)
- **MFA app**: Installed (Google Authenticator, Microsoft Authenticator)

**Acceptable Use**:
- Primary: Business calls, MFA, business email, calendar
- Secondary: Reasonable personal use (calls, messages)
- Prohibited: Installing non-approved apps; jailbreaking/rooting

**Lost/Stolen Procedure**:
1. Report to ISMS Lead immediately
2. Remote wipe initiated
3. Police report (if stolen)
4. Replacement device issued
5. Incident investigation

### 2.2 Personal Mobile Devices (BYOD)
**Limited Permitted Use**:
- MFA apps (Authenticator)
- Email (webmail or approved mobile email app)
- Calendar access
- Messaging (Slack, Teams mobile apps)

**Prohibited on Personal Devices**:
- VPN or AWS console access
- Accessing RESTRICTED data
- Downloading confidential files
- Production system administration
- Storing company data long-term

**Security Requirements** (if permitted):
- Device encryption enabled
- Screen lock (PIN/password/biometric)
- OS updates current
- Remote wipe capability and consent
- No jailbreak/root

**Personal Device Lost/Stolen**:
- Report to ISMS Lead
- Remote wipe company data (if MDM capability)
- Password resets for accounts accessed from device
- Assess if RESTRICTED data compromised (GDPR breach assessment)

---

## 3. Mobile Device Management (MDM)

### 3.1 MDM Solution
**If deployed** (future consideration):
- Enforce device security policies (encryption, screen lock, updates)
- Remote wipe capability
- App whitelisting/blacklisting
- Detect jailbroken/rooted devices
- Separate company and personal data (containerization)

### 3.2 Enrollment
- Mandatory for company-owned devices accessing company email or data
- Optional for personal devices (BYOD program participants)
- Consent required (employee acknowledges remote wipe capability)

---

## 4. Application Security

### 4.1 Approved Mobile Apps
**Company-Approved** (installed by IT or self-service approved apps):
- Email client (native or approved: Outlook, Gmail)
- MFA app (Google Authenticator, Microsoft Authenticator, Authy)
- Messaging (Slack, Microsoft Teams, WhatsApp Business)
- Productivity (Google Workspace apps, Office 365 apps)
- VPN client (for remote access)

### 4.2 Prohibited Mobile Apps
- File-sharing apps (personal Dropbox, WeTransfer)
- Unapproved remote access apps
- Apps from untrusted sources (sideloading)
- Apps with known security vulnerabilities
- Apps requiring excessive permissions (access to all contacts, files, etc.)

### 4.3 App Updates
- Automatic app updates enabled
- Manual updates monthly (check for critical security updates)

---

## 5. Public WiFi and Travel Security

### 5.1 Public WiFi Restrictions
**Prohibited without VPN**:
- Accessing company email or systems
- Accessing CONFIDENTIAL or RESTRICTED data
- Production work
- Entering passwords

**Acceptable with VPN**:
- General web browsing
- Checking email (via VPN)
- Accessing cloud applications

**Preferred Alternative**: Personal mobile hotspot (4G/5G tethering)

### 5.2 Travel Security
**Before Travel**:
- Update devices (OS and apps)
- Backup important data
- Enable Find My Device / tracking
- Review destination security risks (high-risk countries: extra precautions)

**During Travel**:
- Keep devices in carry-on luggage (never checked baggage)
- Use hotel safe for devices when not in room
- Privacy screen for laptop in public (airports, planes, trains)
- No sensitive work on airplane WiFi (untrusted network)
- Charge devices using own charger (avoid public USB charging stations - "juice jacking" risk)

**After Travel (High-Risk Destinations)**:
- Report travel to ISMS Lead
- Consider malware scan on devices
- Password changes if compromise suspected

### 5.3 International Travel
**Additional Considerations**:
- **Border searches**: Devices may be searched by customs (minimize sensitive data on device)
- **Legal obligations**: Some countries require disclosure of passwords
- **Data sovereignty**: Some countries prohibit encryption
- **Strategy**: Use travel device (minimal data); access company systems via VPN and cloud

**High-Risk Countries**:
- Consult ISMS Lead before travel
- Use temporary device (wiped after return)
- No production access from high-risk locations
- Enhanced monitoring of accounts during/after travel

---

## 6. Bluetooth and Wireless

### 6.1 Bluetooth
- **Disable when not in use**: Reduces attack surface
- **Pairing**: Only with trusted devices
- **Public places**: Disable or non-discoverable mode
- **Bluetooth keyboards/mice**: Acceptable (consider wired for sensitive work)

### 6.2 NFC and Wireless Payments
- Allowed for personal use
- Corporate cards: Contact company for policy

---

## 7. Physical Security of Mobile Devices

### 7.1 Theft Prevention
- Keep devices in sight or secured (cable lock in semi-public areas)
- Do not leave in unattended vehicles
- Minimize visible branding (company stickers advertise value)
- Mark devices with "If found, contact: [phone]" (not company name)

### 7.2 Secure Disposal
**Before returning/disposing** device:
- Backup necessary data (iCloud, company systems)
- Sign out of all accounts (iCloud, Google, company)
- Factory reset device (Settings → Erase All Content)
- Verify data erased (attempt recovery)
- Physical destruction for devices with RESTRICTED data (hard drive shredding)

---

## 8. Teleworking Security

**See also**: Remote Working Policy (comprehensive)

### 8.1 Teleworking Definition
Working outside company office:
- Home office (primary)
- Client sites
- Co-working spaces
- Hotels (business travel)

### 8.2 Security Requirements
- Company laptop (encrypted, managed)
- VPN for internal systems
- MFA for authentication
- Secure workspace (private, locked when unattended)
- Clean desk policy
- No shoulder surfing (screen privacy)

---

## 9. Compliance and Monitoring

### 9.1 Device Inventory
- Company-owned devices registered in asset register
- Personal devices (BYOD): Registered if accessing company data

### 9.2 Compliance Checks
- Annual security review (device encryption, updates, screen lock)
- Random spot checks (proportionate and privacy-respecting)
- Non-compliance addressed through coaching or disciplinary process

### 9.3 Audit Evidence
- Device inventory (company-owned and BYOD register)
- MDM enrollment records (if deployed)
- Lost/stolen device incident reports
- Remote wipe logs
- Policy acknowledgments

---

## 10. User Responsibilities

**Users must**:
- Protect mobile devices from theft and loss
- Report lost/stolen devices immediately
- Keep devices updated (OS and apps)
- Use strong screen lock passwords/PINs
- Not jailbreak/root devices
- Comply with all security requirements

**Users must not**:
- Share device with others (family, friends)
- Install unauthorized apps
- Disable security features (encryption, firewall, antivirus)
- Access RESTRICTED data on personal devices (unless BYOD approved)
- Use public WiFi without VPN for company work

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

