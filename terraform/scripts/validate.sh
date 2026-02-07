#!/bin/bash
# ==============================================================================
# Script de Validação - QuickOrder Infrastructure
# ==============================================================================

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║     QuickOrder - Validação de DNS e Infraestrutura            ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

DOMAIN="quickorderimpacta.com"
WWW_DOMAIN="www.quickorderimpacta.com"

echo "🔍 Testando DNS Records..."
echo ""

# Teste 1: Resolver DNS Principal
echo "1️⃣  Resolvendo: $DOMAIN"
dig +short $DOMAIN
echo ""

# Teste 2: Resolver DNS WWW
echo "2️⃣  Resolvendo: $WWW_DOMAIN"
dig +short $WWW_DOMAIN
echo ""

# Teste 3: Verificar Certificado SSL
echo "3️⃣  Verificando Certificado SSL..."
echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null | openssl x509 -noout -subject -dates
echo ""

# Teste 4: Teste HTTP (deve redirecionar para HTTPS)
echo "4️⃣  Testando Redirect HTTP → HTTPS..."
curl -I http://$DOMAIN 2>/dev/null | grep -i location
echo ""

# Teste 5: Teste HTTPS
echo "5️⃣  Testando HTTPS..."
curl -I https://$DOMAIN 2>/dev/null | head -n 1
echo ""

# Teste 6: Conteúdo da Página
echo "6️⃣  Verificando Conteúdo (deve conter 'QuickOrder')..."
curl -s https://$DOMAIN 2>/dev/null | grep -i "quickorder" | head -n 1
echo ""

# Teste 7: Health Check do ALB
echo "7️⃣  Status do Health Check..."
echo "   (Verificar no AWS Console: Target Groups → Targets → Health Status)"
echo ""

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                    Validação Completa                          ║"
echo "╚════════════════════════════════════════════════════════════════╝"
