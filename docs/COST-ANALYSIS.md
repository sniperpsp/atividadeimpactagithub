# 💰 Análise de Custos - QuickOrder Infrastructure AWS

## 📊 Resumo Executivo

**Custo Total Estimado:**
- **Mensal:** USD $204.50
- **Anual:** USD $2,454.00

**Região:** us-east-2 (Ohio)  
**Ambiente:** Produção  
**Data da Análise:** 2026-02-10

---

## 📋 Tabela Detalhada de Custos Mensais

| # | Serviço AWS | Recurso | Especificação | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|---|-------------|---------|---------------|-----|-------------|--------------|-------------|
| **1** | **VPC & Networking** | | | | | **$32.85** | **$394.20** |
| 1.1 | NAT Gateway | Single NAT | 1 NAT Gateway (730h) | 1 | $32.85 | $32.85 | $394.20 |
| 1.2 | VPC | VPC Principal | 10.0.0.0/16 | 1 | $0.00 | $0.00 | $0.00 |
| 1.3 | Subnets | Public/Private | 6 subnets (2 AZs) | 6 | $0.00 | $0.00 | $0.00 |
| 1.4 | Internet Gateway | IGW | 1 Gateway | 1 | $0.00 | $0.00 | $0.00 |
| 1.5 | Route Tables | Routing | 3 route tables | 3 | $0.00 | $0.00 | $0.00 |
| **2** | **Compute - EKS** | | | | | **$103.00** | **$1,236.00** |
| 2.1 | EKS Control Plane | Cluster | quickorder-prod-eks-1 | 1 | $73.00 | $73.00 | $876.00 |
| 2.2 | EKS Worker Nodes | t3.micro SPOT | 2 nodes x 730h x $0.0104 | 2 | $15.00 | $30.00 | $360.00 |
| 2.3 | EBS Volumes | gp3 20GB | 2 volumes x 20GB x $0.08 | 2 | $0.00 | $3.20 | $38.40 |
| **3** | **Database - RDS** | | | | | **$15.33** | **$183.96** |
| 3.1 | RDS MySQL | db.t3.micro | Single-AZ (730h) | 1 | $13.14 | $13.14 | $157.68 |
| 3.2 | RDS Storage | gp3 20GB | 20GB x $0.115 | 1 | $2.30 | $2.30 | $27.60 |
| 3.3 | Backup Storage | Automated | 20GB x $0.095 (1 dia) | 1 | $0.00 | $1.90 | $22.80 |
| **4** | **Storage - S3** | | | | | **$1.15** | **$13.80** |
| 4.1 | S3 Bucket | Standard | Logs + Assets (50GB) | 1 | $1.15 | $1.15 | $13.80 |
| 4.2 | S3 Requests | PUT/GET | ~100k requests/mês | - | $0.00 | $0.50 | $6.00 |
| **5** | **DNS - Route 53** | | | | | **$1.00** | **$12.00** |
| 5.1 | Hosted Zone | quickorderimpacta.com | 1 zona | 1 | $0.50 | $0.50 | $6.00 |
| 5.2 | DNS Queries | Standard | ~1M queries/mês | - | $0.40 | $0.40 | $4.80 |
| 5.3 | Health Checks | Basic | 1 health check | 1 | $0.50 | $0.50 | $6.00 |
| **6** | **Security - ACM** | | | | | **$0.00** | **$0.00** |
| 6.1 | SSL Certificate | Public | quickorderimpacta.com | 1 | $0.00 | $0.00 | $0.00 |
| **7** | **Security - WAF** | | | | | **$6.00** | **$72.00** |
| 7.1 | WAF Web ACL | Protection | 1 Web ACL | 1 | $5.00 | $5.00 | $60.00 |
| 7.2 | WAF Rules | Basic Rules | 2 rules | 2 | $1.00 | $1.00 | $12.00 |
| **8** | **Messaging - SQS** | | | | | **$0.40** | **$4.80** |
| 8.1 | SQS Queue | Standard | ~1M requests/mês | 1 | $0.40 | $0.40 | $4.80 |
| **9** | **Secrets Manager** | | | | | **$0.80** | **$9.60** |
| 9.1 | Secrets | DB Credentials | 2 secrets | 2 | $0.40 | $0.80 | $9.60 |
| **10** | **Monitoring - CloudWatch** | | | | | **$10.00** | **$120.00** |
| 10.1 | Logs | Log Storage | 10GB x $0.50 | 1 | $5.00 | $5.00 | $60.00 |
| 10.2 | Metrics | Custom Metrics | 10 metrics x $0.30 | 10 | $3.00 | $3.00 | $36.00 |
| 10.3 | Alarms | CloudWatch Alarms | 5 alarms x $0.10 | 5 | $0.50 | $0.50 | $6.00 |
| 10.4 | Dashboards | Custom Dashboard | 1 dashboard | 1 | $3.00 | $3.00 | $36.00 |
| **11** | **Data Transfer** | | | | | **$15.00** | **$180.00** |
| 11.1 | Data Out | Internet | ~100GB/mês x $0.09 | - | $9.00 | $9.00 | $108.00 |
| 11.2 | Inter-AZ Transfer | Cross-AZ | ~50GB/mês x $0.01 | - | $0.50 | $0.50 | $6.00 |
| 11.3 | NAT Gateway Data | Processing | ~500GB x $0.045 | - | $22.50 | $22.50 | $270.00 |
| **12** | **Load Balancer - ALB** | | | | | **$18.97** | **$227.64** |
| 12.1 | ALB Hours | Application LB | 730h x $0.0225 | 1 | $16.43 | $16.43 | $197.16 |
| 12.2 | LCU Hours | Load Balancer Units | ~25 LCU x $0.008 | - | $5.84 | $5.84 | $70.08 |
| | | | | | | | |
| | | | | | **TOTAL** | **$204.50** | **$2,454.00** |

---

## 📊 Distribuição de Custos por Categoria

### Gráfico de Custos Mensais

| Categoria | Custo Mensal | % do Total | Barra Visual |
|-----------|--------------|------------|--------------|
| **EKS (Compute)** | $103.00 | 50.4% | ████████████████████████████████████████████████████ |
| **Networking** | $32.85 | 16.1% | ████████████████ |
| **Load Balancer** | $18.97 | 9.3% | █████████ |
| **RDS (Database)** | $15.33 | 7.5% | ████████ |
| **Data Transfer** | $15.00 | 7.3% | ███████ |
| **CloudWatch** | $10.00 | 4.9% | █████ |
| **WAF** | $6.00 | 2.9% | ███ |
| **S3** | $1.15 | 0.6% | █ |
| **Route 53** | $1.00 | 0.5% | █ |
| **Secrets Manager** | $0.80 | 0.4% | █ |
| **SQS** | $0.40 | 0.2% | █ |
| **ACM** | $0.00 | 0.0% | - |

---

## 💡 Análise de Custos por Componente

### **1. EKS (Kubernetes) - $103.00/mês (50.4%)**

**Maior custo da infraestrutura**

**Breakdown:**
- Control Plane: $73.00 (fixo)
- 2x Worker Nodes SPOT (t3.micro): $30.00
- EBS Volumes: $3.20

**Otimizações Aplicadas:**
✅ Uso de instâncias SPOT (economia de ~70%)
✅ t3.micro ao invés de t3.small (economia de ~50%)
✅ 2 nodes ao invés de 3+ (mínimo para HA)

**Otimizações Futuras:**
- Considerar Fargate para workloads específicos
- Implementar Cluster Autoscaler
- Usar Reserved Instances para nodes estáveis

---

### **2. Networking - $32.85/mês (16.1%)**

**Segundo maior custo**

**Breakdown:**
- NAT Gateway: $32.85 (730h x $0.045)

**Otimizações Aplicadas:**
✅ Single NAT Gateway (economia de $32.85/mês vs Multi-AZ)

**Trade-offs:**
⚠️ Se AZ-A cair, AZ-C perde acesso à internet
⚠️ Menor redundância

**Otimizações Futuras:**
- Considerar NAT Instance (economia de ~$25/mês)
- Avaliar necessidade de NAT para todos os workloads
- Usar VPC Endpoints para serviços AWS (reduz tráfego NAT)

---

### **3. Application Load Balancer - $18.97/mês (9.3%)**

**Breakdown:**
- ALB Hours: $16.43
- LCU (Load Balancer Capacity Units): $5.84

**Otimizações Aplicadas:**
✅ Single ALB compartilhado

**Otimizações Futuras:**
- Consolidar múltiplos serviços em um ALB
- Avaliar uso de NLB se aplicável (mais barato)

---

### **4. RDS MySQL - $15.33/mês (7.5%)**

**Breakdown:**
- Instância db.t3.micro: $13.14
- Storage gp3 20GB: $2.30
- Backup: $1.90

**Otimizações Aplicadas:**
✅ Single-AZ (economia de ~$15/mês vs Multi-AZ)
✅ db.t3.micro (menor instância)
✅ 1 dia de backup (mínimo)

**Trade-offs:**
⚠️ Sem failover automático
⚠️ Downtime em caso de falha de AZ

**Otimizações Futuras:**
- Considerar Aurora Serverless v2 para workloads variáveis
- Implementar read replicas apenas quando necessário
- Avaliar Reserved Instances (economia de ~40%)

---

### **5. Data Transfer - $15.00/mês (7.3%)**

**Breakdown:**
- Internet Out: $9.00
- NAT Gateway Processing: $22.50
- Inter-AZ: $0.50

**Otimizações Futuras:**
- Implementar CloudFront CDN (reduz data transfer)
- Otimizar tamanho de payloads
- Comprimir dados antes de transferir
- Usar VPC Endpoints para serviços AWS

---

### **6. CloudWatch - $10.00/mês (4.9%)**

**Breakdown:**
- Logs: $5.00
- Metrics: $3.00
- Dashboards: $3.00
- Alarms: $0.50

**Otimizações Futuras:**
- Implementar log retention policies
- Filtrar logs antes de enviar ao CloudWatch
- Usar métricas agregadas

---

## 📈 Projeção de Custos por Cenário

### **Cenário 1: Configuração Atual (Otimizada para Budget)**

| Período | Custo |
|---------|-------|
| **Mensal** | $204.50 |
| **Trimestral** | $613.50 |
| **Semestral** | $1,227.00 |
| **Anual** | $2,454.00 |

---

### **Cenário 2: Alta Disponibilidade (Multi-AZ)**

**Mudanças:**
- Multi-AZ NAT Gateway (+$32.85)
- RDS Multi-AZ (+$15.00)
- 3 EKS Nodes (+$15.00)

| Período | Custo | Diferença |
|---------|-------|-----------|
| **Mensal** | $267.35 | +$62.85 (+30.7%) |
| **Anual** | $3,208.20 | +$754.20 (+30.7%) |

---

### **Cenário 3: Produção Escalada (Tráfego Alto)**

**Mudanças:**
- 4 EKS Nodes (+$30.00)
- RDS db.t3.small (+$13.00)
- 100GB Storage (+$9.20)
- Data Transfer 500GB (+$36.00)

| Período | Custo | Diferença |
|---------|-------|-----------|
| **Mensal** | $292.70 | +$88.20 (+43.1%) |
| **Anual** | $3,512.40 | +$1,058.40 (+43.1%) |

---

### **Cenário 4: Máxima Economia (Dev/Staging)**

**Mudanças:**
- Remover EKS (-$103.00)
- Usar EC2 t3.micro x2 (+$14.60)
- RDS db.t3.micro mantido
- Remover WAF (-$6.00)

| Período | Custo | Diferença |
|---------|-------|-----------|
| **Mensal** | $110.10 | -$94.40 (-46.2%) |
| **Anual** | $1,321.20 | -$1,132.80 (-46.2%) |

---

## 💰 Oportunidades de Economia

### **Economia Imediata (0-30 dias)**

| Otimização | Economia Mensal | Economia Anual | Complexidade |
|------------|-----------------|----------------|--------------|
| Implementar log retention (7 dias) | $2.50 | $30.00 | Baixa |
| Remover métricas não utilizadas | $1.50 | $18.00 | Baixa |
| Otimizar tamanho de imagens Docker | $1.00 | $12.00 | Média |
| Implementar auto-shutdown em dev | $0.00 | $0.00 | Baixa |
| **Total Economia Imediata** | **$5.00** | **$60.00** | - |

---

### **Economia de Médio Prazo (1-3 meses)**

| Otimização | Economia Mensal | Economia Anual | Complexidade |
|------------|-----------------|----------------|--------------|
| Reserved Instances EKS (1 ano) | $21.90 | $262.80 | Média |
| Reserved Instances RDS (1 ano) | $5.25 | $63.00 | Média |
| Implementar CloudFront CDN | $4.50 | $54.00 | Média |
| VPC Endpoints (S3, ECR) | $3.00 | $36.00 | Média |
| Comprimir logs antes de enviar | $2.00 | $24.00 | Alta |
| **Total Economia Médio Prazo** | **$36.65** | **$439.80** | - |

---

### **Economia de Longo Prazo (3-6 meses)**

| Otimização | Economia Mensal | Economia Anual | Complexidade |
|------------|-----------------|----------------|--------------|
| Savings Plans (3 anos) | $30.90 | $370.80 | Alta |
| Migrar para NAT Instance | $25.00 | $300.00 | Alta |
| Aurora Serverless v2 | $8.00 | $96.00 | Alta |
| Spot Fleet para EKS | $10.00 | $120.00 | Alta |
| S3 Intelligent-Tiering | $0.50 | $6.00 | Baixa |
| **Total Economia Longo Prazo** | **$74.40** | **$892.80** | - |

---

## 🎯 Recomendações Estratégicas

### **Prioridade Alta (Implementar Agora)**

1. **Configurar Log Retention**
   - Economia: $30/ano
   - Esforço: 1 hora
   - ROI: Imediato

2. **Implementar Tagging Completo**
   - Economia: Visibilidade de custos
   - Esforço: 2 horas
   - ROI: Médio prazo

3. **Configurar Cost Anomaly Detection**
   - Economia: Prevenção de surpresas
   - Esforço: 1 hora
   - ROI: Imediato

---

### **Prioridade Média (1-3 meses)**

1. **Reserved Instances para EKS**
   - Economia: $262.80/ano
   - Esforço: 4 horas
   - ROI: 3 meses

2. **Implementar CloudFront**
   - Economia: $54/ano
   - Esforço: 8 horas
   - ROI: 6 meses

3. **VPC Endpoints**
   - Economia: $36/ano
   - Esforço: 4 horas
   - ROI: 4 meses

---

### **Prioridade Baixa (6+ meses)**

1. **Avaliar Savings Plans**
   - Economia: $370.80/ano
   - Esforço: 16 horas
   - ROI: 12 meses
   - Requer: Compromisso de 3 anos

2. **Migrar para NAT Instance**
   - Economia: $300/ano
   - Esforço: 12 horas
   - ROI: 8 meses
   - Trade-off: Menos managed

---

## 📊 Comparação com Alternativas

### **AWS vs Outras Clouds**

| Provedor | Custo Mensal | Custo Anual | Diferença |
|----------|--------------|-------------|-----------|
| **AWS (atual)** | $204.50 | $2,454.00 | Baseline |
| Google Cloud (GKE) | $189.00 | $2,268.00 | -7.6% |
| Azure (AKS) | $195.00 | $2,340.00 | -4.6% |
| DigitalOcean (DOKS) | $140.00 | $1,680.00 | -31.5% |

**Nota:** Comparação aproximada. Custos variam por região e configuração.

---

## 🔍 Monitoramento de Custos

### **KPIs Recomendados**

1. **Custo por Usuário Ativo**
   - Target: < $0.50/usuário/mês

2. **Custo por Request**
   - Target: < $0.0001/request

3. **Custo por GB Transferido**
   - Target: < $0.10/GB

4. **Utilização de Recursos**
   - Target: > 70% CPU/Memory

---

## 📅 Revisão de Custos

### **Frequência Recomendada**

| Atividade | Frequência | Responsável |
|-----------|------------|-------------|
| Review de custos diários | Diário | DevOps |
| Análise de anomalias | Semanal | FinOps |
| Otimização de recursos | Mensal | Tech Lead |
| Revisão de RI/SP | Trimestral | CTO |
| Planejamento anual | Anual | CFO |

---

## 🎓 Recursos Adicionais

### **Ferramentas de Monitoramento**

- ✅ AWS Cost Explorer
- ✅ AWS Budgets
- ✅ AWS Cost Anomaly Detection
- ✅ Infracost (CI/CD)
- ⏳ CloudHealth (futuro)
- ⏳ Kubecost (futuro)

### **Documentação**

- [AWS Pricing Calculator](https://calculator.aws/)
- [AWS Cost Optimization](https://aws.amazon.com/pricing/cost-optimization/)
- [FinOps Foundation](https://www.finops.org/)

---

## ✅ Checklist de FinOps

- [x] Tagging strategy implementada
- [x] Cost allocation tags configuradas
- [x] Budgets e alertas configurados
- [x] Infracost integrado ao CI/CD
- [ ] Reserved Instances analisadas
- [ ] Savings Plans avaliados
- [ ] CloudFront implementado
- [ ] VPC Endpoints configurados
- [ ] Log retention otimizada
- [ ] Cost anomaly detection ativo

---

**Última atualização:** 2026-02-10  
**Versão:** 1.0.0  
**Próxima revisão:** 2026-03-10
