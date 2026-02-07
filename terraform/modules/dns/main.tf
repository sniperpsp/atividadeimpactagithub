# Data source para pegar zona existente (se existir)
data "aws_route53_zone" "main" {
  count        = var.domain_name != "" ? 1 : 0
  name         = var.domain_name
  private_zone = false
}

# ==============================================================================
# CERTIFICADO SELF-SIGNED (para desenvolvimento/teste)
# ==============================================================================

# Chave privada
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Certificado self-signed
resource "tls_self_signed_cert" "main" {
  private_key_pem = tls_private_key.main.private_key_pem

  subject {
    common_name  = var.domain_name != "" ? var.domain_name : "quickorder.local"
    organization = "QuickOrder S.A"
  }

  validity_period_hours = 8760 # 1 ano

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

# Upload do certificado para ACM
resource "aws_acm_certificate" "main" {
  private_key      = tls_private_key.main.private_key_pem
  certificate_body = tls_self_signed_cert.main.cert_pem

  tags = var.tags
}


