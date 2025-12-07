# Physical and Environmental Security Policy

**EPACT LTD** | Company Registration: 11977631  
International House, 36-38 Cornhill, London, England, EC3V 3NG

## Document Control
| Version | 1.0 | Owner | Managing Director |
|---------|-----|-------|-------------------|
| **ISO 27001 Ref** | A.7.1-A.7.4, A.7.7-A.7.14 | **Approved** | Akam Rahimi |

---

## 1. Purpose

Protect physical assets and prevent unauthorized physical access to information and information processing facilities.

---

## 2. Physical Security Perimeter

### 2.1 Office Premises (If Applicable)
**Registered Address**: International House, 36-38 Cornhill, London, England, EC3V 3NG

**Security Measures**:
- Building access control (key card, reception)
- Visitor sign-in and escort
- CCTV monitoring (if building provides)
- Secure document storage (locked cabinets)
- Clean desk policy enforced

**Visitor Management**:
- Visitors signed in at reception
- Visitor badge worn
- Escorted by EPACT employee at all times
- No unsupervised access to secure areas
- NDA required for visitors viewing confidential information
- Visitor log maintained (name, company, purpose, time in/out)

### 2.2 Home Offices (Remote Work)
**See**: Remote Working Policy

**Requirements**:
- Private workspace (separate from family areas if possible)
- Lockable door or secure location for devices
- Devices not visible from windows
- No confidential work in view of visitors/family
- Secure WiFi (WPA2/WPA3 encryption)

---

## 3. AWS Physical Security (Shared Responsibility)

### 3.1 AWS Responsibility
**AWS Data Centers** (eu-west-2 London region):
- Physical security perimeter (fencing, guards, cameras)
- Environmental controls (cooling, power, fire suppression)
- Access controls (biometric, badge, mantrap)
- 24/7 monitoring
- Redundant power and network
- Disaster recovery capabilities

**AWS Compliance**:
- ISO 27001 certified data centers
- SOC 2 Type II reports available
- Physical security audited by third parties
- Compliance reports reviewed by EPACT annually

### 3.2 EPACT Responsibility
**EPACT responsible** for:
- Logical access controls (IAM, security groups)
- Data encryption (at rest and in transit)
- Configuration security (Terraform)
- Monitoring and incident response
- Backups and disaster recovery

**Shared Responsibility Model**: Documented and understood by all technical staff

---

## 4. Equipment Security

### 4.1 Laptops and Workstations
**Security Requirements**:
- Full disk encryption (FileVault, BitLocker)
- BIOS/firmware password
- Screen lock (2-minute timeout)
- Laptop cable lock (for office/public work)
- Antivirus/endpoint protection
- Automatic security updates

**Physical Protection**:
- Never leave unattended in public
- Lock in car trunk if must be left in vehicle (not visible)
- Carry in secure laptop bag (not advertising expensive equipment)
- Home: Store in locked room/drawer when not in use

**Theft/Loss**:
- Report immediately to ISMS Lead
- Remote wipe initiated (if capability available)
- Police report filed
- Insurance claim processed
- Asset register updated
- Replacement device issued

### 4.2 Mobile Phones and Tablets
**See**: Mobile Device and Teleworking Policy

**Key Requirements**:
- Screen lock (password/PIN/biometric)
- Encryption enabled
- Remote wipe capability
- Find My Device enabled

### 4.3 Removable Media and Portable Storage
**Policy**: Use discouraged

**If Necessary**:
- Encrypted USB drives only (hardware encryption: IronKey, Kingston)
- Registered in asset register
- Never leave unattended
- Secure disposal when no longer needed (physical destruction)

**Prohibited**:
- Unencrypted USB drives with company data
- Personal USB drives for company data
- Storing RESTRICTED data on removable media

---

## 5. Secure Areas

### 5.1 Definition
Areas containing sensitive information or systems:
- Office (if applicable): Locked when unoccupied
- Server rooms: If on-premises servers (N/A for cloud-only)
- Document storage: Locked filing cabinets
- Home offices: Lockable workspace for RESTRICTED work

### 5.2 Access Control
**Office** (if applicable):
- Key card access or physical keys
- Access log (entry/exit times)
- Keys not shared; report lost keys immediately
- After-hours access: Logged and authorized

**Document Storage**:
- Locked filing cabinets for CONFIDENTIAL/RESTRICTED
- Keys controlled by ISMS Lead
- Access log for RESTRICTED documents

---

## 6. Clear Desk and Clear Screen

**See also**: Asset Management Policy Section 11

### 6.1 Clear Desk
**At end of day** (and when leaving desk unattended):
- Lock away CONFIDENTIAL/RESTRICTED documents
- No passwords written on sticky notes
- Secure waste (shred confidential documents)
- Lock drawers and cabinets

**Enforcement**:
- Quarterly desk audits (if office location)
- Non-compliance addressed through coaching

### 6.2 Clear Screen
- Lock screen when leaving desk (Cmd+Ctrl+Q, Windows+L)
- Automatic screen lock (5 minutes of inactivity)
- Privacy screen for laptops in public
- No confidential information visible to passersby

---

## 7. Equipment Maintenance

### 7.1 Company Equipment
- **Repairs**: Authorized service providers only
- **Before repair**: Data backed up; sensitive data removed
- **Encrypted devices**: Supervise repair or provide decryption (data risk)
- **Return**: Verify data intact; re-enable security settings

### 7.2 Cleaning and Maintenance
- Regular cleaning (keyboards, screens)
- Compressed air for dust (not in data centers; AWS manages)
- No liquids near electronics
- Cable management (trip hazard and tampering prevention)

---

## 8. Disposal of Equipment

**See**: Asset Management Policy Section 6.4

**Summary**:
- Secure data wipe (DoD 5220.22-M) or physical destruction
- Certified WEEE disposal service
- Certificate of destruction obtained and filed
- Asset register updated (status = "Disposed")

---

## 9. Environmental Controls

### 9.1 AWS Data Centers (AWS Responsibility)
- Temperature and humidity control
- Fire suppression systems
- Redundant power (UPS, generators)
- Flood protection
- Earthquake resistance (design)

### 9.2 Home Offices
**Recommendations**:
- Smoke detector in workspace
- Surge protector for electronic equipment
- Avoid placing equipment near water sources
- Proper ventilation for equipment
- Backup power (UPS for desktop; laptop battery for short outages)

### 9.3 Office Premises (If Applicable)
- Temperature control (HVAC)
- Fire alarms and extinguishers
- Emergency evacuation plan
- First aid kit
- Regular safety inspections

---

## 10. Power and Utilities

### 10.1 AWS Infrastructure (AWS Manages)
- Redundant power feeds
- UPS (uninterruptible power supply)
- Backup generators
- Tested regularly per AWS standards

### 10.2 Office/Home
- UPS for critical equipment (desktop workstations)
- Laptops: Battery provides backup power
- Graceful shutdown procedures for power outages
- Data saved regularly (auto-save enabled)

---

## 11. Cabling Security

### 11.1 Network Cables (If Office)
- Secure cabling (prevent tampering)
- Cable conduits for critical connections
- Patch panel security (locked cabinet)
- Label cables for identification

### 11.2 Power Cables
- Cable management (prevent trip hazards)
- No damage or fraying (replace immediately)
- Surge protection for valuable equipment

---

## 12. Off-Site Equipment

### 12.1 Working from Public Locations
**Security Measures**:
- Never leave devices unattended (even briefly)
- Privacy screen for laptop
- Cable lock if working in semi-public (library, co-working)
- VPN mandatory for company system access
- Lock device when stepping away (bathroom, coffee)

### 12.2 Transportation
- Laptop in carry-on luggage (never checked)
- Non-descript laptop bag (does not advertise expensive equipment)
- Avoid working on sensitive data in taxis/Uber (risk of shoulder surfing)
- Hotel: Use room safe; do not leave devices visible

---

## 13. Equipment Delivery and Loading

### 13.1 Receiving Equipment
- Verify sender identity (expected delivery)
- Inspect for tampering
- Scan for malware before use (new devices)
- Register in asset register

### 13.2 Unattended Equipment
- Server delivery (if applicable): Supervised receipt and installation
- No delivery to unmanned locations
- Courier signature required

---

## 14. Supporting Utilities

### 14.1 AWS Infrastructure
**AWS provides** (99.99% uptime SLA):
- Redundant network connectivity
- Redundant power supplies
- Climate control
- Physical security monitoring

**EPACT monitors**:
- AWS Service Health Dashboard (outages)
- CloudWatch metrics (resource health)
- Backup job success (independent of primary systems)

### 14.2 Home Office Utilities
**Essential**:
- Internet connectivity (broadband + mobile hotspot backup)
- Power (mains + laptop battery backup)

**Outage Procedures**:
- Internet outage: Use mobile hotspot; work offline; notify manager if prolonged
- Power outage: Work on laptop battery; save work frequently
- Extended outage: Work from alternative location (office, co-working space)

---

## 15. Compliance

### 15.1 ISO 27001 Physical Security Controls
- A.7.1: Physical security perimeter (AWS + home office security)
- A.7.2: Physical entry controls (AWS managed; office key card)
- A.7.3: Securing offices, rooms and facilities (clean desk, locked storage)
- A.7.4: Physical security monitoring (AWS CCTV; office building security)
- A.7.7: Clear desk and clear screen (daily enforcement)
- A.7.8: Equipment siting and protection (laptop security)
- A.7.9: Security of assets off-premises (remote work, travel)
- A.7.10: Storage media (encrypted USB; secure disposal)
- A.7.11: Supporting utilities (power, network redundancy)
- A.7.12: Cabling security (AWS manages; office minimal cabling)
- A.7.13: Equipment maintenance (authorized service providers)
- A.7.14: Secure disposal of equipment (certified destruction)

### 15.2 Audit Evidence
- AWS compliance certificates (SOC 2, ISO 27001)
- Physical asset register
- Equipment disposal certificates
- Clear desk audit reports (if office location)
- Visitor logs (if office location)
- Lost/stolen device incident reports

---

## 16. Related Documents
- Asset Management Policy
- Remote Working Policy
- Mobile Device and Teleworking Policy
- Operations Security Policy

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

