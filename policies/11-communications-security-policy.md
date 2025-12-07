# Communications Security Policy

**EPACT LTD** | Company Registration: 11977631  
International House, 36-38 Cornhill, London, England, EC3V 3NG

## Document Control
| Version | 1.0 | Owner | Senior Developer |
|---------|-----|-------|------------------|
| **Approved By** | Akam Rahimi | **ISO 27001 Ref** | A.8.20-A.8.24 |
| **Contact** | akam@epact.co.uk | **Review** | Annual |

---

## 1. Network Security

### 1.1 Network Architecture
- **VPC**: 10.0.0.0/16 (AWS eu-west-2)
- **Public subnets**: ALB and NAT gateways only
- **Private subnets**: EC2 application tier and RDS database
- **No direct internet**: Private subnets via NAT gateways
- **Security groups**: Default deny; whitelist only necessary traffic

### 1.2 Network Segmentation
| **Zone** | **Components** | **Access From** | **Access To** |
|---------|---------------|----------------|---------------|
| **Internet** | Users | - | ALB (443, 80) |
| **DMZ (Public)** | ALB, NAT | Internet, Private | Internet, Private |
| **Application (Private)** | EC2 ASG | ALB only | RDS, NAT, S3 |
| **Data (Private)** | RDS | Application tier only | None |

### 1.3 Firewall Rules
**See**: Operations Security Policy Section 13.2 for detailed rules

**Principles**:
- Default deny all traffic
- Explicit allow rules only
- Source restriction (IP/CIDR or security group)
- Documented justification for each rule
- Quarterly review and cleanup

### 1.4 Network Monitoring
- **VPC Flow Logs**: All network traffic logged (365-day retention)
- **GuardDuty**: Network anomaly detection
- **CloudWatch Alarms**: Unusual traffic patterns
- **Review**: Weekly Security Hub findings; monthly flow log analysis

---

## 2. Encryption in Transit

### 2.1 TLS Requirements
**Mandatory TLS 1.2+** for:
- ALB HTTPS listener (ELBSecurityPolicy-TLS-1-2-2017-01)
- Application APIs (all endpoints)
- Database connections (RDS with TLS)
- Email (TLS opportunistic STARTTLS)
- VPN connections (AES-256, IKEv2)

**Enforcement**:
- S3 bucket policies: Deny aws:SecureTransport=false
- HTTP → HTTPS redirect (301) on ALB
- Application redirects HTTP to HTTPS

### 2.2 Certificate Management
- **ACM (AWS Certificate Manager)**: Manages ALB certificates
- **Auto-renewal**: 60 days before expiry
- **Wildcard cert**: *.app_domain
- **Monitoring**: CloudWatch alarm for expiry

---

## 3. Secure Email

### 3.1 Email Protection
- **SPF record**: Configured for domain
- **DKIM signing**: Enabled
- **DMARC policy**: Enforced
- **Spam filtering**: Inbound malware and spam scanning
- **Phishing protection**: User training and technical controls

### 3.2 Sensitive Data via Email
- **RESTRICTED data**: Prohibited via email (use secure file transfer)
- **CONFIDENTIAL data**: Encrypted attachments (password protected; password shared separately)
- **Encryption**: S/MIME or PGP for highly sensitive (optional)

---

## 4. Remote Access

### 4.1 VPN Requirements
- **Mandatory**: VPN for internal system access from external networks
- **MFA**: Required for VPN authentication
- **Protocols**: IKEv2 or OpenVPN (AES-256)
- **Split tunneling**: Prohibited (all traffic via VPN)
- **Logging**: VPN connections logged (90-day retention)

### 4.2 AWS Systems Manager Session Manager
**Preferred method** for EC2 access:
- No SSH keys required
- Browser-based or CLI access
- Fully logged to CloudWatch
- MFA required (AWS console access)
- Session recording available

### 4.3 Prohibited Remote Access
- ❌ Telnet, FTP, or other unencrypted protocols
- ❌ RDP without VPN
- ❌ SSH with password authentication (key-only)
- ❌ Direct RDS access from internet

---

## 5. Information Transfer

### 5.1 Approved Transfer Methods
| **Classification** | **Internal** | **External** |
|-------------------|-------------|-------------|
| **RESTRICTED** | AWS S3 (KMS), Secure file share (MFA) | Encrypted file share (password + MFA) |
| **CONFIDENTIAL** | Email (within company), Shared drives | Email (with NDA), Encrypted attachments |
| **INTERNAL** | Email, Slack | With approval |
| **PUBLIC** | Any method | Any method |

### 5.2 Large File Transfers
- **S3 presigned URLs**: Temporary links (expiry: 1 hour - 7 days)
- **Secure file transfer service**: [Specify if using service]
- **No email attachments**: >10MB (use cloud storage link instead)

---

## 6. Mobile and Wireless Security

### 6.1 Mobile Devices
- Encryption: Full device encryption required
- MFA: Required for company accounts
- Screen lock: Automatic after 2 minutes
- Remote wipe: Capability required (MDM or Find My Device)
- Lost/stolen: Report immediately to ISMS Lead

### 6.2 Wireless Networks
**Office WiFi** (if applicable):
- WPA3 or WPA2-Enterprise
- Unique passwords (no shared WPA2-PSK)
- Guest network: Separate VLAN, internet-only

**Public WiFi**:
- VPN mandatory for company data access
- HTTPS-only websites
- No confidential work on public WiFi without VPN

---

## 7. AWS Network Security

### 7.1 VPC Security Features
- **Flow Logs**: Enabled (S3 storage, KMS encrypted)
- **Network ACLs**: Default allow (security groups primary control)
- **Route tables**: Private subnets via NAT; public via IGW
- **VPC endpoints**: Consider for S3 (future; private connectivity)

### 7.2 WAF Protection
- Associated with ALB
- Managed rule sets: AWS Core Rule Set
- Rate limiting: 2000 req/IP/5min
- Custom rules: Based on attack patterns
- Logging: CloudWatch metrics, sampled requests

### 7.3 DDoS Protection
- AWS Shield Standard (included)
- WAF rate limiting
- Auto Scaling handles traffic spikes
- Consider Shield Advanced for large-scale protection

---

## 8. DNS Security

### 8.1 Route53 Configuration
- **DNSSEC**: Consider enabling (future enhancement)
- **Health checks**: Monitor DNS resolution
- **Access control**: IAM policies restrict Route53 changes
- **Logging**: CloudTrail logs all DNS configuration changes

---

## 9. Compliance

### 9.1 Monitoring
- AWS Config rules for network security
- Security Hub CIS Benchmark findings
- GuardDuty network threat detection
- Monthly network security review

### 9.2 Audit Evidence
- VPC flow logs (365 days)
- CloudTrail (network configuration changes)
- Security group change history
- WAF logs and metrics

---

## 10. Related Documents
- Operations Security Policy
- Access Control Policy
- Remote Working Policy

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

