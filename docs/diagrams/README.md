# Architecture Diagrams

This directory contains tools and outputs for generating professional AWS architecture diagrams for the Envelope application.

## Quick Start

### Generate Diagrams

```bash
# Install the diagrams library
pip install diagrams

# Generate all diagrams
python generate_aws_diagram.py

# Output files:
#   - multi_tenant_infrastructure.png  (Main architecture)
#   - cicd_pipeline.png                (CI/CD pipelines)
#   - network_architecture.png         (VPC & subnets)
#   - ecs_services.png                 (ECS service details)
```

## Generated Diagrams

### 1. Main Infrastructure (`multi_tenant_infrastructure.png`)

Shows the complete AWS infrastructure including:
- VPC with public, private, and data subnets
- ECS Fargate cluster with all services
- RDS MariaDB and ElastiCache Redis
- Public and Internal ALBs
- S3 storage and tenant buckets
- Monitoring and security components

### 2. CI/CD Pipelines (`cicd_pipeline.png`)

Shows the three independent deployment pipelines:
- **API Pipeline**: Build → Approval → Migrate → Deploy (API, Worker, Scheduler, Reverb)
- **Tenant Pipeline**: Build → Approval → Deploy (Tenant)
- **HQ Pipeline**: Build → Approval → Deploy (HQ)

### 3. Network Architecture (`network_architecture.png`)

Detailed view of the VPC layout:
- Public subnets (NAT gateways, ALB)
- Private subnets (ECS Fargate tasks)
- Data subnets (RDS, Redis)
- VPC endpoints for AWS services
- Multi-AZ high availability

### 4. ECS Services (`ecs_services.png`)

Detailed view of ECS services and load balancing:
- Target groups and port mappings
- Service scaling configuration
- Container image sources (ECR)
- Data layer connections

## Files

| File | Description |
|------|-------------|
| `generate_aws_diagram.py` | Python script using the diagrams library |
| `multi_tenant_infrastructure.png` | Main architecture diagram |
| `cicd_pipeline.png` | CI/CD pipeline diagram |
| `network_architecture.png` | Network/VPC diagram |
| `ecs_services.png` | ECS services diagram |
| `README.md` | This file |

## Infrastructure Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              Envelope on AWS                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  Users → Cloudflare/Route53 → WAF → Public ALB                              │
│                                       │                                      │
│                    ┌──────────────────┼──────────────────┐                  │
│                    ▼                  ▼                  ▼                  │
│              Tenant (Nuxt)       HQ (Nuxt)          Reverb (WS)             │
│                    │                  │                                      │
│                    └────────┬─────────┘                                      │
│                             ▼                                                │
│                      Internal ALB                                            │
│                             │                                                │
│                    ┌────────┴────────┐                                       │
│                    ▼                 ▼                                       │
│               API (Laravel)    Worker/Scheduler                              │
│                    │                 │                                       │
│                    └────────┬────────┘                                       │
│                             ▼                                                │
│                    ┌────────┴────────┐                                       │
│                    ▼                 ▼                                       │
│             RDS MariaDB        ElastiCache Redis                            │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## CI/CD Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              CI/CD Pipelines                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  API Repo ──────► API Pipeline                                              │
│  (Release)        │                                                          │
│                   ├─► Build ──► Approval ──► Migrate ──► Deploy             │
│                   │                              │         │                 │
│                   │                              ▼         ▼                 │
│                   │                            RDS     API, Worker,          │
│                   │                                    Scheduler, Reverb     │
│                                                                              │
│  Tenant Repo ───► Tenant Pipeline                                           │
│  (Release)        │                                                          │
│                   └─► Build ──► Approval ──► Deploy ──► Tenant              │
│                                                                              │
│  HQ Repo ───────► HQ Pipeline                                               │
│  (Release)        │                                                          │
│                   └─► Build ──► Approval ──► Deploy ──► HQ                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Updating Diagrams

When infrastructure changes:

1. Update `generate_aws_diagram.py` with new services/connections
2. Run `python generate_aws_diagram.py`
3. Commit the new PNG files to version control
4. Update related documentation if needed

## Diagram Best Practices

- **Use official AWS icons**: Helps with recognition and professionalism
- **Group by VPC/Region**: Show clear security boundaries
- **Color code by function**: 
  - Green: Ingress traffic
  - Blue: Internal traffic
  - Purple: Encryption
  - Dashed: Replication/Backup
- **Show data flow direction**: Use arrows to indicate traffic patterns
- **Label connections**: Add protocols, ports, or action descriptions
- **Keep it updated**: Regenerate after infrastructure changes

## Dependencies

```bash
pip install diagrams
```

The `diagrams` library automatically downloads official AWS icons on first run.

## Alternative Tools

### For Browser-Based Editing (No Installation)

Use [diagrams.net (draw.io)](https://app.diagrams.net/):
1. Go to https://app.diagrams.net/
2. File → New → Blank Diagram
3. Click "More Shapes" button
4. Enable "AWS19" or "AWS 2021" shape libraries
5. Drag and drop AWS service icons
6. Export as PNG/SVG/PDF

### For Professional 3D Renders

Use [Cloudcraft](https://cloudcraft.co/):
- Import live AWS infrastructure
- Generate 3D isometric views
- Export high-resolution images
