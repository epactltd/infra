# Asset Disposal Form

**EPACT LTD** - Secure Asset Disposal Request

---

## Disposal Request

**Disposal ID**: DISP-YYYY-NNN *(Assigned by ISMS Lead)*  
**Request Date**: ________________________________  
**Requested By**: ________________________________  
**Department**: ________________________________

---

## Asset Information

**Asset ID**: ________________________________ *(From asset register)*  
**Asset Type**: ☐ Physical ☐ Cloud ☐ Software ☐ Data ☐ Other

**Asset Name/Description**: ________________________________________________________________

**Serial Number** *(if physical)*: ________________________________  
**AWS Resource ID** *(if cloud)*: ________________________________

**Current Location**:
- ☐ Office
- ☐ Remote (employee home): ________________________________
- ☐ AWS Region: ________________________________
- ☐ Other: ________________________________

**Asset Owner**: ________________________________  
**Asset Custodian**: ________________________________

---

## Classification and Sensitivity

**Asset Classification**:
- ☐ **RESTRICTED** - Highest sensitivity (requires secure destruction)
- ☐ **CONFIDENTIAL** - Business sensitive (requires secure disposal)
- ☐ **INTERNAL** - General business (standard disposal acceptable)
- ☐ **PUBLIC** - No special handling required

**Does Asset Contain or Process**:
- Personal data (GDPR)? ☐ Yes ☐ No
- Customer data? ☐ Yes ☐ No
- Trade secrets or IP? ☐ Yes ☐ No
- Encryption keys or credentials? ☐ Yes ☐ No

**If ANY "Yes" above**: Secure disposal MANDATORY

---

## Reason for Disposal

**Select Primary Reason**:
- ☐ End of life (hardware obsolete or worn out)
- ☐ Replacement (upgraded to new model)
- ☐ No longer needed (project completed business need ended)
- ☐ Damaged beyond repair
- ☐ Security risk (compromised or suspected compromise)
- ☐ Failed audit or compliance issue
- ☐ Other: ________________________________

**Detailed Justification**:

________________________________________________________________
________________________________________________________________

**Replacement Asset** *(if applicable)*: ________________________________

---

## Data Sanitization Plan

### For Physical Assets (Laptops, Phones, USB Drives)

**Data Sanitization Required?** ☐ Yes ☐ No ☐ N/A

**Sanitization Method** *(Select appropriate for classification)*:

**RESTRICTED Data**:
- ☐ 7-pass DoD 5220.22-M secure wipe
- ☐ Physical destruction (hard drive shredding)
- ☐ Degaussing + physical destruction
- ☐ Incineration (extreme cases)

**CONFIDENTIAL Data**:
- ☐ 3-pass secure wipe
- ☐ Factory reset (iOS/Android) + verification
- ☐ Encryption key destruction (if encrypted)

**INTERNAL/PUBLIC**:
- ☐ Standard deletion / format
- ☐ Factory reset

**Sanitization Tool/Method**:

________________________________________________________________

**Performed By**: ________________________________  
**Sanitization Date**: ________________________________  
**Verification Method**: ________________________________  
**Verified By**: ________________________________ *(ISMS Lead for RESTRICTED)*

**Data Sanitization Successful?** ☐ Yes ☐ No ☐ N/A

### For Cloud Assets (AWS Resources)

**Resource Type**:
- ☐ EC2 Instance (EBS volumes)
- ☐ RDS Database
- ☐ S3 Bucket
- ☐ Lambda Function
- ☐ KMS Key
- ☐ Other: ________________________________

**Data Deletion Method**:
- ☐ Terraform destroy (preferred)
- ☐ AWS Console deletion
- ☐ AWS CLI command
- ☐ S3: Delete all object versions before bucket deletion
- ☐ RDS: Final snapshot created, then instance deleted
- ☐ KMS: Scheduled deletion (30-day window)

**Final Snapshots/Backups** *(if applicable)*:
- Snapshot ID: ________________________________
- Retention: ________________________________ days
- Encrypted: ☐ Yes ☐ No

**Deletion Command** *(for audit trail)*:
```bash
# Example:
terraform destroy -target=aws_instance.example
aws s3 rb s3://bucket-name --force
aws rds delete-db-instance --db-instance-identifier xyz --skip-final-snapshot
```

**CloudTrail Log Reference**: ________________________________ *(Event ID showing deletion)*

---

## Disposal Method

**Physical Assets**:

- ☐ **Certified WEEE Disposal** - Electronics recycling with certificate of destruction
  - Disposal Service: ________________________________________________________________
  - Certificate Expected: ☐ Yes ☐ No
  
- ☐ **Physical Destruction** - On-site shredding or crushing
  - Witness Required: ☐ Yes ☐ No
  - Witness Name: ________________________________
  
- ☐ **Return to Manufacturer** - Apple Trade-In, Dell Buyback, etc.
  - Program: ________________________________
  - Data Wiped First: ☐ Yes ☐ No
  
- ☐ **Donation** - To charity or educational institution *(Only for PUBLIC/INTERNAL after wipe)*
  - Recipient: ________________________________
  - Data Wiped: ☐ Yes (verified)
  
- ☐ **Resale** - Sell on secondary market *(Only for PUBLIC/INTERNAL after wipe)*
  - Platform: ________________________________
  - Data Wiped: ☐ Yes (verified)

**Cloud Assets**:
- ☐ **AWS Deletion** - Resource deleted via AWS API
  - AWS manages physical deletion per DOD 5220.22-M standard
  - EBS volumes: Encrypted; wiped by AWS upon deletion
  - S3 objects: All versions deleted; then bucket deleted
  - Deletion verified in AWS Console: ☐ Yes

---

## Environmental Compliance

**WEEE Regulations Compliance** *(Waste Electrical and Electronic Equipment)*:
- ☐ Yes - Disposal via certified WEEE service
- ☐ N/A - Not electrical equipment

**Disposal Service Certifications**:
- ☐ ISO 14001 (Environmental management)
- ☐ GDPR-compliant disposal
- ☐ Certified data destruction
- ☐ WEEE licensed carrier

---

## Approvals

### Asset Owner Approval

**I confirm that**:
- Asset is no longer needed for business purposes
- All necessary data has been backed up or migrated
- Asset can be disposed of safely

**Asset Owner Name**: ________________________________  
**Signature**: ________________________________  
**Date**: ________________________________

### ISMS Lead Approval (Required for RESTRICTED / CONFIDENTIAL)

**Security Review**:
- ☐ Data sanitization method appropriate for classification
- ☐ Disposal method complies with policy
- ☐ No business continuity risk
- ☐ Disposal service vetted (if external)

**ISMS Lead Approval**: ☐ Approved ☐ Rejected

**Name**: Akam Rahimi  
**Signature**: ________________________________  
**Date**: ________________________________

**Rejection Reason** *(if rejected)*: ________________________________________________________________

### Managing Director Approval (Required for High-Value Assets >£1000 or RESTRICTED)

**Managing Director Approval**: ☐ Approved ☐ Rejected

**Name**: Akam Rahimi  
**Signature**: ________________________________  
**Date**: ________________________________

---

## Disposal Execution

**Disposal Performed By**: ________________________________  
**Disposal Date**: ________________________________  
**Disposal Location**: ________________________________

**Disposal Method Verification**:
- ☐ Data sanitization verified (no data recoverable)
- ☐ Physical destruction witnessed
- ☐ Certificate of destruction received
- ☐ Asset physically removed from premises
- ☐ AWS resource deletion verified (CloudTrail log)

**Certificate of Destruction**:
- ☐ Yes - Certificate attached
  - Certificate Number: ________________________________
  - Issued By: ________________________________
  - Issue Date: ________________________________
- ☐ No - Not required (PUBLIC classification)
- ☐ N/A - Cloud resource (AWS-managed deletion)

**Witness Name** *(if applicable)*: ________________________________  
**Witness Signature**: ________________________________

**Disposal Cost**: £ ________________________________

---

## Post-Disposal

### Asset Register Update

**Asset Register Updated?** ☐ Yes ☐ No

**Updated By**: ________________________________  
**Update Date**: ________________________________  
**Asset Status**: Changed to "Disposed"

### Documentation

**Disposal Log Updated?** ☐ Yes (Entry: DISP-YYYY-NNN)

**Certificate of Destruction Filed?** ☐ Yes ☐ No ☐ N/A

**File Location**: /policies/disposal-certificates/DISP-YYYY-NNN/

**Photos Taken** *(before/after disposal)*: ☐ Yes ☐ No ☐ N/A

---

## Insurance and Financial

**Insurance Claim Required?** ☐ Yes ☐ No

**If YES**:
- Claim Number: ________________________________
- Incident Type: ☐ Theft ☐ Damage ☐ Loss
- Claim Amount: £ ________________________________
- Claim Status: ________________________________

**Asset Value Written Off** *(Accounting)*:
- Original Value: £ ________________________________
- Depreciated Value: £ ________________________________
- Accounting Entry: ________________________________
- Processed By: ________________________________

---

## Lessons Learned

**Why Asset Reached End of Life**:

________________________________________________________________

**Could Asset Lifecycle Be Extended?** *(For future planning)*:

________________________________________________________________

**Recommendations for Future**:

________________________________________________________________

---

## Disposal Closure

**Disposal Completed Successfully?** ☐ Yes ☐ No

**If NO, explain**:

________________________________________________________________

**Disposal Closed By**: ________________________________ *(ISMS Lead)*  
**Closure Date**: ________________________________  
**Signature**: ________________________________

---

## Attachments
- ☐ Certificate of Destruction
- ☐ Photos (before/after disposal)
- ☐ CloudTrail log (AWS deletions)
- ☐ Data sanitization verification report
- ☐ Disposal service invoice

---

**File Location**: /policies/asset-disposals/DISP-YYYY-NNN.pdf  
**Retention**: 7 years (asset lifecycle + compliance requirements)

---

**CONFIDENTIAL - Internal Use Only**

