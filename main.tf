module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  region             = var.region
  availability_zones = var.availability_zones
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "rds" {
  source = "./modules/rds"

  project_name                    = var.project_name
  environment                     = var.environment
  subnet_ids                      = module.vpc.data_subnet_ids
  security_group_id               = module.security.rds_sg_id
  db_username                     = var.db_username
  db_name                         = var.db_name
  manage_master_user_password     = var.manage_db_password
  db_password                     = var.db_password
  db_password_secret_arn_override = var.db_password_secret_arn_override
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  deletion_protection             = var.rds_deletion_protection
  max_allocated_storage           = var.rds_max_allocated_storage
}

module "elasticache" {
  source = "./modules/elasticache"

  project_name      = var.project_name
  environment       = var.environment
  subnet_ids        = module.vpc.data_subnet_ids
  security_group_id = module.security.redis_sg_id
}

module "alb" {
  source = "./modules/alb"

  project_name               = var.project_name
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  private_subnet_ids         = module.vpc.private_subnet_ids
  public_alb_sg_id           = module.security.public_alb_sg_id
  internal_alb_sg_id         = module.security.internal_alb_sg_id
  acm_certificate_arn        = var.acm_certificate_arn
  access_logs_bucket         = var.alb_access_logs_bucket
  web_acl_arn                = var.alb_web_acl_arn
  enable_deletion_protection = var.enable_alb_deletion_protection
  hq_host                    = var.hq_host
  reverb_host                = var.reverb_host
  api_host                   = var.api_host
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment
  region       = var.region
  vpc_id       = module.vpc.vpc_id

  api_repo_url    = module.ecr.api_repo_url
  tenant_repo_url = module.ecr.tenant_repo_url
  hq_repo_url     = module.ecr.hq_repo_url

  db_host         = module.rds.db_endpoint
  db_name         = module.rds.db_name
  db_username     = module.rds.db_username
  db_password_arn = module.rds.db_password_secret_arn

  redis_host           = module.elasticache.primary_endpoint_address
  redis_port           = module.elasticache.port
  redis_auth_token_arn = module.elasticache.redis_auth_token_secret_arn

  internal_alb_dns_name = module.alb.internal_alb_dns_name
  public_alb_dns_name   = module.alb.public_alb_dns_name

  private_subnet_ids = module.vpc.private_subnet_ids
  nuxt_sg_id         = module.security.nuxt_sg_id
  laravel_sg_id      = module.security.laravel_sg_id
  reverb_sg_id       = module.security.reverb_sg_id

  api_tg_arn        = module.alb.api_tg_arn
  api_public_tg_arn = module.alb.api_public_tg_arn
  tenant_tg_arn = module.alb.tenant_tg_arn
  hq_tg_arn     = module.alb.hq_tg_arn
  reverb_tg_arn = module.alb.reverb_tg_arn

  cors_allowed_origins         = var.cors_allowed_origins
  app_debug                    = var.app_debug
  octane_server                = var.octane_server
  sanctum_stateful_domains     = var.sanctum_stateful_domains
  session_domain               = var.session_domain
  nuxt_public_api_protocol     = var.nuxt_public_api_protocol
  nuxt_public_api_port         = var.nuxt_public_api_port
  extra_hosts                  = var.extra_hosts
  nuxt_api_base_server         = var.nuxt_api_base_server != "" ? var.nuxt_api_base_server : "http://${module.alb.internal_alb_dns_name}"
  app_key                      = var.app_key
  node_tls_reject_unauthorized = var.node_tls_reject_unauthorized
  api_image_tag                = var.api_image_tag
  tenant_image_tag             = var.tenant_image_tag
  hq_image_tag                 = var.hq_image_tag

  # New variables
  app_url               = var.app_url
  tenant_primary_domain = var.tenant_primary_domain
  reverb_app_id         = var.reverb_app_id
  reverb_app_key        = var.reverb_app_key
  reverb_app_secret     = var.reverb_app_secret
  reverb_public_host    = var.reverb_public_host

  # IAM policies
  tenant_bucket_provisioner_policy_arn = module.s3.tenant_bucket_provisioner_policy_arn
  tenant_bucket_data_access_policy_arn = module.s3.tenant_bucket_data_access_policy_arn
}

module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}

# CI/CD Module - AWS CodePipeline + CodeBuild (Separate pipelines per repository)
module "cicd" {
  source = "./modules/cicd"

  count = var.enable_cicd ? 1 : 0

  project_name   = var.project_name
  environment    = var.environment
  region         = var.region
  aws_account_id = data.aws_caller_identity.current.account_id

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  kms_key_arn        = var.cicd_kms_key_arn

  # GitHub Configuration (separate repository per service)
  api_github_repository    = var.api_github_repository
  tenant_github_repository = var.tenant_github_repository
  hq_github_repository     = var.hq_github_repository
  github_branch            = var.github_branch

  # ECR Repository Names
  api_repo_name    = module.ecr.api_repo_name
  tenant_repo_name = module.ecr.tenant_repo_name
  hq_repo_name     = module.ecr.hq_repo_name

  # Database Configuration (for API migrations only)
  db_host                = module.rds.db_endpoint
  db_name                = module.rds.db_name
  db_username            = module.rds.db_username
  db_password_secret_arn = module.rds.db_password_secret_arn
  app_key_secret_arn     = var.app_key_secret_arn

  # ECS Configuration
  ecs_cluster_name       = module.ecs.cluster_name
  api_service_name       = module.ecs.api_service_name
  tenant_service_name    = module.ecs.tenant_service_name
  hq_service_name        = module.ecs.hq_service_name
  worker_service_name    = module.ecs.worker_service_name
  scheduler_service_name = module.ecs.scheduler_service_name
  reverb_service_name    = module.ecs.reverb_service_name

  # Approval Configuration
  require_manual_approval = var.cicd_require_manual_approval
  approval_sns_topic_arn  = var.cicd_approval_sns_topic_arn
}

data "aws_caller_identity" "current" {}
