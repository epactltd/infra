#!/usr/bin/env python3
"""
Generate AWS Architecture Diagram with Official Icons
Install: pip install diagrams

Usage: python generate_aws_diagram.py
Output: multi_tenant_infrastructure.png
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import EC2, AutoScaling
from diagrams.aws.network import ELB, Route53, VPC, InternetGateway, NATGateway
from diagrams.aws.database import RDS
from diagrams.aws.security import WAF, KMS, Guardduty, SecurityHub, IAM
from diagrams.aws.storage import S3
from diagrams.aws.management import Cloudwatch, CloudwatchAlarm, Config, Cloudtrail
from diagrams.aws.integration import SNS, Eventbridge
from diagrams.aws.compute import Lambda
from diagrams.onprem.client import Users

# Configuration
graph_attr = {
    "fontsize": "14",
    "bgcolor": "white",
    "pad": "0.5",
}

with Diagram(
    "Multi-Tenant AWS Infrastructure\neu-west-2",
    filename="docs/diagrams/multi_tenant_infrastructure",
    show=False,
    direction="TB",
    graph_attr=graph_attr,
    outformat="png"
):
    
    users = Users("End Users")
    
    with Cluster("DNS & Edge Security"):
        dns = Route53("*.app_domain")
        waf = WAF("WAF\nManaged Rules\nRate Limiting")
    
    with Cluster("VPC: 10.0.0.0/16"):
        igw = InternetGateway("Internet Gateway")
        
        with Cluster("Availability Zone A"):
            with Cluster("Public Subnet A"):
                nat_a = NATGateway("NAT-A")
                alb_a = ELB("ALB Node A\nHTTPS/HTTP")
            
            with Cluster("Private Subnet A"):
                ec2_a = EC2("EC2-A\nLaravel/Nuxt\nEBS Encrypted")
                rds_primary = RDS("RDS Primary\nMySQL 8.0.33\nMulti-AZ")
        
        with Cluster("Availability Zone B"):
            with Cluster("Public Subnet B"):
                nat_b = NATGateway("NAT-B")
                alb_b = ELB("ALB Node B\nHTTPS/HTTP")
            
            with Cluster("Private Subnet B"):
                ec2_b = EC2("EC2-B\nLaravel/Nuxt\nEBS Encrypted")
                rds_standby = RDS("RDS Standby\nMySQL 8.0.33")
        
        asg = AutoScaling("Auto Scaling\nMin:2 Max:10\nScale ±CPU")
    
    with Cluster("Security & Compliance"):
        kms = KMS("KMS Keys\n30d Deletion")
        guardduty = Guardduty("GuardDuty\nS3/EBS Scan")
        security_hub = SecurityHub("Security Hub\nCIS/PCI")
        config_svc = Config("AWS Config")
        cloudtrail = Cloudtrail("CloudTrail")
        iam = IAM("IAM Roles\nLeast Privilege")
    
    with Cluster("Data Storage"):
        flow_logs = S3("VPC Flow Logs\nKMS + Lifecycle")
        alb_logs = S3("ALB Logs\nKMS + Lifecycle")
        tenant_buckets = S3("Tenant Buckets\nVersioned + KMS")
        backup_vault = S3("AWS Backup\nDaily/Weekly")
    
    with Cluster("Monitoring & Alerting"):
        cw_alarms = CloudwatchAlarm("CloudWatch Alarms\nALB/ASG/RDS")
        cw_dash = Cloudwatch("CloudWatch\nDashboard")
        cw_logs = Cloudwatch("CloudWatch Logs\n90d Retention")
        sns = SNS("SNS Alerts\nKMS Encrypted")
    
    with Cluster("Tenant Automation"):
        eventbridge = Eventbridge("EventBridge\ntenant.created")
        lambda_fn = Lambda("Tenant Lambda\nPython 3.11")
    
    # Traffic Flow
    users >> Edge(label="HTTPS") >> dns
    dns >> Edge(label="Route") >> waf
    waf >> Edge(label="Protected") >> alb_a
    waf >> Edge(label="Protected") >> alb_b
    alb_a >> Edge(label="Forward") >> ec2_a
    alb_b >> Edge(label="Forward") >> ec2_b
    
    # Network
    ec2_a >> Edge(label="Egress") >> nat_a
    ec2_b >> Edge(label="Egress") >> nat_b
    nat_a >> igw
    nat_b >> igw
    
    # Database
    ec2_a >> Edge(label="3306") >> rds_primary
    ec2_b >> Edge(label="3306") >> rds_primary
    rds_primary - Edge(label="Replication", style="dashed") - rds_standby
    
    # Auto Scaling
    asg - Edge(style="dashed") - ec2_a
    asg - Edge(style="dashed") - ec2_b
    
    # Logging
    alb_a >> alb_logs
    alb_b >> alb_logs
    igw >> flow_logs
    
    # Security Services
    guardduty >> Edge(style="dashed", color="red") >> iam
    security_hub >> Edge(style="dashed", color="red") >> iam
    config_svc >> Edge(style="dashed", color="red") >> iam
    cloudtrail >> Edge(style="dashed", color="red") >> iam
    
    # Monitoring
    ec2_a >> cw_logs
    ec2_b >> cw_logs
    rds_primary >> cw_logs
    alb_a >> cw_logs
    alb_b >> cw_logs
    cw_logs >> cw_alarms
    cw_alarms >> sns
    cw_alarms >> Edge(label="Scale") >> asg
    cw_logs >> cw_dash
    cw_alarms >> cw_dash
    
    # Backup
    backup_vault >> Edge(label="Protects", style="dashed", color="green") >> rds_primary
    backup_vault >> Edge(label="Protects", style="dashed", color="green") >> ec2_a
    backup_vault >> Edge(label="Protects", style="dashed", color="green") >> ec2_b
    backup_vault >> Edge(label="Protects", style="dashed", color="green") >> tenant_buckets
    
    # Automation
    eventbridge >> Edge(label="Invoke") >> lambda_fn
    lambda_fn >> Edge(label="Provision") >> tenant_buckets
    
    # Encryption
    kms >> Edge(label="Encrypts", style="dotted", color="purple") >> flow_logs
    kms >> Edge(label="Encrypts", style="dotted", color="purple") >> alb_logs
    kms >> Edge(label="Encrypts", style="dotted", color="purple") >> tenant_buckets
    kms >> Edge(label="Encrypts", style="dotted", color="purple") >> backup_vault
    kms >> Edge(label="Encrypts", style="dotted", color="purple") >> sns
    kms >> Edge(label="Encrypts", style="dotted", color="purple") >> rds_primary

print("✅ Diagram generated: docs/diagrams/multi_tenant_infrastructure.png")
print("📊 View the diagram in docs/infrastructure.md")
print("💡 Tip: Open the PNG file to see your infrastructure with official AWS icons!")

