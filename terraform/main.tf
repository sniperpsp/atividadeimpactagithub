# ==============================================================================
# QuickOrder S.A - Infrastructure as Code
# ==============================================================================
# Descrição: Infraestrutura completa AWS para QuickOrder
# Ambiente: Production
# Região: us-east-2 (Ohio)
# Budget: ~$95/mês
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
# Cria VPC, Subnets, Internet Gateway, NAT Gateway, Route Tables
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
# Cria Security Groups
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
# Cria S3 bucket para logs
module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

# ==============================================================================
# DATABASE MODULE
# ==============================================================================
# Cria RDS MySQL Multi-AZ
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
    module.security.ec2_security_group_id,
    module.security.eks_node_security_group_id
  ]

  tags = local.common_tags

  depends_on = [module.networking, module.security]
}

# ==============================================================================
# CACHE MODULE
# ==============================================================================
# Cria ElastiCache Redis
module "cache" {
  source = "./modules/cache"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.private_app_subnet_ids
  node_type       = var.redis_node_type
  num_cache_nodes = var.redis_num_cache_nodes
  engine_version  = var.redis_engine_version
  allowed_security_group_ids = [
    module.security.ec2_security_group_id,
    module.security.eks_node_security_group_id
  ]

  tags = local.common_tags

  depends_on = [module.networking, module.security]
}

# ==============================================================================
# MESSAGING MODULE
# ==============================================================================
# Cria SQS Queue
module "messaging" {
  source = "./modules/messaging"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

# ==============================================================================
# DNS MODULE (Route 53 + ACM Certificate)
# ==============================================================================
# Cria certificado SSL ANTES do ALB
module "dns" {
  source = "./modules/dns"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  alb_dns_name = "" # Será atualizado depois
  alb_zone_id  = "" # Será atualizado depois

  tags = local.common_tags
}

# ==============================================================================
# COMPUTE MODULE (EC2 + ALB + Auto Scaling)
# ==============================================================================
# Cria Launch Template, Auto Scaling Group, ALB, Target Group
module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  private_subnet_ids    = module.networking.private_app_subnet_ids
  instance_type         = var.ec2_instance_type
  asg_min_size          = var.asg_min_size
  asg_max_size          = var.asg_max_size
  asg_desired_capacity  = var.asg_desired_capacity
  alb_security_group_id = module.security.alb_security_group_id
  ec2_security_group_id = module.security.ec2_security_group_id
  logs_bucket_name      = module.storage.logs_bucket_name
  certificate_arn       = module.dns.certificate_arn

  tags = local.common_tags

  depends_on = [module.networking, module.security, module.storage, module.dns]
}

# ==============================================================================
# EKS MODULE
# ==============================================================================
# Cria EKS Cluster e Node Group
module "eks" {
  source = "./modules/eks"

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.networking.vpc_id
  subnet_ids                = module.networking.private_app_subnet_ids
  cluster_version           = var.eks_cluster_version
  node_instance_type        = var.eks_node_instance_type
  node_min_size             = var.eks_node_min_size
  node_max_size             = var.eks_node_max_size
  node_desired_size         = var.eks_node_desired_size
  cluster_security_group_id = module.security.eks_cluster_security_group_id
  node_security_group_id    = module.security.eks_node_security_group_id

  tags = local.common_tags

  depends_on = [module.networking, module.security]
}

# ==============================================================================
# DNS RECORDS (Route 53 A Records)
# ==============================================================================
# Criar records DNS apontando para ALB DEPOIS que ALB existir
# Só cria se a zona Route 53 existir
resource "aws_route53_record" "main" {
  count   = var.domain_name != "" && length(module.dns.zone_id) > 0 ? 1 : 0
  zone_id = module.dns.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.compute.alb_dns_name
    zone_id                = module.compute.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.compute]
}

resource "aws_route53_record" "www" {
  count   = var.domain_name != "" && length(module.dns.zone_id) > 0 ? 1 : 0
  zone_id = module.dns.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.compute.alb_dns_name
    zone_id                = module.compute.alb_zone_id
    evaluate_target_health = true
  }

  depends_on = [module.compute]
}

