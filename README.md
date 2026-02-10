# 🚀 QuickOrder Infrastructure - AWS Terraform

## 📋 Visão Geral

Infraestrutura completa AWS para **QuickOrder S.A** usando **Terraform**, seguindo as melhores práticas de:
- ✅ Alta Disponibilidade (Multi-AZ)
- ✅ Escalabilidade (Auto Scaling + EKS)
- ✅ Segurança (WAF, Secrets Manager, Security Groups)
- ✅ DevOps/DevSecOps (IaC, GitHub Actions)
- ✅ Observabilidade (CloudWatch, Logs)
- ✅ FinOps (Otimizado para ~$95/mês)

---

## 🏗️ Arquitetura

```
┌─────────────────────────────────────────────────────────────┐
│                         USUÁRIO                              │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
              ┌────────────────┐
              │   Route 53     │
              │ quickorderimpacta.com
              └────────┬───────┘
                       │
                       ▼
              ┌────────────────┐
              │      WAF       │ ← Proteção DDoS, SQL Injection
              └────────┬───────┘
                       │
                       ▼
              ┌────────────────┐
              │      ALB       │ ← HTTPS (ACM Certificate)
              └────────┬───────┘
                       │
        ┌──────────────┴──────────────┐
        │                             │
        ▼                             ▼
┌───────────────┐           ┌───────────────┐
│  Auto Scaling │           │  Auto Scaling │
│   Group (AZ-A)│           │   Group (AZ-C)│
│  EC2 (Nginx)  │           │  EC2 (Nginx)  │
└───────┬───────┘           └───────┬───────┘
        │                           │
        └──────────┬────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
        ▼                     ▼
┌──────────────┐      ┌──────────────┐
│ RDS MySQL    │      │ ElastiCache  │
│  (Single-AZ) │      │   Redis      │
└──────────────┘      └──────────────┘

┌─────────────────────────────────────┐
│         EKS Cluster                 │
│  ┌─────────┐      ┌─────────┐      │
│  │ Node AZ-A│      │ Node AZ-C│     │
│  └─────────┘      └─────────┘      │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│  S3 Logs  │  SQS Queue  │  Secrets  │
└─────────────────────────────────────┘
```

---

## 📁 Estrutura do Projeto

```
quickorder-infrastructure/
├── terraform/
│   ├── main.tf                 ✅ CRIADO
│   ├── variables.tf            ✅ CRIADO
│   ├── outputs.tf              ✅ CRIADO
│   ├── versions.tf             ✅ CRIADO
│   │
│   ├── modules/
│   │   ├── networking/         ✅ COMPLETO
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── security/           ✅ COMPLETO
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── storage/            ✅ COMPLETO
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   │
│   │   ├── compute/            ⏳ A COMPLETAR
│   │   ├── eks/                ⏳ A COMPLETAR
│   │   ├── database/           ⏳ A COMPLETAR
│   │   ├── cache/              ⏳ A COMPLETAR
│   │   ├── messaging/          ⏳ A COMPLETAR
│   │   └── dns/                ⏳ A COMPLETAR
│   │
│   ├── environments/
│   │   └── prod.tfvars         ✅ CRIADO
│   │
│   └── scripts/
│       ├── init.sh
│       └── destroy.sh
│
├── web/                        ⏳ A CRIAR
│   ├── index.html
│   ├── logo.png
│   └── style.css
│
├── docs/                       ⏳ A CRIAR
│   ├── ARCHITECTURE.md
│   ├── DECISIONS.md
│   ├── DEPLOYMENT.md
│   └── COSTS.md
│
├── .github/workflows/          ✅ COMPLETO
│   ├── terraform-plan.yml
│   ├── terraform-apply.yml
│   ├── terraform-destroy.yml
│   ├── security-scan.yml
│   └── cost-estimation.yml
│
├── README.md                   ✅ ESTE ARQUIVO
└── .gitignore
```

---

## ⚙️ Pré-requisitos

1. **AWS CLI** configurado
   ```bash
   aws configure
   ```

2. **Terraform** >= 1.6.0
   ```bash
   terraform version
   ```

3. **Credenciais AWS** com permissões:
   - VPC, EC2, RDS, ElastiCache
   - EKS, IAM, S3
   - Route 53, ACM, WAF
   - CloudWatch, Secrets Manager

4. **Zona Route 53** já criada:
   - `quickorderimpacta.com` ✅ (você já criou)

---

## 🚀 Como Usar

### 1. Clonar/Navegar para o projeto
```bash
cd e:\AjudasIA\Atividade\quickorder-infrastructure\terraform
```

### 2. Inicializar Terraform
```bash
terraform init
```

### 3. Validar configuração
```bash
terraform validate
```

### 4. Ver plano de execução
```bash
terraform plan -var-file=environments/prod.tfvars
```

### 5. Aplicar infraestrutura
```bash
terraform apply -var-file=environments/prod.tfvars
```

### 6. Destruir infraestrutura (quando necessário)
```bash
terraform destroy -var-file=environments/prod.tfvars
```

---

## 📝 STATUS ATUAL

### ✅ **MÓDULOS COMPLETOS:**

1. **Networking** - VPC, Subnets, IGW, NAT Gateway, Route Tables
2. **Security** - Security Groups, WAF
3. **Storage** - S3 Bucket para logs

### ⏳ **MÓDULOS A COMPLETAR:**

Devido ao volume de código, os seguintes módulos precisam ser criados. Vou fornecer templates:

#### 4. **Compute** (EC2 + ALB)
#### 5. **DNS** (Route 53 + ACM)
#### 6. **Database** (RDS MySQL)
#### 7. **Cache** (ElastiCache Redis)
#### 8. **EKS** (Kubernetes)
#### 9. **Messaging** (SQS)

---

## 🔧 PRÓXIMOS PASSOS

### Opção 1: **EU COMPLETO AGORA**
Me confirme e eu crio todos os módulos restantes.

### Opção 2: **VOCÊ USA TEMPLATES**
Posso fornecer templates prontos para você copiar.

### Opção 3: **DEPLOY PARCIAL**
Podemos fazer deploy apenas dos módulos prontos primeiro.

---

## 💰 Estimativa de Custos

### **Resumo de Custos**

| Período | Custo |
|---------|-------|
| **Mensal** | **$204.50** |
| **Anual** | **$2,454.00** |

### **Breakdown por Serviço**

| Serviço | Especificação | Custo Mensal | % Total |
|---------|---------------|--------------|---------|
| EKS Cluster | Control Plane + 2 Nodes SPOT | $103.00 | 50.4% |
| NAT Gateway | Single NAT (730h) | $32.85 | 16.1% |
| Application Load Balancer | ALB + LCU | $18.97 | 9.3% |
| RDS MySQL | db.t3.micro Single-AZ 20GB | $15.33 | 7.5% |
| Data Transfer | Internet + NAT Processing | $15.00 | 7.3% |
| CloudWatch | Logs + Metrics + Alarms | $10.00 | 4.9% |
| WAF | Web ACL + Rules | $6.00 | 2.9% |
| S3 | Storage + Requests | $1.15 | 0.6% |
| Route 53 | Hosted Zone + Queries | $1.00 | 0.5% |
| Secrets Manager | 2 Secrets | $0.80 | 0.4% |
| SQS | Standard Queue | $0.40 | 0.2% |
| ACM | SSL Certificate | $0.00 | 0.0% |

### **Documentação de Custos**

- **Resumo Visual:** [docs/COST-SUMMARY.md](docs/COST-SUMMARY.md)
- **Análise Completa:** [docs/COST-ANALYSIS.md](docs/COST-ANALYSIS.md)
  - Breakdown detalhado por serviço
  - Cenários de otimização
  - Oportunidades de economia
  - Recomendações FinOps

---

## 📚 Documentação

### Decisões Técnicas

**Por que Single NAT Gateway?**
- **Economia:** -$33/mês
- **Trade-off:** Se AZ-A cair, AZ-C perde acesso internet
- **Mitigação:** Baixo risco em produção AWS

**Por que RDS Single-AZ?**
- **Economia:** -$15/mês
- **Trade-off:** Sem failover automático
- **Mitigação:** Backups automáticos + restore rápido

**Por que EKS t3.small?**
- **Economia:** -$30/mês vs t3.medium
- **Suficiente:** Para demonstração e workloads leves

---

## 🔄 CI/CD Pipeline

### **⚠️ MODO DRY-RUN ATIVADO**

O pipeline está configurado em **modo de proteção** para não modificar o ambiente em produção:

- ✅ **Terraform Plan** - Funciona normalmente (validação apenas)
- ⚠️ **Terraform Apply** - Modo Dry-Run (simula sem aplicar)
- ❌ **Terraform Destroy** - Completamente desabilitado
- ✅ **Security Scan** - Funciona normalmente
- ✅ **Cost Estimation** - Funciona normalmente

**📖 Documentação Completa:** [docs/CICD-DRYRUN.md](docs/CICD-DRYRUN.md)

---

### **✅ Workflows Implementados**

Pipeline completo de CI/CD usando GitHub Actions:

1. **Terraform Plan** - Validação automática em Pull Requests
   - Validação de sintaxe e formatação
   - Security scan (Checkov + tfsec + Trivy)
   - Terraform plan com comentários no PR
   - Estimativa de custos (Infracost)

2. **Terraform Apply** - Deploy automático em produção
   - Execução após merge na main
   - Aprovação manual obrigatória
   - Validação pós-deploy
   - Notificações automáticas

3. **Terraform Destroy** - Destruição controlada
   - Workflow manual apenas
   - Backup automático do estado
   - Dupla aprovação necessária
   - Logs completos

4. **Security Scan** - Análise de segurança
   - Execução diária às 3h UTC
   - Integração com GitHub Security
   - Criação automática de issues em falhas

5. **Cost Estimation** - Monitoramento de custos
   - Execução semanal às 9h UTC
   - Alertas de threshold (>$150/mês)
   - Recomendações FinOps

### **🚀 Quick Start**

```bash
# 1. Configure secrets no GitHub
Settings → Secrets → Actions → New repository secret
# - AWS_ACCESS_KEY_ID
# - AWS_SECRET_ACCESS_KEY
# - INFRACOST_API_KEY (opcional)

# 2. Configure ambientes
Settings → Environments → New environment
# - production (com required reviewers)
# - destroy-prod (com required reviewers)
# - destroy-staging (com required reviewers)

# 3. Teste o CI/CD
git checkout -b test/cicd
# Faça alterações em terraform/
git add . && git commit -m "test: CI/CD"
git push origin test/cicd
# Crie um Pull Request

# 4. Monitore
# Actions → Terraform Plan → Latest run
```

### **📚 Documentação**

- **Quick Start:** [docs/CICD-QUICKSTART.md](docs/CICD-QUICKSTART.md)
- **Documentação Completa:** [docs/CICD.md](docs/CICD.md)
- **Script de Setup:** [scripts/setup-cicd.ps1](scripts/setup-cicd.ps1)

---

## 🎯 PRÓXIMOS PASSOS

1. ✅ **CI/CD Configurado** - Workflows prontos para uso
2. **Completar módulos Terraform** - Compute, Database, Cache, etc.
3. **Criar página web** - HTML + Logo QuickOrder
4. **Criar documentação adicional** - ARCHITECTURE.md, DECISIONS.md
5. **Deploy em produção** - Testar infraestrutura completa

**Me diga o que prefere fazer agora! 🚀**
