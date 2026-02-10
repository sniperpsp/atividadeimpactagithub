# 🔧 CI/CD - Comandos Úteis e Referência Rápida

## 📋 Comandos Essenciais

### **Setup Inicial**

```bash
# Configurar secrets automaticamente
.\scripts\setup-cicd.ps1

# Ou manualmente via GitHub CLI
echo "YOUR_AWS_KEY" | gh secret set AWS_ACCESS_KEY_ID
echo "YOUR_AWS_SECRET" | gh secret set AWS_SECRET_ACCESS_KEY
echo "YOUR_INFRACOST_KEY" | gh secret set INFRACOST_API_KEY

# Verificar secrets configurados
gh secret list

# Criar ambiente de produção
# (Fazer via UI: Settings → Environments → New environment)
```

### **Workflow com Git**

```bash
# 1. Criar feature branch
git checkout -b feature/minha-feature

# 2. Fazer alterações
vim terraform/main.tf

# 3. Commit
git add .
git commit -m "feat: adicionar novo recurso"

# 4. Push
git push origin feature/minha-feature

# 5. Criar PR (via UI ou CLI)
gh pr create --title "Adicionar novo recurso" --body "Descrição"

# 6. Após aprovação, merge
gh pr merge --squash

# 7. Deploy automático será executado
```

### **Monitoramento de Workflows**

```bash
# Listar workflows
gh workflow list

# Ver execuções recentes
gh run list

# Ver execuções de um workflow específico
gh run list --workflow=terraform-apply.yml

# Ver detalhes de uma execução
gh run view <run-id>

# Ver logs de uma execução
gh run view <run-id> --log

# Baixar artefatos
gh run download <run-id>

# Cancelar execução em andamento
gh run cancel <run-id>

# Re-executar workflow falhado
gh run rerun <run-id>
```

### **Executar Workflows Manualmente**

```bash
# Terraform Destroy
gh workflow run terraform-destroy.yml \
  -f environment=prod \
  -f confirmation=DESTROY \
  -f reason="Motivo da destruição"

# Security Scan
gh workflow run security-scan.yml

# Cost Estimation
gh workflow run cost-estimation.yml
```

---

## 🔍 Troubleshooting

### **Verificar Status dos Secrets**

```bash
# Listar secrets
gh secret list

# Testar credenciais AWS localmente
aws sts get-caller-identity

# Testar Infracost localmente
infracost auth login
```

### **Verificar Logs de Erro**

```bash
# Ver última execução falhada
gh run list --workflow=terraform-apply.yml --status=failure --limit=1

# Ver logs completos
gh run view <run-id> --log

# Baixar logs para análise
gh run view <run-id> --log > workflow-logs.txt
```

### **Problemas Comuns**

```bash
# Erro: "Error acquiring the state lock"
# Solução: Forçar unlock (CUIDADO!)
cd terraform
terraform force-unlock <LOCK_ID>

# Erro: "Invalid AWS credentials"
# Solução: Verificar e atualizar secrets
gh secret set AWS_ACCESS_KEY_ID
gh secret set AWS_SECRET_ACCESS_KEY

# Erro: "Workflow não executa"
# Solução: Verificar se alterações estão em terraform/**
git diff --name-only HEAD^ HEAD | grep "^terraform/"
```

---

## 📊 Monitoramento

### **Verificar Custos**

```bash
# Ver última estimativa de custos
gh run list --workflow=cost-estimation.yml --limit=1

# Baixar relatório de custos
gh run download <run-id> --name cost-reports-*

# Ver relatório
cat cost-report.txt
```

### **Verificar Segurança**

```bash
# Ver últimos scans de segurança
gh run list --workflow=security-scan.yml --limit=5

# Baixar resultados SARIF
gh run download <run-id> --name checkov-results
gh run download <run-id> --name tfsec-results
gh run download <run-id> --name trivy-results

# Ver alertas de segurança no GitHub
# Security → Code scanning alerts
```

### **Verificar Deploys**

```bash
# Histórico de deploys
gh run list --workflow=terraform-apply.yml --limit=10

# Ver último deploy
gh run view $(gh run list --workflow=terraform-apply.yml --limit=1 --json databaseId --jq '.[0].databaseId')

# Verificar recursos na AWS
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=quickorder"
aws eks describe-cluster --name quickorder-prod-eks-1
```

---

## 🔄 Rollback

### **Rollback via Git Revert (Recomendado)**

```bash
# 1. Identificar commit problemático
git log --oneline

# 2. Reverter commit
git revert <commit-hash>

# 3. Push (dispara deploy automático)
git push origin main

# 4. Aguardar deploy automático
gh run watch
```

### **Rollback Manual**

```bash
# 1. Destruir recursos problemáticos
gh workflow run terraform-destroy.yml \
  -f environment=prod \
  -f confirmation=DESTROY \
  -f reason="Rollback de deploy com problemas"

# 2. Aguardar aprovação e destruição

# 3. Checkout commit anterior
git checkout <commit-hash-anterior>

# 4. Criar branch de rollback
git checkout -b rollback/fix-issue

# 5. Push e criar PR
git push origin rollback/fix-issue
gh pr create --title "Rollback: Fix issue"

# 6. Merge e deploy
```

### **Rollback de Estado (Emergência)**

```bash
# 1. Baixar backup do estado
gh run download <run-id> --name terraform-state-backup-*

# 2. Restaurar para S3
aws s3 cp state_backup_*.json s3://quickorder-s3/terraform/quickorder-prod.tfstate

# 3. Verificar estado
cd terraform
terraform state list

# 4. Aplicar estado anterior
terraform apply -var-file=environments/prod.tfvars
```

---

## 🚨 Comandos de Emergência

### **Cancelar Deploy em Andamento**

```bash
# Via CLI
gh run cancel $(gh run list --workflow=terraform-apply.yml --status=in_progress --limit=1 --json databaseId --jq '.[0].databaseId')

# Ou via UI
# Actions → Running workflow → Cancel workflow
```

### **Forçar Unlock do State**

```bash
# ⚠️ USE COM EXTREMO CUIDADO
cd terraform
terraform force-unlock <LOCK_ID>
```

### **Destruição de Emergência**

```bash
# Destruir tudo imediatamente (CUIDADO!)
cd terraform
terraform destroy -var-file=environments/prod.tfvars -auto-approve
```

---

## 📈 Métricas e Relatórios

### **DORA Metrics**

```bash
# Deployment Frequency
gh run list --workflow=terraform-apply.yml --status=success --created=">=2024-01-01" --json createdAt --jq 'length'

# Lead Time for Changes
# Calcular manualmente: tempo entre commit e deploy bem-sucedido

# Change Failure Rate
TOTAL=$(gh run list --workflow=terraform-apply.yml --limit=100 --json conclusion --jq 'length')
FAILED=$(gh run list --workflow=terraform-apply.yml --limit=100 --status=failure --json conclusion --jq 'length')
echo "scale=2; $FAILED / $TOTAL * 100" | bc

# Mean Time to Recovery
# Calcular manualmente: tempo entre falha e correção
```

### **Relatórios Personalizados**

```bash
# Gerar relatório de deploys do último mês
gh run list --workflow=terraform-apply.yml --created=">=2024-01-01" --json conclusion,createdAt,updatedAt --jq '.[] | {status: .conclusion, started: .createdAt, finished: .updatedAt}'

# Gerar relatório de custos
gh run list --workflow=cost-estimation.yml --limit=10 --json createdAt,conclusion

# Gerar relatório de segurança
gh run list --workflow=security-scan.yml --limit=10 --json createdAt,conclusion
```

---

## 🔧 Manutenção

### **Atualizar Workflows**

```bash
# Editar workflow
vim .github/workflows/terraform-apply.yml

# Commit e push
git add .github/workflows/
git commit -m "chore: update workflow"
git push origin main
```

### **Atualizar Secrets**

```bash
# Atualizar AWS credentials
echo "NEW_AWS_KEY" | gh secret set AWS_ACCESS_KEY_ID
echo "NEW_AWS_SECRET" | gh secret set AWS_SECRET_ACCESS_KEY

# Atualizar Infracost key
echo "NEW_INFRACOST_KEY" | gh secret set INFRACOST_API_KEY

# Remover secret
gh secret remove SECRET_NAME
```

### **Limpar Artefatos Antigos**

```bash
# Listar artefatos
gh api repos/:owner/:repo/actions/artifacts --jq '.artifacts[] | {id, name, created_at}'

# Deletar artefato específico
gh api -X DELETE repos/:owner/:repo/actions/artifacts/<artifact-id>
```

---

## 📚 Referências Rápidas

### **URLs Importantes**

```bash
# GitHub Actions
https://github.com/<org>/<repo>/actions

# GitHub Secrets
https://github.com/<org>/<repo>/settings/secrets/actions

# GitHub Environments
https://github.com/<org>/<repo>/settings/environments

# GitHub Security
https://github.com/<org>/<repo>/security/code-scanning

# AWS Console
https://console.aws.amazon.com/

# Infracost Dashboard
https://dashboard.infracost.io/
```

### **Documentação**

```bash
# Quick Start
docs/CICD-QUICKSTART.md

# Documentação Completa
docs/CICD.md

# Fluxos Visuais
docs/CICD-FLOW.md

# Resumo
docs/CICD-SUMMARY.md

# Este arquivo
docs/CICD-COMMANDS.md
```

---

## 🎯 Atalhos Úteis

### **Aliases Git (Opcional)**

```bash
# Adicionar ao ~/.gitconfig
[alias]
    cicd-test = "!git checkout -b test/cicd-$(date +%s) && echo '# CI/CD Test' >> terraform/README.md && git add . && git commit -m 'test: CI/CD' && git push origin HEAD"
    cicd-status = "!gh run list --workflow=terraform-apply.yml --limit=5"
    cicd-logs = "!gh run view $(gh run list --limit=1 --json databaseId --jq '.[0].databaseId') --log"
```

### **Aliases PowerShell (Opcional)**

```powershell
# Adicionar ao $PROFILE
function CICD-Status {
    gh run list --workflow=terraform-apply.yml --limit=5
}

function CICD-Logs {
    $runId = gh run list --limit=1 --json databaseId --jq '.[0].databaseId'
    gh run view $runId --log
}

function CICD-Watch {
    gh run watch
}
```

---

## ✅ Checklist de Operações

### **Deploy Normal**

- [ ] Criar feature branch
- [ ] Fazer alterações
- [ ] Commit e push
- [ ] Criar PR
- [ ] Aguardar validação (Terraform Plan)
- [ ] Revisar comentários no PR
- [ ] Aprovar PR (code review)
- [ ] Merge PR
- [ ] Aguardar execução do Terraform Apply
- [ ] Aprovar deploy (manual approval)
- [ ] Verificar deploy bem-sucedido
- [ ] Validar recursos na AWS

### **Rollback**

- [ ] Identificar problema
- [ ] Decidir estratégia (revert vs destroy)
- [ ] Executar rollback
- [ ] Aguardar aprovações necessárias
- [ ] Verificar rollback bem-sucedido
- [ ] Validar estado da infraestrutura
- [ ] Documentar incidente

### **Manutenção**

- [ ] Revisar security scans semanalmente
- [ ] Revisar cost reports mensalmente
- [ ] Atualizar credenciais a cada 90 dias
- [ ] Limpar artefatos antigos mensalmente
- [ ] Revisar e atualizar workflows trimestralmente

---

**Última atualização:** 2026-02-10  
**Versão:** 1.0.0
