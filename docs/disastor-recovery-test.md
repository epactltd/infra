# Disaster Recovery (DR) Test Plan

This document outlines the process for exercising and validating the disaster recovery capabilities of the Envelope multi-tenant AWS infrastructure. Tests should be scheduled at least twice per year or after significant architectural changes.

## 1. Objectives
- Validate that Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO) are achievable.
- Ensure backup, restore, and failover runbooks (e.g., `docs/backup-restore-runbook.md`) remain accurate.
- Confirm all stakeholders understand their responsibilities during a DR event.
- Identify gaps in automation, observability, or documentation.

## 2. Scope
- **In-scope services**: 
  - VPC networking (public, private, data subnets)
  - Application Load Balancers (public and internal)
  - ECS Fargate services (API, Worker, Scheduler, Reverb, Tenant, HQ)
  - RDS MariaDB database (central + tenant databases)
  - ElastiCache Redis cluster
  - Tenant S3 buckets (created via EventBridge + Lambda)
  - Lambda tenant provisioner
  - AWS Backup vaults
  - CI/CD pipelines (CodePipeline, CodeBuild)
  - Monitoring stack (SNS, CloudWatch)
- **Out-of-scope**: Client applications outside of Terraform's control, DNS cutover to alternate regions, Cloudflare configuration, and third-party integrations.

## 3. Pre-Test Checklist
1. Obtain executive approval and notify stakeholders (application team, platform team, security, on-call).
2. Review the latest Terraform state and confirm no in-flight deployments.
3. Validate AWS Backup job health for the prior 7 days.
4. Ensure test accounts, VPC CIDRs, and hosted zones do not conflict with production.
5. Prepare communication channels (incident bridge, chat, status page template).

## 4. Test Scenarios
| Scenario | Description | Expected Outcome |
|----------|-------------|------------------|
| **Database Restore** | Simulate corruption by restoring RDS from a backup to a clean environment | Restored DB passes integrity checks; all tenant databases intact |
| **Single Tenant Recovery** | Restore a specific tenant database from backup without affecting others | Tenant data restored; other tenants unaffected |
| **Tenant Bucket Recovery** | Restore a tenant's S3 data to a staging bucket and validate object integrity | All critical objects restored; policies/tags preserved; documented merge steps |
| **ECS Service Failover** | Stop all tasks for a service and verify automatic recovery | ECS relaunches tasks; ALB health checks pass; service recovers within RTO |
| **Bad Deployment Rollback** | Deploy a broken image and roll back to previous task definition | Previous version restored; CI/CD pipeline can be re-triggered |
| **Worker Queue Recovery** | Simulate worker failure; verify failed jobs are retried | Jobs reprocessed after worker restart; no data loss |
| **Control Plane Loss** | Simulate Terraform state loss and demonstrate recovery using S3 backend snapshot | State recovered, no drift; documentation updated |
| **Lambda Provisioner Failure** | Disable Lambda and create tenant; verify manual recovery | Tenant created without S3; manual bucket creation documented |
| **Regional Failover (Optional)** | Deploy stack in secondary region using same Terraform modules | Secondary region passes smoke tests and is ready for DNS cutover |

Select scenarios based on business priorities; at least two must be executed per exercise.

## 5. Execution Steps

### Example: Database Restore Scenario
1. **Kick-off**: Start the test, assign command roles (incident lead, communications, technical leads).
2. **Trigger Event**: Put application in maintenance mode, note timestamps.
3. **Restore**: Follow `docs/backup-restore-runbook.md` to restore the RDS instance to a new identifier.
4. **Validation**: Run automated smoke tests and manual verification by the application team.
5. **Cutover**: Update ECS task definitions to use restored instance (if part of the test).
6. **Monitoring**: Observe CloudWatch metrics, SNS alerts, and logs for anomalies.
7. **Document**: Record times, issues, workarounds, and screenshots/log excerpts.

### Example: ECS Service Failover Scenario
1. **Kick-off**: Notify stakeholders, prepare monitoring dashboards.
2. **Trigger Event**: Stop all tasks for `envelope-prod-api`:
   ```bash
   aws ecs update-service --cluster envelope-prod-cluster \
     --service envelope-prod-api --desired-count 0
   ```
3. **Observe**: Monitor ALB health checks failing, CloudWatch alarms triggering.
4. **Recovery**: Restore desired count:
   ```bash
   aws ecs update-service --cluster envelope-prod-cluster \
     --service envelope-prod-api --desired-count 1
   ```
5. **Validation**: Verify health checks pass, API responds correctly.
6. **Document**: Record recovery time, compare against RTO target.

### Example: Bad Deployment Rollback
1. **Trigger**: Deploy a known-broken image via CodePipeline (use test branch).
2. **Observe**: Health checks fail, circuit breaker triggers rollback.
3. **Manual Intervention**: If needed, force previous task definition:
   ```bash
   aws ecs update-service --cluster envelope-prod-cluster \
     --service envelope-prod-api \
     --task-definition envelope-prod-api:PREVIOUS_REVISION
   ```
4. **Validation**: Service recovers with previous version.
5. **Document**: Record rollback procedure and time.

Repeat similar step breakdowns for other selected scenarios.

## 6. Success Criteria
- RTO/RPO targets met (document actuals).
- All critical runbooks executed without gaps; any deviations logged.
- Monitoring and alerting triggered appropriately.
- Stakeholders confirm service functionality post-test.

## 7. Post-Test Activities
1. Conduct a debrief within 48 hours; include lessons learned and remediation items.
2. Update runbooks, Terraform code, or automation scripts based on findings.
3. Log test artifacts (plans, recovery job IDs, metrics) in a central repository.
4. Track action items in the team backlog and assign owners/due dates.

## 8. Roles & Contact Matrix
| Role | Primary | Backup | Responsibilities |
|------|---------|--------|------------------|
| Incident Lead | Platform Lead | Senior Engineer | Coordinate execution, ensure documentation |
| Database Lead | DB Engineer | On-call DBA | Execute RDS restore, verify data |
| Application Lead | App Owner | App Engineer | Validate application functionality |
| Communications | Support Manager | Incident Manager | Stakeholder updates, status page |
| Security Observer | SecOps Analyst | Compliance Officer | Monitor guardrails, note findings |

Adjust the matrix before each exercise based on availability.

## 9. Tooling & References

### AWS Services
- AWS Backup console & CLI (`aws backup ...`)
- RDS console / `aws rds ...`
- ECS console / `aws ecs ...`
- CloudWatch dashboards and alarms
- CodePipeline / CodeBuild for CI/CD

### Key Commands
```bash
# Check ECS service status
aws ecs describe-services --cluster envelope-prod-cluster \
  --services envelope-prod-api envelope-prod-worker envelope-prod-tenant envelope-prod-hq

# View failed jobs queue
aws ecs run-task --cluster envelope-prod-cluster \
  --task-definition envelope-prod-api --launch-type FARGATE \
  --network-configuration "..." \
  --overrides '{"containerOverrides":[{"name":"api","command":["php","artisan","queue:failed"]}]}'

# Check RDS status
aws rds describe-db-instances --db-instance-identifier envelope-prod-db

# View recent CloudWatch logs
aws logs tail /ecs/envelope-prod-api --since 1h
aws logs tail /aws/lambda/envelope-prod-tenant-provisioner --since 1h
```

### Documentation
- Runbooks: `docs/backup-restore-runbook.md`
- Deployment: `docs/deployment-guide.md`
- CI/CD: `docs/cicd-setup.md`
- Terraform state: S3 bucket `envelope-terraform-state-ACCOUNT_ID`

## 10. Continuous Improvement
- Track metrics from each DR test (duration, issues, automation coverage).
- Evaluate opportunities for additional automation (e.g., AWS Backup Restore Testing, event-driven failover).
- Ensure compliance requirements (ISO, PCI, etc.) reference completed DR exercises.

Maintain this plan alongside Terraform updates so DR testing reflects current infrastructure design and business expectations.

