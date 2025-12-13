# Backup & Restore Runbook

This runbook documents how to verify backups, perform restores, and validate data integrity for the Envelope multi-tenant infrastructure deployed by Terraform. It covers RDS MariaDB database, tenant S3 buckets, and ECS service recovery.

## 1. Roles & Responsibilities
- **On-call Engineer**: Executes restore procedures during incidents.
- **Platform Team**: Maintains Terraform modules, backup schedules, and automation.
- **Application Team**: Validates application-level functionality post-restore.

## 2. Backup Strategy Overview

### RDS MariaDB
- **Native RDS backups**: 7-day retention, backup window 03:00-04:00 UTC
- **AWS Backup plan**: Daily backups (30d retention) at 05:00 UTC, weekly backups (365d with cold storage after 30d) on Sundays at 06:00 UTC
- All backups encrypted with customer-managed KMS keys
- Contains both central database and tenant databases (tenant_{id})

### Tenant S3 Buckets
- Buckets created by `envelope-prod-tenant-provisioner` Lambda via EventBridge
- Bucket naming: `envelope-tenant-{tenant_id}-prod`
- S3 versioning enabled for point-in-time recovery
- Buckets tagged with `Tenant={id}`, `Environment=prod`, `Project=envelope`
- AWS Backup jobs can target buckets via tag-based selection

### ECS Services (Fargate)
- Stateless containers - no backup required
- Recovery involves redeploying from ECR images
- Task definitions versioned in Terraform state

### Backup Vault
- Name: `envelope-prod-backup-vault`
- Encrypted with security KMS key
- 30-day deletion window for accidental deletion protection

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
    --backup-vault-name "envelope-prod-backup-vault" \
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
  "SubnetGroupName": "envelope-prod-db-subnet-group",
  "VpcSecurityGroupIds": "sg-xxxxx",
  "DbInstanceIdentifier": "envelope-prod-db-restore",
  "DbInstanceClass": "db.t3.medium",
  "DbSubnetGroupName": "envelope-prod-db-subnet-group",
  "Engine": "mariadb"
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
# List recovery points for a specific tenant bucket
aws backup list-recovery-points-by-backup-vault \
  --backup-vault-name "envelope-prod-backup-vault" \
  --by-resource-type "S3" \
  --query 'RecoveryPoints[?contains(ResourceArn, `envelope-tenant-<TENANT_ID>-prod`)]'
```

### 6.2 Use S3 Versioning (Quick Recovery)
For recent deletions or overwrites, use S3 versioning:
```bash
# List object versions
aws s3api list-object-versions \
  --bucket envelope-tenant-<TENANT_ID>-prod \
  --prefix "path/to/file"

# Restore a previous version by copying it
aws s3api copy-object \
  --bucket envelope-tenant-<TENANT_ID>-prod \
  --copy-source "envelope-tenant-<TENANT_ID>-prod/path/to/file?versionId=<VERSION_ID>" \
  --key "path/to/file"
```

### 6.3 AWS Backup Restore
- **Alternate Bucket** (recommended):
  ```bash
  aws backup start-restore-job \
    --recovery-point-arn "<RECOVERY_POINT_ARN>" \
    --metadata '{"DestinationBucketName":"envelope-tenant-<TENANT_ID>-restore"}' \
    --iam-role-arn "<AWS_BACKUP_SERVICE_ROLE_ARN>"
  ```
- After restore, review object versions and tags before merging into the production bucket.

### 6.4 Validation
1. Spot-check critical objects, metadata, and encryption settings.
2. Update tenant S3 configs in database if using alternate bucket:
   ```sql
   UPDATE tenants SET configs = JSON_SET(configs, '$.s3.bucket', 'new-bucket-name') WHERE id = <TENANT_ID>;
   ```
3. Bucket policies and tags are applied by Lambda; run manually if needed.

## 7. ECS Service Recovery

ECS Fargate services are stateless and recover automatically. Manual intervention may be needed for:

### 7.1 Force Service Redeployment
```bash
# Redeploy all services with latest task definitions
for service in api worker scheduler reverb tenant hq; do
  aws ecs update-service \
    --cluster envelope-prod-cluster \
    --service envelope-prod-$service \
    --force-new-deployment \
    --query 'service.serviceName' \
    --output text
done
```

### 7.2 Roll Back to Previous Task Definition
```bash
# List task definition revisions
aws ecs list-task-definitions \
  --family-prefix envelope-prod-api \
  --sort DESC \
  --query 'taskDefinitionArns[:5]'

# Update service to use specific revision
aws ecs update-service \
  --cluster envelope-prod-cluster \
  --service envelope-prod-api \
  --task-definition envelope-prod-api:REVISION_NUMBER
```

### 7.3 Recover from Bad Docker Image
```bash
# List ECR images
aws ecr describe-images \
  --repository-name envelope-api \
  --query 'imageDetails | sort_by(@, &imagePushedAt) | [-5:]'

# Retag previous image as latest
aws ecr batch-get-image \
  --repository-name envelope-api \
  --image-ids imageTag=PREVIOUS_TAG \
  --query 'images[0].imageManifest' --output text | \
aws ecr put-image \
  --repository-name envelope-api \
  --image-tag latest \
  --image-manifest -

# Force redeploy
aws ecs update-service --cluster envelope-prod-cluster \
  --service envelope-prod-api --force-new-deployment
```

## 8. Tenant Database Recovery

Each tenant has a database named `tenant_{id}`. To recover a specific tenant's data:

### 8.1 Export Tenant Data from Restored RDS
```bash
# Connect to restored instance
mysql -h restored-db-endpoint -u appuser -p

# Export tenant database
mysqldump -h restored-db-endpoint -u appuser -p tenant_<TENANT_ID> > tenant_<TENANT_ID>_backup.sql
```

### 8.2 Import to Production
```bash
# Create database if dropped
mysql -h prod-db-endpoint -u appuser -p -e "CREATE DATABASE IF NOT EXISTS tenant_<TENANT_ID>"

# Import data
mysql -h prod-db-endpoint -u appuser -p tenant_<TENANT_ID> < tenant_<TENANT_ID>_backup.sql
```

### 8.3 Re-run Migrations (if needed)
```bash
aws ecs run-task \
  --cluster envelope-prod-cluster \
  --task-definition envelope-prod-api \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[SUBNET],securityGroups=[SG],assignPublicIp=DISABLED}" \
  --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","tenants:migrate","--tenants=<TENANT_ID>"]}]}'
```

## 9. Access & Permissions
- Backup IAM role (`envelope-prod-backup-role`) must retain AWS-managed policy `AWSBackupServiceRolePolicyForBackup`.
- Incident responders need permissions for `backup:ListRecoveryPoints`, `backup:StartRestoreJob`, `rds:*`, `s3:*` (scoped), and `ecs:*` as appropriate.

## 10. Automation & Testing Recommendations
- Schedule automated restore tests (e.g., AWS Backup Restore Testing or custom Lambda scripts).
- Integrate success/failure notifications with the monitoring SNS topic.
- Capture runbook improvements via pull requests.

## 11. Post-Incident Checklist
- Update `docs/backup-restore-runbook.md` with findings.
- Record the recovery point ARN and restore job IDs.
- Verify backup vault retention policies and compliance requirements.
- Conduct a blameless postmortem and assign remediation actions.

## 12. Quick Reference Commands

```bash
# List all ECS services and their status
aws ecs list-services --cluster envelope-prod-cluster

# Check service health
aws ecs describe-services --cluster envelope-prod-cluster \
  --services envelope-prod-api envelope-prod-worker \
  --query 'services[*].{Name:serviceName,Running:runningCount,Desired:desiredCount}'

# View recent RDS snapshots
aws rds describe-db-snapshots \
  --db-instance-identifier envelope-prod-db \
  --query 'DBSnapshots[-5:].{ID:DBSnapshotIdentifier,Time:SnapshotCreateTime}'

# List tenant S3 buckets
aws s3 ls | grep envelope-tenant

# Check CloudWatch alarms
aws cloudwatch describe-alarms --alarm-name-prefix envelope-prod
```

## 13. References
- [AWS Backup Documentation](https://docs.aws.amazon.com/backup/)
- [Restoring an Amazon RDS DB Instance](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_PIT.html)
- [S3 Restore with AWS Backup](https://docs.aws.amazon.com/backup/latest/devguide/s3-restore.html)
- [Amazon ECS Service Recovery](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/service-auto-scaling.html)
- [Terraform AWS Resources](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

Keep this runbook updated as backup retention periods, recovery point objectives (RPO), or infrastructure components evolve.

