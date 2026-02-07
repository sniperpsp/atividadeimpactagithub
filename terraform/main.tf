# ==============================================================================
# QuickOrder S.A - Infrastructure as Code
# ==============================================================================
# Descrição: Infraestrutura completa AWS para QuickOrder
# Ambiente: Production
# Região: us-east-2 (Ohio)
# ==============================================================================

# Dados locais para uso nos módulos
locals {
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.additional_tags
  )

  name_prefix = "${var.project_name}-${var.environment}"
}

# ==============================================================================
# NETWORKING MODULE
# ==============================================================================
module "networking" {
  source = "./modules/networking"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  single_nat_gateway       = var.single_nat_gateway

  tags = local.common_tags
}

# ==============================================================================
# SECURITY MODULE
# ==============================================================================
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id

  tags = local.common_tags

  depends_on = [module.networking]
}

# ==============================================================================
# STORAGE MODULE
# ==============================================================================
module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

# ==============================================================================
# DATABASE MODULE
# ==============================================================================
module "database" {
  source = "./modules/database"

  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.networking.vpc_id
  subnet_ids              = module.networking.private_db_subnet_ids
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  engine_version          = var.rds_engine_version
  database_name           = var.rds_database_name
  backup_retention_period = var.rds_backup_retention_period
  multi_az                = var.rds_multi_az
  allowed_security_group_ids = [
    #module.security.ec2_security_group_id
  ]

  tags = local.common_tags

  depends_on = [module.networking, module.security]
}

# ==============================================================================
# CACHE MODULE - REMOVIDO (não está no diagrama)
# ==============================================================================
# module "cache" {
#   source = "./modules/cache"
#   ... (removido)
# }

module "messaging" {
  source = "./modules/messaging"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

# ==============================================================================
# DNS MODULE (Route 53 + ACM Certificate)
# ==============================================================================
module "dns" {
  source = "./modules/dns"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  alb_dns_name = ""
  alb_zone_id  = ""

  tags = local.common_tags
}

# ==============================================================================
# COMPUTE MODULE - REMOVIDO (ALB e EC2 foram deletados)
# ==============================================================================
# module "compute" {
#   ...
# }
