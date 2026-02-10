#!/usr/bin/env pwsh
# ==============================================================================
# Setup Script - CI/CD Configuration
# ==============================================================================
# Script para configurar automaticamente o CI/CD do QuickOrder Infrastructure
# ==============================================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$AwsAccessKeyId,
    
    [Parameter(Mandatory=$false)]
    [string]$AwsSecretAccessKey,
    
    [Parameter(Mandatory=$false)]
    [string]$InfracostApiKey,
    
    [Parameter(Mandatory=$false)]
    [string]$GithubToken
)

Write-Host "🚀 QuickOrder Infrastructure - CI/CD Setup" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# ==============================================================================
# Funções Auxiliares
# ==============================================================================

function Test-Command {
    param([string]$Command)
    try {
        Get-Command $Command -ErrorAction Stop | Out-Null
        return $true
    } catch {
        return $false
    }
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

function Write-Warning {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor Blue
}

# ==============================================================================
# 1. Verificar Pré-requisitos
# ==============================================================================

Write-Host "📋 Verificando pré-requisitos..." -ForegroundColor Yellow
Write-Host ""

$prerequisites = @{
    "git" = "Git"
    "gh" = "GitHub CLI"
    "aws" = "AWS CLI"
    "terraform" = "Terraform"
}

$missingTools = @()

foreach ($tool in $prerequisites.Keys) {
    if (Test-Command $tool) {
        Write-Success "$($prerequisites[$tool]) instalado"
    } else {
        Write-Error "$($prerequisites[$tool]) NÃO encontrado"
        $missingTools += $prerequisites[$tool]
    }
}

if ($missingTools.Count -gt 0) {
    Write-Host ""
    Write-Warning "Ferramentas faltando: $($missingTools -join ', ')"
    Write-Host ""
    Write-Host "Instale as ferramentas necessárias:" -ForegroundColor Cyan
    Write-Host "  - Git: https://git-scm.com/downloads"
    Write-Host "  - GitHub CLI: https://cli.github.com/"
    Write-Host "  - AWS CLI: https://aws.amazon.com/cli/"
    Write-Host "  - Terraform: https://www.terraform.io/downloads"
    Write-Host ""
    
    $continue = Read-Host "Deseja continuar mesmo assim? (s/N)"
    if ($continue -ne "s") {
        exit 1
    }
}

Write-Host ""

# ==============================================================================
# 2. Verificar Autenticação GitHub
# ==============================================================================

Write-Host "🔐 Verificando autenticação GitHub..." -ForegroundColor Yellow
Write-Host ""

if (Test-Command "gh") {
    $ghStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Success "GitHub CLI autenticado"
    } else {
        Write-Warning "GitHub CLI não autenticado"
        Write-Info "Execute: gh auth login"
        
        if (-not $GithubToken) {
            $authenticate = Read-Host "Deseja autenticar agora? (s/N)"
            if ($authenticate -eq "s") {
                gh auth login
            }
        }
    }
} else {
    Write-Warning "GitHub CLI não instalado - secrets precisarão ser configurados manualmente"
}

Write-Host ""

# ==============================================================================
# 3. Coletar Credenciais
# ==============================================================================

Write-Host "🔑 Configurando credenciais..." -ForegroundColor Yellow
Write-Host ""

# AWS Access Key ID
if (-not $AwsAccessKeyId) {
    Write-Info "AWS Access Key ID necessária para CI/CD"
    $AwsAccessKeyId = Read-Host "Digite AWS_ACCESS_KEY_ID (ou deixe em branco para pular)"
}

# AWS Secret Access Key
if (-not $AwsSecretAccessKey -and $AwsAccessKeyId) {
    $secureString = Read-Host "Digite AWS_SECRET_ACCESS_KEY" -AsSecureString
    $AwsSecretAccessKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
    )
}

# Infracost API Key
if (-not $InfracostApiKey) {
    Write-Info "Infracost API Key (opcional - para estimativa de custos)"
    Write-Info "Obtenha em: https://dashboard.infracost.io/"
    $InfracostApiKey = Read-Host "Digite INFRACOST_API_KEY (ou deixe em branco para pular)"
}

Write-Host ""

# ==============================================================================
# 4. Configurar GitHub Secrets
# ==============================================================================

Write-Host "📦 Configurando GitHub Secrets..." -ForegroundColor Yellow
Write-Host ""

if (Test-Command "gh") {
    $ghStatus = gh auth status 2>&1
    if ($LASTEXITCODE -eq 0) {
        
        # AWS_ACCESS_KEY_ID
        if ($AwsAccessKeyId) {
            try {
                Write-Host $AwsAccessKeyId | gh secret set AWS_ACCESS_KEY_ID
                Write-Success "AWS_ACCESS_KEY_ID configurado"
            } catch {
                Write-Error "Falha ao configurar AWS_ACCESS_KEY_ID: $_"
            }
        }
        
        # AWS_SECRET_ACCESS_KEY
        if ($AwsSecretAccessKey) {
            try {
                Write-Host $AwsSecretAccessKey | gh secret set AWS_SECRET_ACCESS_KEY
                Write-Success "AWS_SECRET_ACCESS_KEY configurado"
            } catch {
                Write-Error "Falha ao configurar AWS_SECRET_ACCESS_KEY: $_"
            }
        }
        
        # INFRACOST_API_KEY
        if ($InfracostApiKey) {
            try {
                Write-Host $InfracostApiKey | gh secret set INFRACOST_API_KEY
                Write-Success "INFRACOST_API_KEY configurado"
            } catch {
                Write-Error "Falha ao configurar INFRACOST_API_KEY: $_"
            }
        }
        
    } else {
        Write-Warning "GitHub CLI não autenticado - configure secrets manualmente"
        Write-Info "Acesse: Settings → Secrets and variables → Actions"
    }
} else {
    Write-Warning "Configure secrets manualmente no GitHub"
    Write-Info "Acesse: Settings → Secrets and variables → Actions"
}

Write-Host ""

# ==============================================================================
# 5. Configurar Ambientes GitHub
# ==============================================================================

Write-Host "🌍 Configurando ambientes GitHub..." -ForegroundColor Yellow
Write-Host ""

Write-Info "Ambientes necessários:"
Write-Host "  - production (para aprovação de deploys)"
Write-Host "  - destroy-prod (para aprovação de destruição)"
Write-Host "  - destroy-staging (para aprovação de destruição)"
Write-Host ""
Write-Warning "Ambientes devem ser configurados manualmente no GitHub"
Write-Info "Acesse: Settings → Environments → New environment"
Write-Host ""

$openBrowser = Read-Host "Deseja abrir o GitHub para configurar ambientes? (s/N)"
if ($openBrowser -eq "s") {
    $repo = git config --get remote.origin.url
    if ($repo -match "github.com[:/](.+/.+)\.git") {
        $repoPath = $matches[1]
        Start-Process "https://github.com/$repoPath/settings/environments"
    }
}

Write-Host ""

# ==============================================================================
# 6. Validar Workflows
# ==============================================================================

Write-Host "✅ Validando workflows..." -ForegroundColor Yellow
Write-Host ""

$workflowsDir = ".github/workflows"
$expectedWorkflows = @(
    "terraform-plan.yml",
    "terraform-apply.yml",
    "terraform-destroy.yml",
    "security-scan.yml",
    "cost-estimation.yml"
)

foreach ($workflow in $expectedWorkflows) {
    $path = Join-Path $workflowsDir $workflow
    if (Test-Path $path) {
        Write-Success "$workflow encontrado"
    } else {
        Write-Error "$workflow NÃO encontrado"
    }
}

Write-Host ""

# ==============================================================================
# 7. Testar Configuração AWS
# ==============================================================================

Write-Host "🔍 Testando configuração AWS..." -ForegroundColor Yellow
Write-Host ""

if (Test-Command "aws") {
    try {
        $identity = aws sts get-caller-identity --output json 2>&1 | ConvertFrom-Json
        Write-Success "AWS CLI configurado"
        Write-Info "Account: $($identity.Account)"
        Write-Info "User: $($identity.Arn)"
    } catch {
        Write-Warning "AWS CLI não configurado ou credenciais inválidas"
        Write-Info "Execute: aws configure"
    }
} else {
    Write-Warning "AWS CLI não instalado"
}

Write-Host ""

# ==============================================================================
# 8. Resumo Final
# ==============================================================================

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "📊 Resumo da Configuração" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "✅ Workflows criados:" -ForegroundColor Green
Write-Host "   - Terraform Plan (PR validation)"
Write-Host "   - Terraform Apply (Production deploy)"
Write-Host "   - Terraform Destroy (Infrastructure teardown)"
Write-Host "   - Security Scan (Daily security checks)"
Write-Host "   - Cost Estimation (Weekly cost analysis)"
Write-Host ""

if ($AwsAccessKeyId) {
    Write-Host "✅ Secrets configurados:" -ForegroundColor Green
    Write-Host "   - AWS_ACCESS_KEY_ID"
    Write-Host "   - AWS_SECRET_ACCESS_KEY"
    if ($InfracostApiKey) {
        Write-Host "   - INFRACOST_API_KEY"
    }
} else {
    Write-Host "⚠️  Secrets pendentes:" -ForegroundColor Yellow
    Write-Host "   - Configure manualmente em: Settings → Secrets → Actions"
}

Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Configure ambientes GitHub (se ainda não fez):"
Write-Host "   Settings → Environments → New environment"
Write-Host "   - production"
Write-Host "   - destroy-prod"
Write-Host "   - destroy-staging"
Write-Host ""
Write-Host "2. Teste o CI/CD:"
Write-Host "   git checkout -b test/cicd"
Write-Host "   # Faça uma alteração em terraform/"
Write-Host "   git add ."
Write-Host "   git commit -m 'test: CI/CD pipeline'"
Write-Host "   git push origin test/cicd"
Write-Host "   # Crie um Pull Request"
Write-Host ""
Write-Host "3. Monitore execução:"
Write-Host "   https://github.com/<org>/<repo>/actions"
Write-Host ""
Write-Host "4. Leia a documentação completa:"
Write-Host "   docs/CICD.md"
Write-Host ""

Write-Success "Setup concluído!"
Write-Host ""
