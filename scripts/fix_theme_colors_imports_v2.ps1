#!/usr/bin/env pwsh

# Script para corrigir imports faltantes de ThemeColors
param(
    [string]$ProjectPath = "lib"
)

Write-Host "=== CORRECAO DE IMPORTS DO THEMECOLORS ===" -ForegroundColor Cyan
Write-Host "Iniciando correcao de imports faltantes..." -ForegroundColor Cyan

$totalProcessed = 0
$importsAdded = 0
$alreadyHasImport = 0

# Encontrar todos os arquivos .dart no projeto
$dartFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.dart" | Where-Object { 
    $_.FullName -notmatch "\.g\.dart$" -and 
    $_.FullName -notmatch "test" 
}

Write-Host "Encontrados $($dartFiles.Count) arquivos Dart para verificar..." -ForegroundColor Cyan

foreach ($file in $dartFiles) {
    $totalProcessed++
    $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart('\')
    
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Verificar se o arquivo usa ThemeColors.of(context)
        if ($content -match "ThemeColors\.of\(context\)") {
            Write-Host "Verificando: $relativePath" -ForegroundColor Yellow
            
            # Verificar se já tem o import
            $hasImport = $content -match "import\s+['\`"]package:tagbean/design_system/design_system\.dart['\`"]"
            
            if ($hasImport) {
                $alreadyHasImport++
                Write-Host "  OK - Ja possui import correto" -ForegroundColor Green
            } else {
                # Adicionar o import
                Write-Host "  CORRIGINDO - Adicionando import..." -ForegroundColor Yellow
                
                # Encontrar onde inserir o import (após outros imports ou no início)
                $lines = $content -split "`r`n|`r|`n"
                $newLines = @()
                $importAdded = $false
                
                foreach ($line in $lines) {
                    if (!$importAdded -and ($line -match "^\s*import\s+" -or $line -match "^\s*library\s+" -or $line -match "^\s*part\s+")) {
                        # Primeiro import encontrado, adicionar nosso import antes
                        if ($line -match "^\s*import\s+") {
                            $newLines += "import 'package:tagbean/design_system/design_system.dart';"
                            $importAdded = $true
                        }
                    }
                    $newLines += $line
                }
                
                # Se não encontrou nenhum import, adicionar no início (após comentários)
                if (!$importAdded) {
                    $headerLines = @()
                    $bodyLines = @()
                    $inHeader = $true
                    
                    foreach ($line in $lines) {
                        if ($inHeader -and ($line -match "^\s*//|^\s*/\*|^\s*$")) {
                            $headerLines += $line
                        } else {
                            if ($inHeader) {
                                $headerLines += ""
                                $headerLines += "import 'package:tagbean/design_system/design_system.dart';"
                                $headerLines += ""
                                $inHeader = $false
                            }
                            $bodyLines += $line
                        }
                    }
                    
                    $newLines = $headerLines + $bodyLines
                }
                
                # Salvar o arquivo
                $newContent = $newLines -join "`n"
                Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
                $importsAdded++
                Write-Host "  SUCESSO - Import adicionado!" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host "  ERRO - Erro ao processar arquivo: $_" -ForegroundColor Red
    }
}

# Relatório final
Write-Host "`n=== RELATORIO FINAL ===" -ForegroundColor Cyan
Write-Host "Arquivos processados: $totalProcessed" -ForegroundColor Cyan
Write-Host "Imports adicionados: $importsAdded" -ForegroundColor Green
Write-Host "Arquivos que ja possuiam import: $alreadyHasImport" -ForegroundColor Green

if ($importsAdded -gt 0) {
    Write-Host "`nCorrecoes aplicadas com sucesso! Execute 'flutter analyze' para verificar." -ForegroundColor Green
} else {
    Write-Host "`nNenhuma correcao foi necessaria." -ForegroundColor Cyan
}