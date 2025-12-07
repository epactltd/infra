# System Acquisition, Development and Maintenance Policy

**EPACT LTD** | Company Registration: 11977631

## Document Control
| Version | 1.0 | Owner | Senior Developer |
|---------|-----|-------|------------------|
| **ISO 27001 Ref** | A.8.25-A.8.32 | **Approved** | Akam Rahimi |

---

## 1. Secure Development Lifecycle (SDLC)

### 1.1 Development Phases
1. **Requirements**: Security requirements defined (authentication, encryption, access control)
2. **Design**: Threat modeling, privacy by design, security architecture review
3. **Development**: Secure coding standards, code review, SAST scanning
4. **Testing**: Security testing, DAST scanning, penetration testing
5. **Deployment**: Secure deployment pipeline, production hardening
6. **Maintenance**: Vulnerability monitoring, patching, updates

### 1.2 Security Requirements
**Every new feature/system**:
- Authentication and authorization requirements
- Data encryption (at rest and in transit)
- Input validation and output encoding
- Error handling (no sensitive data in errors)
- Logging and monitoring
- Data retention and deletion
- Privacy impact assessment (if personal data)

---

## 2. Secure Coding Standards

### 2.1 OWASP Top 10 Awareness
**Mandatory mitigations**:
1. **Broken Access Control**: Enforce authorization checks; tenant_id validation
2. **Cryptographic Failures**: Use TLS, encrypt sensitive data, proper key management
3. **Injection**: Parameterized queries, input validation, ORM usage
4. **Insecure Design**: Threat modeling, security patterns
5. **Security Misconfiguration**: Secure defaults, hardening, least privilege
6. **Vulnerable Components**: Dependency scanning, keep up-to-date
7. **Authentication Failures**: MFA, password policies, session management
8. **Software and Data Integrity**: Code signing, SRI hashes, supply chain security
9. **Logging Failures**: Comprehensive logging, monitoring, alerting
10. **SSRF**: Validate URLs, whitelist domains, network isolation

### 2.2 Code Review
**Mandatory** for all production code:
- Peer review (another developer)
- Pull request (PR) in Git (GitHub/GitLab)
- Security checklist reviewed
- Senior Developer approval for infrastructure changes (Terraform)
- ISMS Lead approval for security-critical changes

**Security Focus Areas**:
- Authentication and authorization logic
- Data validation (especially user input)
- Cryptography usage
- Error handling (no information leakage)
- Third-party library usage (check for vulnerabilities)
- Secrets management (no hardcoded credentials)

### 2.3 Static Analysis Security Testing (SAST)
**Automated scanning**:
- Python: Bandit, Semgrep
- JavaScript: ESLint with security plugins
- Terraform: Checkov, tfsec, terraform validate
- Pre-commit hooks: Run scanners before commit
- CI/CD pipeline: Fail build on high-severity findings

---

## 3. Testing and Quality Assurance

### 3.1 Security Testing Types
**Unit Testing**: Test security functions (authentication, authorization, encryption)

**Integration Testing**: Test security across components (API authentication, database access)

**Dynamic Application Security Testing (DAST)**:
- OWASP ZAP or Burp Suite
- Test running application
- Identify runtime vulnerabilities
- Quarterly for production application

**Penetration Testing**:
- Annual external penetration test
- AWS notification (some services require pre-approval)
- Scope: Application and infrastructure
- Findings remediated per vulnerability management policy

### 3.2 Test Data Management
**Prohibited**: Production personal data in test environments

**Allowed**:
- Synthetic test data (generated)
- Anonymized data (PII removed)
- Pseudonymized data (hashed identifiers)

**Procedure**:
- Test data generation scripts (no manual scraping of production)
- Test data classified as INTERNAL
- Test data deleted after testing (within 30 days max)

---

## 4. Development Environments

### 4.1 Environment Separation
**See**: Operations Security Policy Section 3

- **Development**: Individual developer workstations + shared dev AWS account
- **Staging**: Pre-production testing (mirrors production config)
- **Production**: Live customer services

**Controls**:
- No production data in development
- Separate AWS accounts (or VPCs minimum)
- Different credentials for each environment
- Network isolation (security groups)

### 4.2 Developer Workstations
**Security Requirements**:
- Full disk encryption (FileVault, BitLocker)
- Screen lock (2-minute timeout)
- Endpoint protection (antivirus, EDR)
- Automatic updates enabled
- VPN for company system access
- No RESTRICTED data stored locally

---

## 5. Version Control and Source Code Management

### 5.1 Git Repository Security
- **Private repositories**: All company code
- **Access control**: Authenticated developers only
- **Branch protection**: Main branch requires PR and approval
- **Commit signing**: GPG signatures recommended for Terraform
- **Secret scanning**: Automated detection of credentials in code (git-secrets, GitHub secret scanning)

### 5.2 Prohibited in Version Control
- ❌ Passwords, API keys, credentials
- ❌ Private keys (SSH, TLS)
- ❌ Customer data or PII
- ❌ Large binaries (use Git LFS or artifact storage)

**Use instead**:
- Environment variables (injected at runtime)
- AWS Secrets Manager references
- Terraform variables (sensitive = true)
- .gitignore for sensitive files

### 5.3 Code Repository Backup
- Git provider (GitHub/GitLab) provides backup
- Local clones serve as distributed backup
- Critical repos: Mirrored to secondary location (future)

---

## 6. Infrastructure-as-Code (Terraform)

### 6.1 Terraform Security Standards
- **Modules**: Reusable, tested modules
- **State**: Remote state (S3) with encryption and locking
- **Secrets**: Never in .tf files; use variables with `sensitive = true`
- **Version control**: All Terraform code in Git
- **Review**: Peer review required for all changes
- **Testing**: `terraform plan` reviewed before apply
- **Validation**: `terraform validate` in CI/CD pipeline

### 6.2 Terraform Scanning
```bash
# Pre-commit checks
terraform fmt -check -recursive
terraform validate
checkov --directory .
tfsec .
```

### 6.3 Terraform Change Workflow
See Operations Security Policy Section 2.3

---

## 7. Third-Party Libraries and Dependencies

### 7.1 Dependency Management
**Package Managers**:
- Python: pip, requirements.txt (pinned versions)
- JavaScript: npm, package-lock.json
- Terraform: module versions pinned

**Security**:
- Automated vulnerability scanning (Dependabot, Snyk, npm audit)
- Regular updates (monthly review; immediate for critical CVEs)
- License compliance checked (automated in CI/CD)

### 7.2 Approval Process
**New dependencies**:
1. Developer identifies need for library
2. Evaluate alternatives (functionality, security, maintenance)
3. Review license compatibility
4. Check vulnerability history (CVE database)
5. Test in development
6. Senior Developer approval
7. Add to dependency manifest (requirements.txt, package.json)
8. Document decision (README or architecture docs)

---

## 8. Deployment Security

### 8.1 Deployment Pipeline
**CI/CD Pipeline** (future enhancement):
```
Git Push → Build → Test → SAST/DAST → Staging Deploy → Manual Approval → Production Deploy
```

**Current Manual Deployment**:
1. Code merged to main branch
2. Terraform apply (infrastructure changes)
3. Application build (on EC2 or external CI)
4. Deployment to EC2 via user-data or deployment script
5. Health checks verification
6. Smoke tests
7. Monitoring for issues (24-hour observation period)

### 8.2 Production Deployment Controls
- **Change management**: Approval required
- **Deployment window**: During business hours (or planned maintenance)
- **Rollback plan**: Documented and tested
- **Monitoring**: Enhanced monitoring during and after deployment
- **Approval**: ISMS Lead for infrastructure; Senior Developer for application

---

## 9. Security in System Acquisition

### 9.1 New System Evaluation
**Before purchasing/adopting** new system:
- Security requirements defined
- Vendor security assessment (questionnaire)
- Privacy impact assessment (if personal data)
- Compliance verification (ISO 27001, GDPR)
- TCO analysis (including security controls cost)
- Trial/proof-of-concept in non-production
- Final approval by Managing Director

### 9.2 SaaS Security Assessment
**Minimum requirements**:
- Data encryption (at rest and in transit)
- Access controls (SSO, MFA support)
- Audit logging
- Data portability (export capability)
- GDPR compliance (DPA available)
- Security certifications (ISO 27001, SOC 2)
- Incident response capability
- Business continuity plan

---

## 10. Compliance

### 10.1 Secure Development Evidence
- Secure coding guidelines document
- Code review records (pull requests with approvals)
- SAST/DAST scan reports
- Penetration test reports
- Vulnerability remediation tracking
- Training records (secure coding training)

---

**Approved by**: Akam Rahimi, Managing Director  
**Date**: ________________________________

**END OF POLICY**

