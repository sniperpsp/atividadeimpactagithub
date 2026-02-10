# 🚀 QuickOrder Infrastructure - CI/CD Quick Start

## ⚡ Setup Rápido (5 minutos)

### **Passo 1: Configurar Secrets**

```bash
# Acesse o repositório no GitHub
Settings → Secrets and variables → Actions → New repository secret
```

**Adicione os seguintes secrets:**

| Nome | Valor | Onde obter |
|------|-------|------------|
| `AWS_ACCESS_KEY_ID` | Sua AWS Access Key | AWS Console → IAM → Users → Security credentials |
| `AWS_SECRET_ACCESS_KEY` | Sua AWS Secret Key | AWS Console → IAM → Users → Security credentials |
| `INFRACOST_API_KEY` | Sua Infracost API Key | https://dashboard.infracost.io/ (opcional) |

### **Passo 2: Configurar Ambientes**

```bash
# Acesse no GitHub
Settings → Environments → New environment
```

**Crie 3 ambientes:**

1. **production**
   - Add protection rule → Required reviewers → Adicione seu usuário
   
2. **destroy-prod**
   - Add protection rule → Required reviewers → Adicione seu usuário
   
3. **destroy-staging**
   - Add protection rule → Required reviewers → Adicione seu usuário

### **Passo 3: Testar CI/CD**

```bash
# 1. Criar branch de teste
git checkout -b test/cicd-setup

# 2. Fazer uma alteração mínima
echo "# CI/CD Test" >> terraform/README.md

# 3. Commit e push
git add .
git commit -m "test: CI/CD pipeline setup"
git push origin test/cicd-setup

# 4. Criar Pull Request no GitHub
# O workflow "Terraform Plan" será executado automaticamente
```

### **Passo 4: Verificar Execução**

```bash
# Acesse no GitHub
Actions → Terraform Plan → Latest run

# Você verá:
# ✅ Validate & Format
# ✅ Security Scan
# ✅ Terraform Plan
# ✅ Cost Estimation (se configurou Infracost)
```

---

## 📋 Workflows Disponíveis

### **1. Terraform Plan** (Automático em PRs)
- Valida código Terraform
- Executa security scan
- Mostra plano de mudanças
- Estima custos

### **2. Terraform Apply** (Automático após merge)
- Executa terraform apply
- Requer aprovação manual
- Valida recursos criados
- Envia notificações

### **3. Terraform Destroy** (Manual)
- Destrói infraestrutura
- Requer confirmação "DESTROY"
- Faz backup do estado
- Requer aprovação dupla

### **4. Security Scan** (Diário às 3h UTC)
- Checkov
- tfsec
- Trivy
- Cria issues em falhas

### **5. Cost Estimation** (Semanal às 9h UTC)
- Estima custos mensais
- Alerta se > $150/mês
- Recomendações FinOps

---

## 🎯 Uso Diário

### **Fazer Deploy**

```bash
# 1. Criar feature branch
git checkout -b feature/minha-feature

# 2. Fazer alterações
vim terraform/main.tf

# 3. Commit e push
git add .
git commit -m "feat: adicionar novo recurso"
git push origin feature/minha-feature

# 4. Criar PR no GitHub
# - Terraform Plan executa automaticamente
# - Revise os comentários no PR
# - Aguarde aprovação de código

# 5. Merge do PR
# - Terraform Apply executa automaticamente
# - Aguarde aprovação de deploy
# - Aprove em: Actions → Terraform Apply → Review deployments

# 6. Deploy concluído! 🎉
```

### **Destruir Infraestrutura**

```bash
# 1. Acesse: Actions → Terraform Destroy → Run workflow

# 2. Preencha:
#    Environment: prod
#    Confirmation: DESTROY
#    Reason: "Motivo da destruição"

# 3. Run workflow

# 4. Aguarde e aprove (2x)

# 5. Infraestrutura destruída
```

### **Executar Security Scan Manual**

```bash
# Acesse: Actions → Security Scan → Run workflow → Run workflow
```

### **Verificar Custos**

```bash
# Acesse: Actions → Cost Estimation → Run workflow → Run workflow
```

---

## 🔧 Troubleshooting Rápido

### **Workflow não executa**

```bash
# Verifique se:
# 1. Alterações estão em terraform/**
# 2. Branch está correta (main/develop)
# 3. Secrets estão configurados
```

### **Erro de credenciais AWS**

```bash
# 1. Verifique secrets no GitHub
Settings → Secrets → Actions

# 2. Teste localmente
aws sts get-caller-identity

# 3. Gere novas credenciais se necessário
aws iam create-access-key --user-name github-actions
```

### **Infracost falha**

```bash
# 1. Verifique se INFRACOST_API_KEY está configurado
# 2. Gere nova key em https://dashboard.infracost.io/
# 3. Atualize secret no GitHub
```

### **Deploy travado em aprovação**

```bash
# 1. Acesse: Actions → Terraform Apply → Running workflow
# 2. Clique em "Review deployments"
# 3. Selecione "production"
# 4. Clique em "Approve and deploy"
```

---

## 📊 Monitoramento

### **Ver histórico de deploys**

```bash
# GitHub
Actions → Terraform Apply → All workflows

# Ou via CLI
gh run list --workflow=terraform-apply.yml
```

### **Ver security findings**

```bash
# GitHub
Security → Code scanning alerts
```

### **Ver custos estimados**

```bash
# GitHub
Actions → Cost Estimation → Latest run → Summary
```

---

## 🚨 Comandos de Emergência

### **Cancelar deploy em andamento**

```bash
# Via GitHub UI
Actions → Running workflow → Cancel workflow

# Ou via CLI
gh run cancel <run-id>
```

### **Rollback rápido**

```bash
# 1. Reverter commit
git revert <commit-hash>
git push origin main

# 2. Aguardar deploy automático

# Ou destruir e recriar
Actions → Terraform Destroy → Run workflow
```

### **Forçar unlock do state**

```bash
# CUIDADO: Use apenas se tiver certeza
terraform force-unlock <LOCK_ID>
```

---

## 📚 Links Úteis

- **Documentação Completa:** [docs/CICD.md](./CICD.md)
- **GitHub Actions:** https://github.com/<org>/<repo>/actions
- **AWS Console:** https://console.aws.amazon.com/
- **Infracost Dashboard:** https://dashboard.infracost.io/

---

## ✅ Checklist de Setup

- [ ] Secrets configurados (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
- [ ] Ambiente "production" criado com required reviewers
- [ ] Ambiente "destroy-prod" criado com required reviewers
- [ ] Ambiente "destroy-staging" criado com required reviewers
- [ ] Infracost API Key configurado (opcional)
- [ ] Teste de PR executado com sucesso
- [ ] Teste de deploy executado com sucesso
- [ ] Equipe treinada nos workflows

---

## 🎓 Próximos Passos

1. ✅ Complete o setup básico
2. 📖 Leia a documentação completa em `docs/CICD.md`
3. 🧪 Execute um deploy de teste
4. 📊 Configure dashboards de monitoramento
5. 🔔 Configure notificações (Slack/Discord)
6. 📝 Documente processos específicos da equipe

---

**Dúvidas?** Consulte `docs/CICD.md` ou abra uma issue!

**Última atualização:** 2026-02-10
