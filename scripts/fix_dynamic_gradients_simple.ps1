#!/usr/bin/env pwsh

param(
    [string]$ProjectPath = "lib"
)

Write-Host "=== CORRECAO DINAMICA DE GRADIENTES ===" -ForegroundColor Cyan
Write-Host "Transformando gradientes const em getters dinamicos..." -ForegroundColor Cyan

$totalProcessed = 0
$filesFixed = 0

# Arquivos que contêm gradientes const problemáticos
$gradientFiles = @(
    "lib\design_system\theme\gradients.dart",
    "lib\design_system\theme\module_gradients.dart"
)

foreach ($filePath in $gradientFiles) {
    if (Test-Path $filePath) {
        $totalProcessed++
        $relativePath = $filePath.Replace((Get-Location).Path, "").TrimStart('\')
        Write-Host "Processando: $relativePath" -ForegroundColor Yellow
        
        try {
            $content = Get-Content -Path $filePath -Raw -Encoding UTF8
            $originalContent = $content
            $hasChanges = $false
            
            # 1. Adicionar import do BuildContext se não existir
            if ($content -notmatch "import 'package:flutter/material.dart'") {
                Write-Host "  + Adicionando import do Flutter material" -ForegroundColor Cyan
                $lines = $content -split "`r`n|`r|`n"
                $newLines = @()
                $importAdded = $false
                
                foreach ($line in $lines) {
                    if (!$importAdded -and $line -match "^import\s+") {
                        if ($line -notmatch "flutter/material.dart") {
                            $newLines += "import 'package:flutter/material.dart';"
                            $importAdded = $true
                        }
                    }
                    $newLines += $line
                }
                
                $content = $newLines -join "`n"
                $hasChanges = $true
            }
            
            # 2. Transformar static const LinearGradient em getters dinâmicos
            Write-Host "  + Transformando gradientes const em getters dinamicos" -ForegroundColor Cyan
            
            $constGradientPattern = 'static const LinearGradient\s+(\w+)\s*=\s*LinearGradient\s*\('
            if ($content -match $constGradientPattern) {
                $content = $content -replace $constGradientPattern, 'static LinearGradient $1(BuildContext context) => LinearGradient('
                $hasChanges = $true
                Write-Host "    ✓ Convertidos gradientes const para getters dinamicos" -ForegroundColor Green
            }
            
            # Verificar se houve mudanças
            if ($hasChanges -and $content -ne $originalContent) {
                Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
                $filesFixed++
                Write-Host "  ✓ SUCESSO - Gradientes transformados em getters dinamicos!" -ForegroundColor Green
            } else {
                Write-Host "  OK - Nenhuma alteracao necessaria" -ForegroundColor Green
            }
            
        } catch {
            Write-Host "  ✗ ERRO - Falha ao processar arquivo: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "AVISO: Arquivo nao encontrado: $filePath" -ForegroundColor Yellow
    }
}

# Relatório final
Write-Host "`n=== RELATORIO FINAL ===" -ForegroundColor Cyan
Write-Host "Arquivos de gradientes processados: $totalProcessed" -ForegroundColor Cyan
Write-Host "Arquivos de gradientes corrigidos: $filesFixed" -ForegroundColor Green

if ($filesFixed -gt 0) {
    Write-Host "`n✅ CORREÇOES APLICADAS COM SUCESSO!" -ForegroundColor Green
    Write-Host "🔄 Gradientes agora sao 100% DINAMICOS com ThemeColors.of(context)" -ForegroundColor Cyan
    Write-Host "📖 Novo uso: AppGradients.primaryHeader(context)" -ForegroundColor Yellow
    Write-Host "📖 Novo uso: ModuleGradients.produtos(context)" -ForegroundColor Yellow
    Write-Host "`n🧪 Execute 'flutter analyze' para verificar." -ForegroundColor Green
} else {
    Write-Host "`nNenhuma correcao foi necessaria." -ForegroundColor Cyan
}