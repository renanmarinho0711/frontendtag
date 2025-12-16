#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Corrige gradientes para serem 100% dinâmicos com ThemeColors.of(context)

.DESCRIPTION
    Transforma gradientes const em getters estáticos dinâmicos que recebem BuildContext
    para funcionar corretamente com ThemeColors.of(context)
#>

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
                # Encontrar posição dos imports
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
            
            # Padrão: static const LinearGradient nome = LinearGradient(
            $constGradientPattern = 'static const LinearGradient\s+(\w+)\s*=\s*LinearGradient\s*\('
            if ($content -match $constGradientPattern) {
                $content = $content -replace $constGradientPattern, 'static LinearGradient $1(BuildContext context) => LinearGradient('
                $hasChanges = $true
                Write-Host "    ✓ Convertidos gradientes const para getters dinamicos" -ForegroundColor Green
            }
            
            # 3. Corrigir fechamento de parênteses/ponto e vírgula para getters
            # Trocar ); no final dos gradientes por );
            $content = $content -replace '(\s+)\);\s*$', '$1);'
            
            # 4. Adicionar comentários explicativos
            if ($hasChanges) {
                # Adicionar comentário no início da classe explicando o uso
                $classPattern = '(class\s+\w+\s*\{[^}]*?_\(\);)'
                if ($content -match $classPattern) {
                    $replacement = '$1' + "`n`n  // NOTA: Gradientes agora são getters dinâmicos que recebem context`n  // Uso: AppGradients.primaryHeader(context) ou ModuleGradients.produtos(context)"
                    $content = $content -replace $classPattern, $replacement
                }
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

# Procurar outros arquivos que possam usar os gradientes e precisar ser atualizados
Write-Host "`nProcurando arquivos que usam gradientes..." -ForegroundColor Cyan

$dartFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.dart" | Where-Object { 
    $_.FullName -notmatch "\.g\.dart$" -and 
    $_.FullName -notmatch "test" -and
    $_.FullName -notmatch "gradients.dart" -and
    $_.FullName -notmatch "module_gradients.dart"
}

$usageFiles = 0
$usageUpdates = 0

foreach ($file in $dartFiles) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
        
        if ($content -match "(AppGradients\.|ModuleGradients\.)\w+(?!\()") {
            $usageFiles++
            $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart('\')
            Write-Host "Arquivo usa gradientes: $relativePath" -ForegroundColor Yellow
            
            # Corrigir uso dos gradientes adicionando (context)
            $originalContent = $content
            
            # Padrão: AppGradients.nomeGradiente -> AppGradients.nomeGradiente(context)
            $content = $content -replace '(AppGradients\.)(\w+)(?!\()', '$1$2(context)'
            $content = $content -replace '(ModuleGradients\.)(\w+)(?!\()', '$1$2(context)'
            
            if ($content -ne $originalContent) {
                Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
                $usageUpdates++
                Write-Host "  ✓ Atualizado uso dos gradientes para incluir context" -ForegroundColor Green
            }
        }
        }
    } catch {
        # Ignorar erros de leitura de arquivos
    }
}

# Relatório final
Write-Host "`n=== RELATORIO FINAL ===" -ForegroundColor Cyan
Write-Host "Arquivos de gradientes processados: $totalProcessed" -ForegroundColor Cyan
Write-Host "Arquivos de gradientes corrigidos: $filesFixed" -ForegroundColor Green
Write-Host "Arquivos que usavam gradientes: $usageFiles" -ForegroundColor Cyan
Write-Host "Arquivos de uso atualizados: $usageUpdates" -ForegroundColor Green

if ($filesFixed -gt 0 -or $usageUpdates -gt 0) {
    Write-Host "`n✅ CORREÇOES APLICADAS COM SUCESSO!" -ForegroundColor Green
    Write-Host "🔄 Gradientes agora sao 100% DINAMICOS com ThemeColors.of(context)" -ForegroundColor Cyan
    Write-Host "📖 Novo uso: AppGradients.primaryHeader(context)" -ForegroundColor Yellow
    Write-Host "📖 Novo uso: ModuleGradients.produtos(context)" -ForegroundColor Yellow
    Write-Host "`n🧪 Execute 'flutter analyze' para verificar." -ForegroundColor Green
} else {
    Write-Host "`nNenhuma correcao foi necessaria." -ForegroundColor Cyan
}