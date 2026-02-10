# 🚀 CI/CD Pipeline - QuickOrder Infrastructure

## 📋 Visão Geral

Pipeline completo de CI/CD para infraestrutura AWS usando GitHub Actions e Terraform.

### **Workflows Implementados:**

1. **Terraform Plan** - Validação automática em Pull Requests
2. **Terraform Apply** - Deploy automático em produção
3. **Terraform Destroy** - Destruição controlada de infraestrutura
4. **Security Scan** - Análise de segurança automatizada
5. **Cost Estimation** - Monitoramento e estimativa de custos

---

## 🏗️ Arquitetura do CI/CD

```
┌─────────────────────────────────────────────────────────────┐
│                     DEVELOPER                                │
│                         │                                    │
│                         ▼                                    │
│              ┌──────────────────┐                           │
│              │  Create PR       │                           │
│              └────────┬─────────┘                           │
│                       │                                      │
│                       ▼                                      │
│         ┌─────────────────────────┐                         │
│         │  Terraform Plan         │                         │
│         │  - Validate             │                         │
│         │  - Security Scan        │                         │
│         │  - Cost Estimation      │                         │
│         │  - Comment on PR        │                         │
│         └────────┬────────────────┘                         │
│                  │                                           │
│                  ▼                                           │
│         ┌─────────────────┐                                 │
│         │  Code Review    │                                 │
│         └────────┬────────┘                                 │
│                  │                                           │
│                  ▼                                           │
│         ┌─────────────────┐                                 │
│         │  Merge to Main  │                                 │
│         └────────┬────────┘                                 │
│                  │                                           │
│                  ▼                                           │
│         ┌─────────────────────────┐                         │
│         │  Terraform Apply        │                         │
│         │  - Plan                 │                         │
│         │  - Manual Approval      │                         │
│         │  - Apply                │                         │
│         │  - Validation           │                         │
│         │  - Notification         │                         │
│         └─────────────────────────┘                         │
│                                                              │
│         ┌─────────────────────────┐                         │
│         │  Scheduled Jobs         │                         │
│         │  - Security Scan (Daily)│                         │
│         │  - Cost Check (Weekly)  │                         │
│         └─────────────────────────┘                         │
└─────────────────────────────────────────────────────────────┘
```

---

## ⚙️ Configuração Inicial

### **1. Secrets do GitHub**

Configure os seguintes secrets no repositório GitHub:

```bash
Settings → Secrets and variables → Actions → New repository secret
```

**Secrets Obrigatórios:**

| Secret | Descrição | Como Obter |
|--------|-----------|------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key | IAM Console → Users → Security credentials |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key | IAM Console → Users → Security credentials |
| `INFRACOST_API_KEY` | Infracost API Key | https://www.infracost.io/docs/integrations/github_actions/ |

**Como criar AWS Access Keys:**

```bash
# Via AWS CLI
aws iam create-access-key --user-name github-actions

# Ou via Console:
# 1. AWS Console → IAM → Users
# 2. Selecione o usuário (ou crie um novo)
# 3. Security credentials → Create access key
# 4. Escolha "Application running outside AWS"
# 5. Copie Access Key ID e Secret Access Key
```

**Permissões IAM Necessárias:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "vpc:*",
        "s3:*",
        "rds:*",
        "eks:*",
        "elasticache:*",
        "route53:*",
        "acm:*",
        "waf:*",
        "cloudwatch:*",
        "iam:*",
        "secretsmanager:*",
        "sqs:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
```

### **2. Configurar Infracost (Opcional mas Recomendado)**

```bash
# 1. Criar conta gratuita
https://dashboard.infracost.io/

# 2. Gerar API Key
Dashboard → Settings → API Keys → Create API Key

# 3. Adicionar ao GitHub Secrets
INFRACOST_API_KEY=ico-xxxxxxxxxxxxxxxx
```

### **3. Configurar Ambientes GitHub**

Para aprovação manual no deploy:

```bash
Settings → Environments → New environment
```

**Criar os seguintes ambientes:**

1. **production**
   - Required reviewers: Adicione usuários que devem aprovar
   - Wait timer: 0 minutes (ou defina um tempo de espera)

2. **destroy-prod**
   - Required reviewers: Adicione usuários que devem aprovar destruição
   - Wait timer: 5 minutes (tempo para cancelar se necessário)

3. **destroy-staging**
   - Required reviewers: Adicione usuários que devem aprovar

---

## 📝 Workflows Detalhados

### **1. Terraform Plan (Pull Request)**

**Trigger:** Automaticamente em PRs para `main` ou `develop`

**Funcionalidades:**
- ✅ Validação de sintaxe Terraform
- ✅ Formatação de código
- ✅ Security scan (Checkov + tfsec)
- ✅ Terraform plan
- ✅ Estimativa de custos (Infracost)
- ✅ Comentários automáticos no PR

**Exemplo de uso:**

```bash
# 1. Criar branch
git checkout -b feature/add-new-resource

# 2. Fazer alterações no Terraform
vim terraform/main.tf

# 3. Commit e push
git add .
git commit -m "feat: add new EC2 instance"
git push origin feature/add-new-resource

# 4. Criar Pull Request no GitHub
# O workflow será executado automaticamente
```

**Output esperado:**
- Comentário no PR com resultados da validação
- Comentário com terraform plan
- Comentário com security findings
- Comentário com estimativa de custos

---

### **2. Terraform Apply (Deploy Produção)**

**Trigger:** Automaticamente após merge na `main`

**Funcionalidades:**
- ✅ Pre-deployment checks
- ✅ Terraform plan
- ✅ Aprovação manual (ambiente production)
- ✅ Terraform apply
- ✅ Post-deployment validation
- ✅ Notificações

**Fluxo:**

```bash
# 1. Merge do PR aprovado
# 2. Workflow inicia automaticamente
# 3. Executa terraform plan
# 4. AGUARDA APROVAÇÃO MANUAL
# 5. Após aprovação, executa terraform apply
# 6. Valida recursos criados
# 7. Envia notificações
```

**Como aprovar deploy:**

```bash
# 1. Acesse: Actions → Terraform Apply → Running workflow
# 2. Clique em "Review deployments"
# 3. Selecione "production"
# 4. Clique em "Approve and deploy"
```

**Deploy manual (opcional):**

```bash
# Via GitHub UI:
Actions → Terraform Apply → Run workflow → Run workflow
```

---

### **3. Terraform Destroy (Destruição)**

**Trigger:** Manual apenas

**Funcionalidades:**
- ✅ Validação de confirmação
- ✅ Backup automático do estado
- ✅ Destroy plan
- ✅ Aprovação manual dupla
- ✅ Execução do destroy
- ✅ Verificação pós-destruição

**Como usar:**

```bash
# 1. Acesse: Actions → Terraform Destroy → Run workflow

# 2. Preencha os campos:
#    - Environment: prod ou staging
#    - Confirmation: Digite "DESTROY" (exatamente assim)
#    - Reason: "Motivo da destruição"

# 3. Clique em "Run workflow"

# 4. Aguarde aprovação manual (2 aprovações necessárias)

# 5. Infraestrutura será destruída
```

**⚠️ IMPORTANTE:**
- Backup do estado é salvo automaticamente por 365 dias
- Processo irreversível após aprovação
- Requer confirmação "DESTROY" exata

---

### **4. Security Scan (Diário)**

**Trigger:** 
- Diariamente às 3h UTC
- Push na main
- Manual

**Funcionalidades:**
- ✅ Checkov (compliance)
- ✅ tfsec (security issues)
- ✅ Trivy (vulnerabilities)
- ✅ Terraform compliance
- ✅ Integração com GitHub Security
- ✅ Criação automática de issues em falhas

**Resultados:**

```bash
# Visualizar resultados:
Security → Code scanning alerts

# Ou via artifacts:
Actions → Security Scan → Latest run → Artifacts
```

**Executar manualmente:**

```bash
Actions → Security Scan → Run workflow
```

---

### **5. Cost Estimation (Semanal)**

**Trigger:**
- Semanalmente às segundas 9h UTC
- Pull Requests
- Manual

**Funcionalidades:**
- ✅ Estimativa de custos mensais
- ✅ Comparação com baseline (em PRs)
- ✅ Alertas de threshold (>$150/mês)
- ✅ Recomendações FinOps
- ✅ Análise de tendências

**Visualizar custos:**

```bash
# Em PRs:
# - Comentário automático com diff de custos

# Em execuções agendadas:
Actions → Cost Estimation → Latest run → Summary
```

**Configurar threshold:**

Edite `.github/workflows/cost-estimation.yml`:

```yaml
- name: 'Check Cost Threshold'
  run: |
    THRESHOLD=150  # Altere este valor
```

---

## 🔧 Manutenção e Troubleshooting

### **Problemas Comuns**

#### **1. Erro: "Error acquiring the state lock"**

**Causa:** Outro processo está usando o state

**Solução:**

```bash
# Verificar locks no DynamoDB (se configurado)
aws dynamodb scan --table-name quickorder-terraform-locks

# Forçar unlock (USE COM CUIDADO)
terraform force-unlock <LOCK_ID>
```

#### **2. Erro: "Invalid AWS credentials"**

**Causa:** Secrets expirados ou incorretos

**Solução:**

```bash
# 1. Verificar secrets no GitHub
Settings → Secrets → Actions

# 2. Gerar novas credenciais
aws iam create-access-key --user-name github-actions

# 3. Atualizar secrets
```

#### **3. Workflow não executa**

**Causa:** Paths filter ou branch incorretos

**Solução:**

```yaml
# Verificar configuração do workflow
on:
  push:
    branches:
      - main  # Certifique-se que está na branch correta
    paths:
      - 'terraform/**'  # Alterações devem estar neste path
```

#### **4. Infracost falha**

**Causa:** API key inválida ou expirada

**Solução:**

```bash
# 1. Gerar nova API key em https://dashboard.infracost.io/
# 2. Atualizar secret INFRACOST_API_KEY
# 3. Re-executar workflow
```

---

## 📊 Monitoramento

### **Métricas Importantes**

1. **Deployment Frequency**
   - Quantos deploys por semana
   - Visualizar em: Actions → Terraform Apply

2. **Lead Time for Changes**
   - Tempo entre commit e deploy
   - Visualizar em: Insights → Actions

3. **Change Failure Rate**
   - % de deploys que falharam
   - Visualizar em: Actions → Workflows

4. **Mean Time to Recovery**
   - Tempo médio para rollback
   - Visualizar em: Actions → Terraform Destroy

### **Dashboards Recomendados**

```bash
# GitHub Insights
https://github.com/<org>/<repo>/pulse

# GitHub Actions
https://github.com/<org>/<repo>/actions

# AWS CloudWatch (após deploy)
https://console.aws.amazon.com/cloudwatch/
```

---

## 🚀 Próximos Passos

### **Melhorias Recomendadas**

1. **Notificações Slack/Discord**
   - Adicionar webhooks para notificações em tempo real

2. **Drift Detection**
   - Detectar mudanças manuais na infraestrutura

3. **Multi-Environment**
   - Adicionar ambientes dev, staging, prod

4. **Terraform Modules Registry**
   - Publicar módulos reutilizáveis

5. **Automated Rollback**
   - Rollback automático em caso de falha

---

## 📚 Referências

- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Infracost Documentation](https://www.infracost.io/docs/)
- [Checkov Documentation](https://www.checkov.io/documentation.html)
- [tfsec Documentation](https://aquasecurity.github.io/tfsec/)

---

## 🆘 Suporte

**Problemas ou dúvidas?**

1. Verifique os logs do workflow em Actions
2. Consulte esta documentação
3. Abra uma issue no repositório
4. Contate o time de DevOps

---

**Última atualização:** 2026-02-10
**Versão:** 1.0.0
