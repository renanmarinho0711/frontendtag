#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Corrige problemas de ThemeColors.of(context) em contextos const

.DESCRIPTION
    Este script corrige erros onde ThemeColors.of(context) foi usado em contextos const,
    transformando-os em getters estáticos que requerem context como parâmetro
#>

param(
    [string]$ProjectPath = "lib"
)

Write-Host "=== CORRECAO DE PROBLEMAS CONST + THEMECOLORS ===" -ForegroundColor Cyan
Write-Host "Iniciando correcao de gradientes const..." -ForegroundColor Cyan

$totalProcessed = 0
$filesFixed = 0

# Arquivos específicos que sabemos ter problemas
$problemFiles = @(
    "lib\design_system\theme\gradients.dart",
    "lib\design_system\theme\module_gradients.dart"
)

foreach ($filePath in $problemFiles) {
    if (Test-Path $filePath) {
        $totalProcessed++
        Write-Host "Processando: $filePath" -ForegroundColor Yellow
        
        try {
            $content = Get-Content -Path $filePath -Raw -Encoding UTF8
            $originalContent = $content
            
            # Padrao 1: static const LinearGradient nome = LinearGradient( -> static LinearGradient nome(BuildContext context) => LinearGradient(
            $pattern1 = 'static const LinearGradient (\w+) = LinearGradient\('
            $replacement1 = 'static LinearGradient $1(BuildContext context) => LinearGradient('
            
            $content = $content -replace $pattern1, $replacement1
            
            # Padrao 2: Adicionar import do BuildContext se nao existir
            if ($content -match 'BuildContext context' -and $content -notmatch 'import.*flutter/material\.dart') {
                if ($content -notmatch 'import.*flutter.*') {
                    # Adicionar import do material.dart
                    $lines = $content -split "`r`n|`r|`n"
                    $newLines = @()
                    $importAdded = $false
                    
                    foreach ($line in $lines) {
                        if (!$importAdded -and $line -match "^import\s+") {
                            $newLines += "import 'package:flutter/material.dart';"
                            $importAdded = $true
                        }
                        $newLines += $line
                    }
                    
                    if ($importAdded) {
                        $content = $newLines -join "`n"
                    }
                }
            }
            
            # Verificar se houve mudancas
            if ($content -ne $originalContent) {
                Set-Content -Path $filePath -Value $content -Encoding UTF8 -NoNewline
                $filesFixed++
                Write-Host "  CORRIGIDO - Transformados gradientes const em getters com context" -ForegroundColor Green
            } else {
                Write-Host "  OK - Nenhuma correcao necessaria" -ForegroundColor Green
            }
            
        } catch {
            Write-Host "  ERRO - Erro ao processar arquivo: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "AVISO: Arquivo nao encontrado: $filePath" -ForegroundColor Yellow
    }
}

# Relatório final
Write-Host "`n=== RELATORIO FINAL ===" -ForegroundColor Cyan
Write-Host "Arquivos processados: $totalProcessed" -ForegroundColor Cyan
Write-Host "Arquivos corrigidos: $filesFixed" -ForegroundColor Green

if ($filesFixed -gt 0) {
    Write-Host "`nCorrecoes aplicadas! Agora os gradientes sao getters que recebem context." -ForegroundColor Green
    Write-Host "Exemplo de uso: AppGradients.primaryHeader(context)" -ForegroundColor Cyan
    Write-Host "Execute 'flutter analyze' para verificar." -ForegroundColor Green
} else {
    Write-Host "`nNenhuma correcao foi necessaria." -ForegroundColor Cyan
}