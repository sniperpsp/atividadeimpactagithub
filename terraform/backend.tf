# ==============================================================================
# Backend Configuration - Remote State no S3
# ==============================================================================
terraform {
  backend "s3" {
    bucket = "quickorder-s3"
    key    = "terraform/quickorder-prod.tfstate"
    region = "us-east-2"
    
    # Habilitar criptografia e versionamento
    encrypt        = true
    dynamodb_table = "quickorder-terraform-locks"  # Opcional: para lock de estado
    
    # Configurações adicionais de segurança
    # acl            = "private"
  }
}
