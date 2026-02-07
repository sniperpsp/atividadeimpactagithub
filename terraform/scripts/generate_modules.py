"""
Script para gerar todos os módulos Terraform restantes
"""

import os

# Diretório base
BASE_DIR = r"e:\AjudasIA\Atividade\quickorder-infrastructure\terraform\modules"

# ==============================================================================
# STORAGE MODULE
# ==============================================================================

storage_main = """# S3 Bucket para Logs
resource "aws_s3_bucket" "logs" {
  bucket_prefix = "${var.project_name}-${var.environment}-logs-"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-logs"
    }
  )
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "log-expiration"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }
}

# Policy para ALB escrever logs
resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSLogDeliveryWrite"
        Effect = "Allow"
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.logs.arn}/*"
      },
      {
        Sid    = "AWSLogDeliveryAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "elasticloadbalancing.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.logs.arn
      }
    ]
  })
}
"""

storage_variables = """variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
"""

storage_outputs = """output "logs_bucket_name" {
  value = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  value = aws_s3_bucket.logs.arn
}
"""

# ==============================================================================
# MESSAGING MODULE (SQS)
# ==============================================================================

messaging_main = """resource "aws_sqs_queue" "main" {
  name                       = "${var.project_name}-${var.environment}-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  sqs_managed_sse_enabled = true

  tags = var.tags
}

resource "aws_sqs_queue" "dlq" {
  name = "${var.project_name}-${var.environment}-dlq"

  sqs_managed_sse_enabled = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-dlq"
    }
  )
}

resource "aws_sqs_queue_redrive_policy" "main" {
  queue_url = aws_sqs_queue.main.id

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}
"""

messaging_variables = """variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
"""

messaging_outputs = """output "queue_url" {
  value = aws_sqs_queue.main.url
}

output "queue_arn" {
  value = aws_sqs_queue.main.arn
}

output "dlq_url" {
  value = aws_sqs_queue.dlq.url
}

output "dlq_arn" {
  value = aws_sqs_queue.dlq.arn
}
"""

# Escrever arquivos
modules = {
    "storage": {
        "main.tf": storage_main,
        "variables.tf": storage_variables,
        "outputs.tf": storage_outputs
    },
    "messaging": {
        "main.tf": messaging_main,
        "variables.tf": messaging_variables,
        "outputs.tf": messaging_outputs
    }
}

for module_name, files in modules.items():
    module_dir = os.path.join(BASE_DIR, module_name)
    os.makedirs(module_dir, exist_ok=True)
    
    for filename, content in files.items():
        filepath = os.path.join(module_dir, filename)
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"✅ Criado: {filepath}")

print("\n🎉 Módulos Storage e Messaging criados com sucesso!")
"""

<parameter name="Complexity">5
