# Project Configuration
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "quickorder"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-2"
}

# Network Configuration
variable "vpc_cidr" {
  description = "CIDR block para VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2c"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks para subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_app_subnet_cidrs" {
  description = "CIDR blocks para subnets privadas de aplicação"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_db_subnet_cidrs" {
  description = "CIDR blocks para subnets privadas de banco de dados"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

# DNS Configuration
variable "domain_name" {
  description = "Nome do domínio (zona existente no Route 53)"
  type        = string
  default     = "quickorderimpacta.com"
}

# EC2 Configuration
variable "ec2_instance_type" {
  description = "Tipo de instância EC2 para Auto Scaling"
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Tamanho mínimo do Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Tamanho máximo do Auto Scaling Group"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Capacidade desejada do Auto Scaling Group"
  type        = number
  default     = 2
}

# EKS Configuration
variable "eks_cluster_version" {
  description = "Versão do EKS"
  type        = string
  default     = "1.28"
}

variable "eks_node_instance_type" {
  description = "Tipo de instância para nodes EKS"
  type        = string
  default     = "t3.small"
}

variable "eks_node_min_size" {
  description = "Número mínimo de nodes EKS"
  type        = number
  default     = 2
}

variable "eks_node_max_size" {
  description = "Número máximo de nodes EKS"
  type        = number
  default     = 4
}

variable "eks_node_desired_size" {
  description = "Número desejado de nodes EKS"
  type        = number
  default     = 2
}

# RDS Configuration
variable "rds_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Armazenamento alocado para RDS (GB)"
  type        = number
  default     = 20
}

variable "rds_engine_version" {
  description = "Versão do MySQL"
  type        = string
  default     = "8.0"
}

variable "rds_database_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "quickorder_db"
}

variable "rds_backup_retention_period" {
  description = "Período de retenção de backups (dias)"
  type        = number
  default     = 7
}

variable "rds_multi_az" {
  description = "Habilitar Multi-AZ para RDS"
  type        = bool
  default     = false # Otimizado para budget
}

# ElastiCache Configuration
variable "redis_node_type" {
  description = "Tipo de node para ElastiCache Redis"
  type        = string
  default     = "cache.t3.micro"
}

variable "redis_num_cache_nodes" {
  description = "Número de nodes Redis"
  type        = number
  default     = 1 # Otimizado para budget
}

variable "redis_engine_version" {
  description = "Versão do Redis"
  type        = string
  default     = "7.0"
}

# NAT Gateway Configuration
variable "single_nat_gateway" {
  description = "Usar apenas 1 NAT Gateway (economia de custos)"
  type        = bool
  default     = true # Otimizado para budget
}

# Monitoring Configuration
variable "enable_cloudwatch_alarms" {
  description = "Habilitar alarmes CloudWatch"
  type        = bool
  default     = true
}

variable "alarm_email" {
  description = "Email para receber alertas"
  type        = string
  default     = "" # Será configurado no tfvars
}

# Tags
variable "additional_tags" {
  description = "Tags adicionais para recursos"
  type        = map(string)
  default     = {}
}
