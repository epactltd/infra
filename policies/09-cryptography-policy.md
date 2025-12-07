# Cryptography Policy

**EPACT LTD**  
Company Registration: 11977631  
International House, 36-38 Cornhill, London, England, EC3V 3NG

---

## Document Control

| **Version** | 1.0 |
|------------|-----|
| **Approved By** | Akam Rahimi, Managing Director |
| **Approval Date** | [TO BE COMPLETED] |
| **Next Review Date** | [12 months from approval] |
| **Owner** | Akam Rahimi, ISMS Lead |
| **ISO 27001 Reference** | A.8.24 |

---

## 1. Purpose

This policy defines cryptographic standards for protecting EPACT's information assets using encryption, hashing, and digital signatures.

---

## 2. Cryptographic Standards

### 2.1 Encryption Algorithms (Approved)

**Symmetric Encryption**:
- **AES-256**: Data at rest (S3, RDS, EBS) - MANDATORY
- **AES-128**: Acceptable for lower classification data
- **ChaCha20-Poly1305**: Acceptable for TLS

**Asymmetric Encryption**:
- **RSA-2048**: Minimum for key exchange and digital signatures
- **RSA-4096**: Recommended for long-term keys
- **ECDSA P-256/384**: Acceptable for certificates
- **Ed25519**: Acceptable for SSH keys

**Prohibited Algorithms**:
- ❌ DES, 3DES, RC4, MD5, SHA-1 (cryptographically broken)
- ❌ RSA-1024 or smaller (insufficient key length)
- ❌ Any custom/proprietary encryption schemes

### 2.2 Hashing Algorithms

**Approved**:
- **SHA-256/384/512**: File integrity, digital signatures
- **Bcrypt**: Password hashing (cost factor ≥12)
- **Argon2**: Password hashing (recommended for new implementations)
- **PBKDF2**: Acceptable with sufficient iterations (≥100,000)

**Prohibited**:
- ❌ MD5, SHA-1 (collision vulnerabilities)
- ❌ Plain SHA-256 for passwords (use Bcrypt/Argon2 with salt)

### 2.3 TLS/SSL Standards

**Minimum TLS Version**: TLS 1.2 (TLS 1.3 preferred)

**ALB SSL Policy**: `ELBSecurityPolicy-TLS-1-2-2017-01` (configured)

**Cipher Suites** (preferred order):
1. TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
2. TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
3. TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384

**Prohibited**:
- ❌ SSLv2, SSLv3, TLS 1.0, TLS 1.1 (known vulnerabilities)
- ❌ Anonymous cipher suites
- ❌ Export-grade ciphers
- ❌ NULL encryption

**Certificate Requirements**:
- Minimum 2048-bit RSA or 256-bit ECDSA
- Valid from trusted CA (Let's Encrypt, DigiCert, AWS ACM)
- Wildcard certificates: Acceptable (*.app_domain)
- Auto-renewal before expiry (ACM manages)
- Monitoring: Expiry alerts 30 days before

---

## 3. Key Management

### 3.1 AWS KMS Key Management

**Customer-Managed Keys** (CMKs):

| **Key** | **Purpose** | **Rotation** | **Deletion Window** |
|---------|-----------|-------------|-------------------|
| `security_kms_key` | Security logs, SNS, ALB logs | Annual (automatic) | 30 days |
| `rds_kms_key` | RDS encryption | Annual (automatic) | 30 days |
| `flow_logs_kms_key` | VPC flow logs | Annual (automatic) | 30 days |
| `terraform-state-key` | Terraform S3 state | Annual (automatic) | 30 days |
| `backup_kms_key` | AWS Backup vault | Annual (automatic) | 30 days |

**Key Policies**:
- Least privilege access (specific IAM roles only)
- No wildcard principals
- CloudTrail logging for all key usage
- Key administrators separate from key users (segregation of duties)

**Key Rotation**:
- **Automatic rotation**: Enabled for all CMKs (AWS manages; old key material retained for decryption)
- **Manual rotation**: If automatic not supported, rotate annually
- **Emergency rotation**: If key compromise suspected (immediate)

### 3.2 Key Lifecycle

**Creation**:
- Business justification documented
- Terraform code defines key
- Peer review and approval
- Deployed via terraform apply
- Key policy enforces least privilege
- Key alias created for easy reference
- Documented in key management register

**Use**:
- Used only for specified purpose (no re-use across services)
- Access logged to CloudTrail
- Regular access reviews (quarterly)

**Rotation**:
- Automatic rotation enabled
- Monitoring for rotation completion
- Old key material available for decryption

**Deletion**:
- Never delete key with active data encrypted
- Schedule deletion (30-day window allows recovery)
- Decrypt and re-encrypt data with new key before deletion
- Monitor for usage during deletion window (alerts if used)
- Document reason for deletion

### 3.3 Key Access Control

**KMS Key Administrators**:
- ISMS Lead (Akam Rahimi)
- Permissions: Create, schedule deletion, modify key policy
- Cannot use key for encryption/decryption (separation)

**KMS Key Users**:
- Service roles (Lambda, EC2, RDS, S3)
- Application-specific permissions only
- Cannot delete or modify keys

**Prohibited**:
- Exporting keys from KMS
- Using same key across unrelated services
- Granting public access to keys

---

## 4. Encryption at Rest

### 4.1 Mandatory Encryption

**All RESTRICTED data** encrypted at rest:

**Amazon S3**:
- Server-side encryption: SSE-KMS with customer-managed key
- Bucket default encryption enabled
- Bucket policies deny unencrypted uploads
- Configuration:
  ```hcl
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.backup.arn
      }
    }
  }
  ```

**Amazon RDS**:
- Storage encryption: KMS with customer-managed key (`rds_kms_key`)
- Backup encryption: Automatic (same key as database)
- Performance Insights encryption: KMS
- Configuration: `storage_encrypted = true`

**Amazon EBS**:
- All volumes encrypted (enforced in launch template)
- Encryption: AES-256 (AWS-managed or KMS)
- Configuration:
  ```hcl
  ebs {
    encrypted             = true
    kms_key_id            = aws_kms_key.ebs.arn  # If CMK desired
    delete_on_termination = true
  }
  ```

**Laptop/Workstation Disks**:
- **macOS**: FileVault 2 encryption (mandatory)
- **Windows**: BitLocker encryption (mandatory)
- **Linux**: LUKS full disk encryption (mandatory)
- Verification: Enforced via endpoint management or manual check

**Backup Data**:
- AWS Backup vault: KMS encrypted (backup_kms_key)
- Terraform state: S3 KMS encrypted (terraform-state-key)

### 4.2 Encryption Exemptions
**Allowed exemptions** (approved by ISMS Lead):
- PUBLIC classified data (no business need)
- Temporary development data (synthetic, non-sensitive)
- Performance-critical systems where encryption overhead unacceptable (document compensating controls)

---

## 5. Encryption in Transit

### 5.1 Mandatory TLS

**All RESTRICTED and CONFIDENTIAL data** transmitted via encrypted channels:

**HTTPS/TLS**:
- ALB: TLS 1.2+ (certificate via ACM)
- Application APIs: HTTPS only (HTTP redirects to HTTPS)
- S3 access: TLS enforced via bucket policy (deny aws:SecureTransport=false)
- Configuration:
  ```hcl
  lb_listener {
    protocol   = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS-1-2-2017-01"
  }
  ```

**Database Connections**:
- RDS: TLS recommended (parameter: `require_secure_transport = ON`)
- Connection strings: Use SSL/TLS parameters
- Verify server certificate

**AWS API Calls**:
- All AWS SDKs and CLI use HTTPS by default
- CloudTrail logs encrypted in transit to S3

**VPN**:
- Remote access to internal systems: VPN with strong encryption (AES-256, IKEv2)
- No split tunneling (all traffic through VPN)

### 5.2 Email Security
- **TLS opportunistic**: Email servers use TLS if available
- **S/MIME or PGP**: For highly sensitive email (optional)
- **Encrypted attachments**: For RESTRICTED data (password-protected, shared out-of-band)

---

## 6. Digital Signatures and Certificates

### 6.1 Code Signing
**Application Code**:
- Git commit signing: Recommended for Terraform and critical application code
- GPG keys for developers
- Verify signatures before deploying to production

**Container Images** (if used):
- Docker Content Trust (image signing)
- Verify signatures before deployment

### 6.2 TLS/SSL Certificates

**AWS Certificate Manager (ACM)**:
- Manages certificates for ALB
- Auto-renewal before expiry
- Wildcard certificate: `*.app_domain`
- DNS validation via Route53 (automatic)

**Certificate Monitoring**:
- CloudWatch alarms for certificates expiring in <30 days
- Monthly manual check of non-ACM certificates

**Certificate Storage**:
- Private keys: Never exported from ACM
- Manual certificates: AWS Secrets Manager (if needed)
- No private keys in Git, email, or unencrypted storage

---

## 7. Cryptographic Key Management Procedures

### 7.1 Key Generation
- **AWS KMS**: Keys generated within FIPS 140-2 Level 2 validated HSMs
- **Application keys**: Use cryptographically secure random number generators
- **Sufficient entropy**: /dev/urandom or equivalent
- **Key strength**: Per Section 2.1 standards

### 7.2 Key Storage

**Production Keys**:
- AWS KMS (preferred): Keys never leave HSM
- AWS Secrets Manager: For application secrets, API keys, DB credentials
- Never in source code, configuration files, or environment variables (in code)

**Development Keys**:
- Separate from production (never use prod keys in dev)
- Stored in development AWS account KMS or Secrets Manager
- Clearly labeled "DEVELOPMENT ONLY"

**Key Material**:
- Asymmetric private keys: AWS KMS or Secrets Manager
- SSH private keys: Encrypted laptop (SSM Session Manager preferred over SSH)
- API tokens: Secrets Manager with auto-rotation

### 7.3 Key Distribution
- Keys distributed via AWS IAM policies (grants access, not key itself)
- Application runtime: Retrieved from Secrets Manager at startup
- Human users: No direct key access (use IAM temporary credentials)

### 7.4 Key Backup and Recovery

**AWS KMS**:
- Keys automatically backed up by AWS (region-wide redundancy)
- Multi-AZ durability
- Cannot export key material (intentional security feature)

**Secrets Manager**:
- Secrets stored redundantly in AWS region
- Versioning enabled
- Recovery: Restore from previous version if needed

**Emergency Key Access**:
- Break-glass procedure for root account access (if all IAM access lost)
- Root account credentials in sealed envelope (physical safe)
- Usage requires incident report

### 7.5 Key Revocation and Destruction

**Revocation Triggers**:
- Key compromise suspected
- Employee termination (access revocation)
- End of key lifetime
- Migration to new key

**Procedure**:
1. Disable key (KMS: schedule deletion; IAM: deactivate)
2. Identify and re-encrypt all data encrypted with key
3. Verify no remaining dependencies
4. Delete key (KMS: 30-day scheduled deletion)
5. Document deletion in key management log

**Key Deletion**:
- **Never immediate**: 30-day window (KMS scheduled deletion)
- **Monitoring**: Alerts if deleted key accessed during window
- **Recovery**: Can cancel deletion within window
- **Permanent**: After window, deletion irreversible

---

## 8. Password Cryptography

### 8.1 Password Storage (Applications)
**Never store passwords in plain text**

**Hashing**:
- Use Bcrypt (cost factor ≥12) or Argon2
- Salt automatically included (per-password unique)
- No shared salts or pepper (rely on strong algorithm)

**Database Storage**:
```sql
-- Example (Laravel framework):
-- Password stored as: $2y$12$[22-character salt][31-character hash]
-- Length: ~60 characters
```

**Verification**: Compare hashed password (timing-attack resistant)

### 8.2 Password Transmission
- **Never via URL parameters**: Use POST body
- **HTTPS only**: All authentication endpoints
- **No logging**: Passwords never logged (even in debug mode)
- **No email**: Password reset links, not passwords themselves

### 8.3 Secrets Management

**AWS Secrets Manager** (preferred):
- RDS database credentials (with auto-rotation)
- API keys and tokens
- Third-party service credentials
- Automatic secret rotation (90-day recommended)
- Access via IAM policies
- Audit logging (CloudTrail)

**Environment Variables**:
- Acceptable for non-sensitive configuration
- Sensitive values: Retrieve from Secrets Manager at runtime
- Never hardcode in application code or Terraform (use variables with `sensitive = true`)

---

## 9. Cryptography in AWS Services

### 9.1 S3 Encryption
**Default Encryption**: SSE-KMS enabled on all buckets

**Bucket Policy Enforcement**:
```json
{
  "Sid": "DenyUnencryptedObjectUploads",
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:PutObject",
  "Resource": "arn:aws:s3:::bucket-name/*",
  "Condition": {
    "StringNotEquals": {
      "s3:x-amz-server-side-encryption": "aws:kms"
    }
  }
}
```

### 9.2 RDS Encryption
- **Storage encryption**: Enabled at creation (cannot enable post-creation)
- **KMS key**: Customer-managed (`rds_kms_key`)
- **Automated backups**: Encrypted with same key
- **Snapshots**: Encrypted copies only
- **Read replicas**: Must be encrypted if master encrypted

### 9.3 EBS Encryption
- **Launch template**: `encrypted = true`
- **All new volumes**: Encrypted automatically
- **Existing volumes**: Encrypt via snapshot and restore (if unencrypted found)

### 9.4 Lambda Environment Variables
- Sensitive variables: Encrypted with KMS
- Access: Only Lambda execution role
- Prefer Secrets Manager over environment variables for secrets

---

## 10. Key Rotation

### 10.1 Rotation Schedule

| **Key Type** | **Rotation Frequency** | **Method** |
|-------------|----------------------|-----------|
| KMS CMKs | Annual | Automatic (AWS managed) |
| Database credentials | 90 days | AWS Secrets Manager rotation (future) |
| API keys | 90 days | Manual rotation with downtime window |
| IAM access keys | 90 days | Rotate via IAM console |
| SSH keys | Annual | Generate new key; revoke old |
| TLS certificates | Before expiry | ACM auto-renewal |

### 10.2 Emergency Rotation
**If key compromise suspected**:
1. Immediate rotation initiated
2. Old key revoked/disabled
3. Systems updated with new key
4. Incident investigation
5. Affected data re-encrypted if necessary

---

## 11. Encryption Monitoring

### 11.1 Compliance Monitoring

**AWS Config Rules**:
- `s3-bucket-server-side-encryption-enabled`
- `rds-storage-encrypted`
- `encrypted-volumes` (EBS)
- `kms-cmk-not-scheduled-for-deletion`

**Security Hub Findings**:
- Unencrypted resources flagged
- Reviewed weekly
- Remediation tracked

### 11.2 CloudTrail Monitoring
**Alerts for**:
- KMS key deletions (scheduled or cancelled)
- KMS key policy changes
- Decryption failures (potential attack or misconfiguration)
- Unusual KMS API call patterns

---

## 12. Quantum-Resistant Cryptography

### 12.1 Future Considerations
- Monitor NIST post-quantum cryptography standards
- Plan migration when standards finalized
- AWS will provide quantum-resistant KMS (future)

### 12.2 Current Approach
- Use maximum key sizes (AES-256, RSA-4096)
- Design for crypto-agility (ability to swap algorithms)

---

## 13. Related Documents

- Information Security Policy
- Access Control Policy
- Operations Security Policy
- AWS KMS Key Management Procedures
- Secrets Management Procedure

---

## 14. Management Approval

**Name**: Akam Rahimi  
**Position**: Managing Director & ISMS Lead  
**Signature**: ________________________________  
**Date**: ________________________________

---

**END OF POLICY**

