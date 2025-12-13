#!/usr/bin/env python3
"""
Generate AWS Architecture Diagram with Official Icons
Install: pip install diagrams

Usage: python generate_aws_diagram.py
Output: multi_tenant_infrastructure.png, cicd_pipeline.png
"""

from diagrams import Diagram, Cluster, Edge
from diagrams.aws.compute import ECS, Fargate, ECR
from diagrams.aws.network import ELB, ALB, Route53, VPC, InternetGateway, NATGateway, Endpoint
from diagrams.aws.database import RDS, ElastiCache
from diagrams.aws.security import WAF, KMS, SecretsManager, IAMRole
from diagrams.aws.storage import S3
from diagrams.aws.management import Cloudwatch, CloudwatchAlarm
from diagrams.aws.integration import SNS, Eventbridge
from diagrams.aws.compute import Lambda
from diagrams.aws.devtools import Codepipeline, Codebuild
from diagrams.onprem.client import Users
from diagrams.onprem.vcs import Github

# ============================================================================
# DIAGRAM 1: Main Infrastructure
# ============================================================================

graph_attr = {
    "fontsize": "12",
    "bgcolor": "white",
    "pad": "0.5",
    "splines": "ortho",
}

with Diagram(
    "Envelope AWS Infrastructure\neu-west-2 (ECS Fargate)",
    filename="multi_tenant_infrastructure",
    show=False,
    direction="TB",
    graph_attr=graph_attr,
    outformat="png"
):
    
    users = Users("End Users\n(Tenants & HQ)")
    
    with Cluster("DNS & Edge Security"):
        dns = Route53("Cloudflare/Route53\n*.envelope.com")
        waf = WAF("AWS WAF\nManaged Rules")
    
    with Cluster("VPC: 10.0.0.0/16"):
        igw = InternetGateway("Internet\nGateway")
        
        with Cluster("Public Subnets (AZ-A & AZ-B)"):
            nat_gw = NATGateway("NAT Gateways\n(x2 for HA)")
            public_alb = ALB("Public ALB\nHTTPS:443")
        
        with Cluster("Private Subnets (AZ-A & AZ-B)"):
            internal_alb = ALB("Internal ALB\nHTTP:80")
            
            with Cluster("ECS Fargate Cluster"):
                with Cluster("Frontend Services"):
                    tenant_svc = Fargate("Tenant\nNuxt 3\n(x2)")
                    hq_svc = Fargate("HQ Admin\nNuxt 3\n(x1)")
                
                with Cluster("Backend Services"):
                    api_svc = Fargate("API\nLaravel Octane\n(x2)")
                    worker_svc = Fargate("Worker\nQueue Jobs\n(x1)")
                    scheduler_svc = Fargate("Scheduler\nCron Jobs\n(x1)")
                    reverb_svc = Fargate("Reverb\nWebSocket\n(x1)")
            
            vpc_endpoints = Endpoint("VPC Endpoints\nECR, S3, Logs, SSM")
        
        with Cluster("Data Subnets (AZ-A & AZ-B)"):
            rds = RDS("RDS MariaDB\nMulti-AZ\ndb.t3.medium")
            redis = ElastiCache("ElastiCache Redis\nMulti-AZ\ncache.t3.micro")
    
    with Cluster("Storage"):
        ecr = ECR("ECR\nDocker Images")
        tenant_s3 = S3("Tenant Buckets\nS3 per Tenant\nKMS Encrypted")
        logs_s3 = S3("Logs & Backups\nS3")
    
    with Cluster("Secrets & Keys"):
        secrets = SecretsManager("Secrets Manager\nDB Password\nApp Key")
        kms = KMS("KMS Keys")
    
    with Cluster("Monitoring"):
        cloudwatch = Cloudwatch("CloudWatch\nLogs & Metrics")
        alarms = CloudwatchAlarm("Alarms")
        sns = SNS("SNS\nAlerts")
    
    with Cluster("Tenant Automation"):
        eventbridge = Eventbridge("EventBridge")
        scan_lambda = Lambda("Malware Scan\nLambda")
    
    # === Traffic Flow ===
    
    # User -> ALB -> Services
    users >> Edge(label="HTTPS", color="darkgreen") >> dns
    dns >> waf >> public_alb
    
    # Public ALB routing
    public_alb >> Edge(label="Host: *.domain") >> tenant_svc
    public_alb >> Edge(label="Host: admin.*") >> hq_svc
    public_alb >> Edge(label="Host: wss.*") >> reverb_svc
    
    # Nuxt -> Internal ALB -> API
    tenant_svc >> Edge(label="SSR API") >> internal_alb
    hq_svc >> Edge(label="SSR API") >> internal_alb
    internal_alb >> api_svc
    
    # Backend data access
    api_svc >> Edge(label="3306") >> rds
    api_svc >> Edge(label="6379") >> redis
    worker_svc >> rds
    worker_svc >> redis
    scheduler_svc >> rds
    reverb_svc >> redis
    
    # NAT for outbound
    api_svc >> nat_gw >> igw
    
    # Storage
    api_svc >> tenant_s3
    worker_svc >> tenant_s3
    scan_lambda >> tenant_s3
    
    # Secrets
    secrets >> Edge(style="dashed") >> api_svc
    kms >> Edge(style="dotted", color="purple") >> rds
    kms >> Edge(style="dotted", color="purple") >> tenant_s3
    
    # Monitoring
    api_svc >> cloudwatch
    worker_svc >> cloudwatch
    cloudwatch >> alarms >> sns
    
    # Automation
    tenant_s3 >> Edge(label="Object Created") >> eventbridge >> scan_lambda

print("✅ Generated: multi_tenant_infrastructure.png")


# ============================================================================
# DIAGRAM 2: CI/CD Pipeline
# ============================================================================

with Diagram(
    "Envelope CI/CD Pipelines\nAWS CodePipeline + CodeBuild",
    filename="cicd_pipeline",
    show=False,
    direction="LR",
    graph_attr={
        "fontsize": "12",
        "bgcolor": "white",
        "pad": "0.5",
    },
    outformat="png"
):
    
    with Cluster("GitHub Repositories"):
        api_repo = Github("API Repo\n(Laravel)")
        tenant_repo = Github("Tenant Repo\n(Nuxt)")
        hq_repo = Github("HQ Repo\n(Nuxt)")
    
    with Cluster("API Pipeline (with Migrations)"):
        api_pipeline = Codepipeline("API Pipeline")
        api_build = Codebuild("Build API\nDocker Image")
        migration_build = Codebuild("Run Migrations\nVPC Access")
        api_approval = SNS("Manual\nApproval")
    
    with Cluster("Tenant Pipeline"):
        tenant_pipeline = Codepipeline("Tenant Pipeline")
        tenant_build = Codebuild("Build Tenant\nDocker Image")
        tenant_approval = SNS("Manual\nApproval")
    
    with Cluster("HQ Pipeline"):
        hq_pipeline = Codepipeline("HQ Pipeline")
        hq_build = Codebuild("Build HQ\nDocker Image")
        hq_approval = SNS("Manual\nApproval")
    
    with Cluster("AWS Services"):
        ecr = ECR("ECR\nImage Registry")
        ecs = ECS("ECS Fargate\nRolling Deploy")
        rds = RDS("RDS\n(Migrations)")
        secrets = SecretsManager("Secrets\nManager")
        kms = KMS("KMS\nArtifact Encryption")
        artifacts = S3("S3\nArtifacts")
    
    # API Pipeline Flow
    api_repo >> Edge(label="Release Tag", color="blue") >> api_pipeline
    api_pipeline >> api_build >> ecr
    api_build >> api_approval >> migration_build
    migration_build >> Edge(label="migrate --force") >> rds
    migration_build >> ecs
    
    # Tenant Pipeline Flow
    tenant_repo >> Edge(label="Release Tag", color="green") >> tenant_pipeline
    tenant_pipeline >> tenant_build >> ecr
    tenant_build >> tenant_approval >> ecs
    
    # HQ Pipeline Flow
    hq_repo >> Edge(label="Release Tag", color="orange") >> hq_pipeline
    hq_pipeline >> hq_build >> ecr
    hq_build >> hq_approval >> ecs
    
    # Shared resources
    secrets >> Edge(style="dashed") >> api_build
    secrets >> Edge(style="dashed") >> migration_build
    kms >> Edge(style="dotted") >> artifacts

print("✅ Generated: cicd_pipeline.png")


# ============================================================================
# DIAGRAM 3: Network Architecture
# ============================================================================

with Diagram(
    "Envelope Network Architecture\nVPC & Subnet Layout",
    filename="network_architecture",
    show=False,
    direction="TB",
    graph_attr={
        "fontsize": "11",
        "bgcolor": "white",
        "pad": "0.5",
    },
    outformat="png"
):
    
    users = Users("Internet\nUsers")
    
    with Cluster("VPC: 10.0.0.0/16"):
        igw = InternetGateway("IGW")
        
        with Cluster("Public Subnets"):
            with Cluster("AZ-A: 10.0.1.0/24"):
                nat_a = NATGateway("NAT-A")
                alb_public_a = ALB("Public ALB\nNode A")
            
            with Cluster("AZ-B: 10.0.2.0/24"):
                nat_b = NATGateway("NAT-B")
                alb_public_b = ALB("Public ALB\nNode B")
        
        with Cluster("Private Subnets (ECS Fargate)"):
            with Cluster("AZ-A: 10.0.11.0/24"):
                alb_internal_a = ALB("Internal ALB\nNode A")
                ecs_a = Fargate("ECS Tasks\nAZ-A")
            
            with Cluster("AZ-B: 10.0.12.0/24"):
                alb_internal_b = ALB("Internal ALB\nNode B")
                ecs_b = Fargate("ECS Tasks\nAZ-B")
        
        with Cluster("Data Subnets"):
            with Cluster("AZ-A: 10.0.21.0/24"):
                rds_primary = RDS("RDS Primary")
                redis_primary = ElastiCache("Redis Primary")
            
            with Cluster("AZ-B: 10.0.22.0/24"):
                rds_standby = RDS("RDS Standby")
                redis_replica = ElastiCache("Redis Replica")
        
        with Cluster("VPC Endpoints"):
            endpoints = Endpoint("S3, ECR, Logs\nSSM, Secrets")
    
    # Ingress
    users >> igw
    igw >> alb_public_a
    igw >> alb_public_b
    
    # Public -> Private
    alb_public_a >> ecs_a
    alb_public_b >> ecs_b
    
    # Internal routing
    ecs_a >> alb_internal_a
    ecs_b >> alb_internal_b
    
    # Data access
    ecs_a >> rds_primary
    ecs_b >> rds_primary
    ecs_a >> redis_primary
    ecs_b >> redis_primary
    
    # HA
    rds_primary - Edge(label="Sync", style="dashed") - rds_standby
    redis_primary - Edge(label="Replica", style="dashed") - redis_replica
    
    # Egress
    ecs_a >> nat_a >> igw
    ecs_b >> nat_b >> igw
    
    # VPC Endpoints
    ecs_a >> endpoints
    ecs_b >> endpoints

print("✅ Generated: network_architecture.png")


# ============================================================================
# DIAGRAM 4: ECS Service Architecture
# ============================================================================

with Diagram(
    "Envelope ECS Services\nTask Definitions & Load Balancing",
    filename="ecs_services",
    show=False,
    direction="TB",
    graph_attr={
        "fontsize": "11",
        "bgcolor": "white",
        "pad": "0.5",
    },
    outformat="png"
):
    
    users = Users("Users")
    
    with Cluster("Load Balancers"):
        public_alb = ALB("Public ALB\nHTTPS:443")
        internal_alb = ALB("Internal ALB\nHTTP:80")
    
    with Cluster("ECS Cluster: envelope-prod"):
        with Cluster("Frontend Services (Nuxt 3)"):
            with Cluster("Tenant Service"):
                tenant_tg = ELB("Target Group\nPort 3000")
                tenant_task = Fargate("Tenant Tasks\ndesired: 2\nmax: 10")
            
            with Cluster("HQ Service"):
                hq_tg = ELB("Target Group\nPort 3000")
                hq_task = Fargate("HQ Tasks\ndesired: 1")
        
        with Cluster("Backend Services (Laravel Octane)"):
            with Cluster("API Service"):
                api_tg = ELB("Target Group\nPort 8000")
                api_task = Fargate("API Tasks\ndesired: 2\nmax: 10")
            
            with Cluster("Worker Service"):
                worker_task = Fargate("Worker Tasks\ndesired: 1\nqueue:work")
            
            with Cluster("Scheduler Service"):
                scheduler_task = Fargate("Scheduler Tasks\ndesired: 1\nschedule:work")
        
        with Cluster("WebSocket Service (Reverb)"):
            reverb_tg = ELB("Target Group\nPort 8080")
            reverb_task = Fargate("Reverb Tasks\ndesired: 1\nSticky Sessions")
    
    with Cluster("Data Layer"):
        rds = RDS("RDS MariaDB")
        redis = ElastiCache("Redis")
    
    with Cluster("Container Registry"):
        ecr_api = ECR("envelope-api")
        ecr_tenant = ECR("envelope-tenant")
        ecr_hq = ECR("envelope-hq")
    
    # ALB Routing
    users >> public_alb
    public_alb >> Edge(label="Host: *.domain") >> tenant_tg >> tenant_task
    public_alb >> Edge(label="Host: admin.*") >> hq_tg >> hq_task
    public_alb >> Edge(label="Host: wss.*") >> reverb_tg >> reverb_task
    
    # Internal routing
    tenant_task >> internal_alb >> api_tg >> api_task
    hq_task >> internal_alb
    
    # Data access
    api_task >> rds
    api_task >> redis
    worker_task >> rds
    worker_task >> redis
    scheduler_task >> rds
    reverb_task >> redis
    
    # Image sources
    ecr_api >> Edge(style="dashed") >> api_task
    ecr_api >> Edge(style="dashed") >> worker_task
    ecr_api >> Edge(style="dashed") >> scheduler_task
    ecr_api >> Edge(style="dashed") >> reverb_task
    ecr_tenant >> Edge(style="dashed") >> tenant_task
    ecr_hq >> Edge(style="dashed") >> hq_task

print("✅ Generated: ecs_services.png")


print("\n" + "="*60)
print("📊 All diagrams generated successfully!")
print("="*60)
print("\nFiles created:")
print("  - multi_tenant_infrastructure.png  (Main architecture)")
print("  - cicd_pipeline.png                (CI/CD pipelines)")
print("  - network_architecture.png         (VPC & subnets)")
print("  - ecs_services.png                 (ECS service details)")
print("\n💡 Tip: Run 'pip install diagrams' if you get import errors")
