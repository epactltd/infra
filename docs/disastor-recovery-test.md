# Disaster Recovery (DR) Test Plan

This document outlines the process for exercising and validating the disaster recovery capabilities of the multi-tenant AWS infrastructure. Tests should be scheduled at least twice per year or after significant architectural changes.

## 1. Objectives
- Validate that Recovery Time Objectives (RTO) and Recovery Point Objectives (RPO) are achievable.
- Ensure backup, restore, and failover runbooks (e.g., `docs/backup-restore-runbook.md`) remain accurate.
- Confirm all stakeholders understand their responsibilities during a DR event.
- Identify gaps in automation, observability, or documentation.

## 2. Scope
- **In-scope services**: VPC networking, ALB/ASG compute tier, RDS MySQL database, tenant S3 buckets, Lambda tenant automation, AWS Backup vaults, monitoring stack (SNS, CloudWatch), and critical IAM roles/policies.
- **Out-of-scope**: Client applications outside of Terraform’s control, DNS cutover to alternate regions, and third-party integrations (unless explicitly included in the exercise plan).

## 3. Pre-Test Checklist
1. Obtain executive approval and notify stakeholders (application team, platform team, security, on-call).
2. Review the latest Terraform state and confirm no in-flight deployments.
3. Validate AWS Backup job health for the prior 7 days.
4. Ensure test accounts, VPC CIDRs, and hosted zones do not conflict with production.
5. Prepare communication channels (incident bridge, chat, status page template).

## 4. Test Scenarios
| Scenario | Description | Expected Outcome |
|----------|-------------|------------------|
| **Database Restore** | Simulate corruption by restoring RDS from a backup to a clean environment and switching application traffic | Restored DB passes integrity checks; app reconnects with minimal downtime |
| **Tenant Bucket Recovery** | Restore a tenant’s S3 data to a staging bucket and validate object integrity | All critical objects restored; policies/tags preserved; documented merge steps |
| **Compute Failover** | Terminate ASG instances and verify automatic recovery; optionally test blue/green deployment scripts | ASG rehydrates instances, ALB reports healthy targets |
| **Control Plane Loss** | Simulate Terraform state loss and demonstrate recovery using remote backend snapshot | State recovered, no drift; documentation updated |
| **Regional Failover (Optional)** | Deploy stack in secondary region using same Terraform modules | Secondary region passes smoke tests and is ready for DNS cutover |

Select scenarios based on business priorities; at least two must be executed per exercise.

## 5. Execution Steps (Example: Database Restore Scenario)
1. **Kick-off**: Start the test, assign command roles (incident lead, communications, technical leads).
2. **Trigger Event**: Disable application write traffic (maintenance mode), note timestamps.
3. **Restore**: Follow `docs/backup-restore-runbook.md` to restore the RDS instance to a new identifier.
4. **Validation**: Run automated smoke tests and manual verification by the application team.
5. **Cutover**: Update application configuration to use the restored instance (if part of the test).
6. **Monitoring**: Observe CloudWatch metrics, SNS alerts, and logs for anomalies.
7. **Document**: Record times, issues, workarounds, and screenshots/log excerpts.

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
- AWS Backup console & CLI (`aws backup ...`)
- RDS console / `aws rds ...`
- CloudWatch dashboards and alarms (see `modules/monitoring`)
- Terraform state (S3 backend) and code repository
- Runbooks: `docs/backup-restore-runbook.md`, `docs/deployment.md`

## 10. Continuous Improvement
- Track metrics from each DR test (duration, issues, automation coverage).
- Evaluate opportunities for additional automation (e.g., AWS Backup Restore Testing, event-driven failover).
- Ensure compliance requirements (ISO, PCI, etc.) reference completed DR exercises.

Maintain this plan alongside Terraform updates so DR testing reflects current infrastructure design and business expectations.

