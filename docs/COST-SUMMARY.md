# 💰 Resumo de Custos - QuickOrder Infrastructure

## 📊 Visão Geral

```
┌─────────────────────────────────────────────────────────────┐
│                    CUSTO TOTAL ESTIMADO                      │
│                                                              │
│              Mensal: USD $204.50                             │
│              Anual:  USD $2,454.00                           │
│                                                              │
│              Região: us-east-2 (Ohio)                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 📋 Tabela Resumida - Custos Mensais e Anuais

| Serviço | Especificação | Custo Mensal | Custo Anual | % Total |
|---------|---------------|--------------|-------------|---------|
| **EKS Cluster** | Control Plane + 2 Nodes SPOT | $103.00 | $1,236.00 | 50.4% |
| **NAT Gateway** | Single NAT (730h) | $32.85 | $394.20 | 16.1% |
| **Application Load Balancer** | ALB + LCU | $18.97 | $227.64 | 9.3% |
| **RDS MySQL** | db.t3.micro Single-AZ 20GB | $15.33 | $183.96 | 7.5% |
| **Data Transfer** | Internet + NAT Processing | $15.00 | $180.00 | 7.3% |
| **CloudWatch** | Logs + Metrics + Alarms | $10.00 | $120.00 | 4.9% |
| **WAF** | Web ACL + Rules | $6.00 | $72.00 | 2.9% |
| **S3** | Storage + Requests | $1.15 | $13.80 | 0.6% |
| **Route 53** | Hosted Zone + Queries | $1.00 | $12.00 | 0.5% |
| **Secrets Manager** | 2 Secrets | $0.80 | $9.60 | 0.4% |
| **SQS** | Standard Queue | $0.40 | $4.80 | 0.2% |
| **ACM** | SSL Certificate | $0.00 | $0.00 | 0.0% |
| | | | | |
| **TOTAL** | | **$204.50** | **$2,454.00** | **100%** |

---

## 📊 Breakdown Detalhado por Serviço

### **1. EKS (Kubernetes) - $103.00/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| Control Plane | 1 | $73.00 | $73.00 | $876.00 |
| Worker Nodes (t3.micro SPOT) | 2 | $15.00 | $30.00 | $360.00 |
| EBS Volumes (gp3 20GB) | 2 | $1.60 | $3.20 | $38.40 |
| **Subtotal** | | | **$106.20** | **$1,274.40** |

---

### **2. Networking - $32.85/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| NAT Gateway (730h) | 1 | $32.85 | $32.85 | $394.20 |
| VPC | 1 | $0.00 | $0.00 | $0.00 |
| Subnets | 6 | $0.00 | $0.00 | $0.00 |
| Internet Gateway | 1 | $0.00 | $0.00 | $0.00 |
| **Subtotal** | | | **$32.85** | **$394.20** |

---

### **3. Load Balancer - $18.97/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| ALB Hours (730h) | 1 | $16.43 | $16.43 | $197.16 |
| LCU Hours | ~25 | $0.23 | $5.84 | $70.08 |
| **Subtotal** | | | **$22.27** | **$267.24** |

---

### **4. RDS MySQL - $15.33/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| db.t3.micro (730h) | 1 | $13.14 | $13.14 | $157.68 |
| Storage gp3 (20GB) | 1 | $2.30 | $2.30 | $27.60 |
| Backup (20GB x 1 dia) | 1 | $1.90 | $1.90 | $22.80 |
| **Subtotal** | | | **$17.34** | **$208.08** |

---

### **5. Data Transfer - $15.00/mês**

| Item | Volume | Taxa | Custo Mensal | Custo Anual |
|------|--------|------|--------------|-------------|
| Internet Out | 100GB | $0.09/GB | $9.00 | $108.00 |
| NAT Processing | 500GB | $0.045/GB | $22.50 | $270.00 |
| Inter-AZ | 50GB | $0.01/GB | $0.50 | $6.00 |
| **Subtotal** | | | **$32.00** | **$384.00** |

---

### **6. CloudWatch - $10.00/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| Log Storage (10GB) | 1 | $5.00 | $5.00 | $60.00 |
| Custom Metrics | 10 | $0.30 | $3.00 | $36.00 |
| Alarms | 5 | $0.10 | $0.50 | $6.00 |
| Dashboards | 1 | $3.00 | $3.00 | $36.00 |
| **Subtotal** | | | **$11.50** | **$138.00** |

---

### **7. WAF - $6.00/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| Web ACL | 1 | $5.00 | $5.00 | $60.00 |
| Rules | 2 | $1.00 | $1.00 | $12.00 |
| **Subtotal** | | | **$6.00** | **$72.00** |

---

### **8. S3 - $1.15/mês**

| Item | Volume | Taxa | Custo Mensal | Custo Anual |
|------|--------|------|--------------|-------------|
| Storage Standard | 50GB | $0.023/GB | $1.15 | $13.80 |
| Requests (PUT/GET) | 100k | $0.005/1k | $0.50 | $6.00 |
| **Subtotal** | | | **$1.65** | **$19.80** |

---

### **9. Route 53 - $1.00/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| Hosted Zone | 1 | $0.50 | $0.50 | $6.00 |
| DNS Queries (1M) | 1 | $0.40 | $0.40 | $4.80 |
| Health Checks | 1 | $0.50 | $0.50 | $6.00 |
| **Subtotal** | | | **$1.40** | **$16.80** |

---

### **10. Secrets Manager - $0.80/mês**

| Item | Qtd | Custo Unit. | Custo Mensal | Custo Anual |
|------|-----|-------------|--------------|-------------|
| Secrets | 2 | $0.40 | $0.80 | $9.60 |
| **Subtotal** | | | **$0.80** | **$9.60** |

---

### **11. SQS - $0.40/mês**

| Item | Volume | Taxa | Custo Mensal | Custo Anual |
|------|--------|------|--------------|-------------|
| Requests | 1M | $0.40/1M | $0.40 | $4.80 |
| **Subtotal** | | | **$0.40** | **$4.80** |

---

## 📊 Comparação de Cenários

| Cenário | Descrição | Custo Mensal | Custo Anual | vs Atual |
|---------|-----------|--------------|-------------|----------|
| **Atual** | Configuração otimizada | $204.50 | $2,454.00 | - |
| **Alta Disponibilidade** | Multi-AZ completo | $267.35 | $3,208.20 | +30.7% |
| **Produção Escalada** | Tráfego alto | $292.70 | $3,512.40 | +43.1% |
| **Máxima Economia** | Dev/Staging | $110.10 | $1,321.20 | -46.2% |

---

## 💡 Top 5 Oportunidades de Economia

| # | Otimização | Economia Anual | Esforço | Prioridade |
|---|------------|----------------|---------|------------|
| 1 | Reserved Instances EKS | $262.80 | Médio | Alta |
| 2 | Migrar para NAT Instance | $300.00 | Alto | Média |
| 3 | Reserved Instances RDS | $63.00 | Médio | Alta |
| 4 | Implementar CloudFront | $54.00 | Médio | Média |
| 5 | VPC Endpoints | $36.00 | Médio | Média |
| | **Total Potencial** | **$715.80** | | |

---

## 🎯 Resumo Executivo

### **Custos Atuais**
- ✅ **Mensal:** $204.50
- ✅ **Anual:** $2,454.00

### **Principais Componentes**
1. EKS (50.4%) - $103.00/mês
2. Networking (16.1%) - $32.85/mês
3. Load Balancer (9.3%) - $18.97/mês

### **Otimizações Aplicadas**
- ✅ SPOT Instances para EKS (-70% vs On-Demand)
- ✅ Single NAT Gateway (-50% vs Multi-AZ)
- ✅ RDS Single-AZ (-50% vs Multi-AZ)
- ✅ t3.micro instances (menor custo)

### **Próximos Passos**
1. Implementar Reserved Instances (economia de $325/ano)
2. Configurar CloudFront CDN (economia de $54/ano)
3. Adicionar VPC Endpoints (economia de $36/ano)

---

**Para análise completa, consulte:** [`COST-ANALYSIS.md`](./COST-ANALYSIS.md)

**Última atualização:** 2026-02-10
