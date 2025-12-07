# Backup & Restore Runbook

This runbook documents how to verify backups, perform restores, and validate data integrity for the multi-tenant infrastructure deployed by Terraform. It covers both database (RDS MySQL) and tenant S3 bucket backups managed via AWS Backup.

## 1. Roles & Responsibilities
- **On-call Engineer**: Executes restore procedures during incidents.
- **Platform Team**: Maintains Terraform modules, backup schedules, and automation.
- **Application Team**: Validates application-level functionality post-restore.

## 2. Backup Strategy Overview
- **RDS MySQL**: Dual backup strategy:
  - Native RDS backups: 7-day retention, backup window 03:00-04:00 UTC
  - AWS Backup plan: Daily backups (30d retention + 90d copy) at 05:00 UTC, weekly backups (365d with cold storage after 30d) on Sundays at 06:00 UTC
  - Multi-AZ ensures replication; all backups encrypted with customer-managed KMS keys (30-day deletion windows)
- **EC2 Instances**: Any instance tagged `Backup=true` is included through the AWS Backup selection rule (daily + weekly schedules).
- **Tenant S3 Buckets**: Tenant provisioning Lambda tags each bucket with `Backup=true`. AWS Backup supports S3 backup jobs to the same vault. Additionally, S3 versioning provides point-in-time recovery.
- **Backup Vault**: `${project_name}-${environment}-backup-vault` encrypted with the security KMS key (30-day deletion window for accidental deletion protection).

## 3. Monitoring Backups
1. **AWS Backup Console**: Navigate to *AWS Backup > Dashboard* to confirm successful jobs. Filter by vault and resource type.
2. **CloudWatch Metrics/Logs**: Review `AWS/Backup` metrics and CloudWatch Logs for failure alerts. Consider adding alarms if not already in place.
3. **Notifications**: Extend SNS alerts (from the monitoring module) to include AWS Backup job state changes if desired.

## 4. Routine Verification
Perform at least quarterly:
1. Select a random RDS backup recovery point.
2. Perform a scripted restore to a staging database (different subnet/identifier).
3. Run database integrity checks (e.g., `CHECK TABLE`, application smoke tests).
4. Document results and cleanup temporary resources.

## 5. RDS Restore Procedure
> Goal: Restore a point-in-time snapshot to a new instance or replace the primary database.

### 5.1 Preparation
- Identify incident scope (data loss, corruption, disaster recovery test).
- Retrieve the latest valid Recovery Point ARN:
  ```bash
  aws backup list-recovery-points-by-backup-vault \
    --backup-vault-name "${PROJECT_NAME}-${ENVIRONMENT}-backup-vault" \
    --by-resource-type "RDS" \
    --query 'RecoveryPoints[?Status==`COMPLETED`]|[0].RecoveryPointArn' \
    --output text
  ```
- Notify stakeholders and initiate change management if required.

### 5.2 Restoring to New Instance
```bash
aws backup start-restore-job \
  --recovery-point-arn "<RECOVERY_POINT_ARN>" \
  --metadata file://restore-metadata.json \
  --iam-role-arn "<AWS_BACKUP_SERVICE_ROLE_ARN>"
```
`restore-metadata.json` should include:
```json
{
  "SubnetGroupName": "multi-tenant-app-prod-db-subnet-group",
  "VpcSecurityGroupIds": "sg-0123456789abcdef0",
  "DbInstanceIdentifier": "multi-tenant-app-prod-db-restore",
  "DbInstanceClass": "db.t3.medium",
  "DbSubnetGroupName": "multi-tenant-app-prod-db-subnet-group",
  "Engine": "mysql"
}
```
Monitor the restore job:
```bash
aws backup describe-restore-job --restore-job-id "<RESTORE_JOB_ID>"
```

### 5.3 Restore In-Place (Disaster Scenario)
- Consider restoring to a new instance, verifying data, then swapping endpoints to reduce risk.
- If forced to restore in place, snapshot current state first, stop application writers, and update the ASG user data/parameters as needed.

### 5.4 Post-Restore Validation
1. Run database smoke tests (connectivity, schema counts, checksum comparisons).
2. Update application configuration/Secrets Manager/SSM if endpoint or credentials change.
3. Re-enable application traffic gradually and monitor CloudWatch metrics and logs.
4. Document the incident, timeline, and follow-up improvements.

## 6. Tenant S3 Bucket Restore

### 6.1 Identify Recovery Point
```bash
aws backup list-recovery-points-by-backup-vault \
  --backup-vault-name "${PROJECT_NAME}-${ENVIRONMENT}-backup-vault" \
  --by-resource-type "S3" \
  --query 'RecoveryPoints[?contains(ResourceArn, `tenant-<TENANT_ID>`)]'
```

### 6.2 Restore Options
- **Same Bucket (Overwrite)**: Not currently supported directly; recommended workflow is to restore to a staging bucket and selectively copy objects.
- **Alternate Bucket**:
  ```bash
  aws backup start-restore-job \
    --recovery-point-arn "<RECOVERY_POINT_ARN>" \
    --metadata '{"DestinationBucketName":"multi-tenant-app-prod-tenant-<TENANT_ID>-restore"}' \
    --iam-role-arn "<AWS_BACKUP_SERVICE_ROLE_ARN>"
  ```
- After restore, review object versions and tags before merging into the production bucket.

### 6.3 Validation
1. Spot-check critical objects, metadata, and encryption settings.
2. Update application references if using an alternate bucket temporarily.
3. Reapply tags/policies via the tenant provisioning Lambda if needed.

## 7. EC2 Instance Restore
- AWS Backup can create AMI-style restores for tagged instances.
- Restoration involves starting a restore job and launching from the recovered AMI or volume.
- Ensure user data/secrets are updated and instances rejoin the ASG or appropriate auto-scaling group.

## 8. Access & Permissions
- Backup IAM role (`${project_name}-${environment}-backup-role`) must retain AWS-managed policy `AWSBackupServiceRolePolicyForBackup`.
- Incident responders need permissions for `backup:ListRecoveryPoints`, `backup:StartRestoreJob`, `rds:*`, `s3:*` (scoped), and `ec2:*` as appropriate.

## 9. Automation & Testing Recommendations
- Schedule automated restore tests (e.g., AWS Backup Restore Testing or custom Lambda scripts).
- Integrate success/failure notifications with the monitoring SNS topic.
- Capture runbook improvements via pull requests.

## 10. Post-Incident Checklist
- Update `docs/backup-restore-runbook.md` with findings.
- Record the recovery point ARN and restore job IDs.
- Verify backup vault retention policies and compliance requirements.
- Conduct a blameless postmortem and assign remediation actions.

## 11. References
- [AWS Backup Documentation](https://docs.aws.amazon.com/backup/)
- [Restoring an Amazon RDS DB Instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html)
- [S3 Restore with AWS Backup](https://docs.aws.amazon.com/backup/latest/devguide/s3-restore.html)
- [Terraform AWS Backup Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan)

Keep this runbook updated as backup retention periods, recovery point objectives (RPO), or infrastructure components evolve.

