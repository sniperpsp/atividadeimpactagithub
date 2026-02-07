# VPC Outputs
output "vpc_id" {
  description = "ID da VPC"
  value       = module.networking.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block da VPC"
  value       = module.networking.vpc_cidr
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs das subnets privadas de aplicação"
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs das subnets privadas de banco de dados"
  value       = module.networking.private_db_subnet_ids
}

# Load Balancer Outputs
output "alb_dns_name" {
  description = "DNS name do Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID do Application Load Balancer"
  value       = module.compute.alb_zone_id
}

# DNS Outputs
output "website_url" {
  description = "URL do website"
  value       = "https://${var.domain_name}"
}

output "route53_zone_id" {
  description = "ID da Hosted Zone do Route 53"
  value       = module.dns.zone_id
}

output "route53_nameservers" {
  description = "Name servers do Route 53"
  value       = module.dns.nameservers
}

# RDS Outputs
output "rds_endpoint" {
  description = "Endpoint do RDS MySQL"
  value       = module.database.rds_endpoint
  sensitive   = true
}

output "rds_database_name" {
  description = "Nome do banco de dados"
  value       = module.database.database_name
}

output "rds_secret_arn" {
  description = "ARN do secret com credenciais RDS"
  value       = module.database.secret_arn
  sensitive   = true
}

# ElastiCache Outputs - REMOVIDO (não está no diagrama)
# output "redis_endpoint" {
#   description = "Endpoint do ElastiCache Redis"
#   value       = module.cache.redis_endpoint
#   sensitive   = true
# }

# output "redis_port" {
#   description = "Porta do Redis"
#   value       = module.cache.redis_port
# }


# SQS Outputs
output "sqs_queue_url" {
  description = "URL da fila SQS"
  value       = module.messaging.queue_url
}

output "sqs_queue_arn" {
  description = "ARN da fila SQS"
  value       = module.messaging.queue_arn
}

# S3 Outputs
output "s3_logs_bucket_name" {
  description = "Nome do bucket S3 de logs"
  value       = module.storage.logs_bucket_name
}

output "s3_logs_bucket_arn" {
  description = "ARN do bucket S3 de logs"
  value       = module.storage.logs_bucket_arn
}

# Certificate Output
output "acm_certificate_arn" {
  description = "ARN do certificado ACM"
  value       = module.dns.certificate_arn
}


# Summary Output
output "deployment_summary" {
  description = "Resumo do deployment"
  value       = <<-EOT
  
  ╔════════════════════════════════════════════════════════════════╗
  ║         QuickOrder Infrastructure - Deployment Summary         ║
  ╚════════════════════════════════════════════════════════════════╝
  
  🌐 Website URL:
     https://${var.domain_name}
  
  🔧 Application Load Balancer:
     ${module.compute.alb_dns_name}
  
  🗄️  Database (RDS MySQL):
     Endpoint: ${module.database.rds_endpoint}
     Database: ${module.database.database_name}
     Credentials: Stored in AWS Secrets Manager
  
  📨 Message Queue (SQS):
     ${module.messaging.queue_url}
  
  📦 Logs Bucket (S3):
     ${module.storage.logs_bucket_name}
  
  🔒 Security:
     WAF: Enabled
     SSL Certificate: Provisioned via ACM
     Secrets Manager: Configured
  
  ╔════════════════════════════════════════════════════════════════╗
  ║                      Next Steps                                ║
  ╚════════════════════════════════════════════════════════════════╝
  
  1. Wait for DNS propagation (~5-10 minutes)
  2. Access: https://${var.domain_name}
  5. Monitor via CloudWatch Dashboard
  
  EOT
}
