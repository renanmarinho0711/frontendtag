#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Corrige imports faltantes de ThemeColors nos arquivos migrados

.DESCRIPTION
    Este script adiciona o import necessário para ThemeColors em arquivos que usam
    ThemeColors.of(context) mas não têm o import correspondente
#>

param(
    [string]$ProjectPath = "lib"
)

# Cores para output
$colors = @{
    Success = "Green"
    Warning = "Yellow"
    Error = "Red"
    Info = "Cyan"
}

Write-Host "=== CORREÇÃO DE IMPORTS DO THEMECOLORS ===" -ForegroundColor $colors.Info
Write-Host "Iniciando correção de imports faltantes..." -ForegroundColor $colors.Info

# Contadores
$totalProcessed = 0
$importsAdded = 0
$alreadyHasImport = 0

# Encontrar todos os arquivos .dart no projeto
$dartFiles = Get-ChildItem -Path $ProjectPath -Recurse -Filter "*.dart" | Where-Object { 
    $_.FullName -notmatch "\.g\.dart$" -and 
    $_.FullName -notmatch "test" 
}

Write-Host "Encontrados $($dartFiles.Count) arquivos Dart para verificar..." -ForegroundColor $colors.Info

foreach ($file in $dartFiles) {
    $totalProcessed++
    $relativePath = $file.FullName.Replace((Get-Location).Path, "").TrimStart('\')
    
    try {
        $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        
        # Verificar se o arquivo usa ThemeColors.of(context)
        if ($content -match "ThemeColors\.of\(context\)") {
            Write-Host "Verificando: $relativePath" -ForegroundColor $colors.Warning
            
            # Verificar se já tem o import
            $hasImport = $content -match "import\s+['\`"]package:tagbean/design_system/design_system\.dart['\`"]"
            
            if ($hasImport) {
                $alreadyHasImport++
                Write-Host "  ✓ Já possui import correto" -ForegroundColor $colors.Success
            } else {
                # Adicionar o import
                Write-Host "  + Adicionando import..." -ForegroundColor $colors.Info
                
                # Encontrar a posição para inserir o import
                $lines = $content -split "`r`n|`r|`n"
                $importLines = @()
                $otherLines = @()
                $importsStarted = $false
                $importsEnded = $false
                
                foreach ($line in $lines) {
                    if ($line -match "^\s*import\s+" -and !$importsEnded) {
                        $importLines += $line
                        $importsStarted = $true
                    } elseif ($importsStarted -and $line.Trim() -eq "" -and !$importsEnded) {
                        # Linha em branco após imports
                        $importsEnded = $true
                        $otherLines += $line
                    } elseif ($importsStarted -and ($line -match "^\s*part\s+" -or $line -match "^\s*(class|abstract|mixin|enum|extension|typedef)" -or $line -match "^\s*\/\/" -or $line -match "^\s*\/\*") -and !$importsEnded) {
                        # Fim dos imports
                        $importsEnded = $true
                        $otherLines += $line
                    } else {
                        if (!$importsStarted) {
                            $otherLines += $line
                        } else {
                            $otherLines += $line
                        }
                    }
                }
                
                # Adicionar o import necessário
                $newImport = "import 'package:tagbean/design_system/design_system.dart';"
                
                if ($importLines.Count -gt 0) {
                    # Verificar se já existe (double check)
                    $existsAlready = $importLines | Where-Object { $_ -match "design_system/design_system\.dart" }
                    if (!$existsAlready) {
                        $importLines += $newImport
                        $importsAdded++
                    } else {
                        $alreadyHasImport++
                        Write-Host "  ✓ Import já existe (detectado na segunda verificação)" -ForegroundColor $colors.Success
                        continue
                    }
                } else {
                    # Não há imports, adicionar no início
                    $importLines = @($newImport)
                    $importsAdded++
                }
                
                # Reconstruir o arquivo
                $newContent = ""
                
                # Adicionar cabeçalho (copyright, etc.) se existir
                $headerLines = @()
                foreach ($line in $lines) {
                    if ($line -match "^\s*\/\*" -or $line -match "^\s*\/\/" -or $line.Trim() -eq "") {
                        $headerLines += $line
                    } elseif ($line -match "^\s*import\s+") {
                        break
                    } else {
                        # Se não é comentário nem import, quebra
                        break
                    }
                }
                
                # Montar o conteúdo final
                if ($headerLines.Count -gt 0) {
                    $newContent += ($headerLines -join "`n") + "`n"
                }
                
                $newContent += ($importLines -join "`n") + "`n"
                
                if ($otherLines.Count -gt 0) {
                    $newContent += "`n" + ($otherLines -join "`n")
                }
                
                # Salvar o arquivo
                Set-Content -Path $file.FullName -Value $newContent -Encoding UTF8 -NoNewline
                Write-Host "  ✓ Import adicionado com sucesso!" -ForegroundColor $colors.Success
            }
        }
    } catch {
        Write-Host "  ✗ Erro ao processar arquivo: $_" -ForegroundColor $colors.Error
    }
}

# Relatório final
Write-Host "`n=== RELATÓRIO FINAL ===" -ForegroundColor $colors.Info
Write-Host "Arquivos processados: $totalProcessed" -ForegroundColor $colors.Info
Write-Host "Imports adicionados: $importsAdded" -ForegroundColor $colors.Success
Write-Host "Arquivos que já possuíam import: $alreadyHasImport" -ForegroundColor $colors.Success

if ($importsAdded -gt 0) {
    Write-Host "`nCorreções aplicadas com sucesso! Execute 'flutter analyze' para verificar." -ForegroundColor $colors.Success
} else {
    Write-Host "`nNenhuma correção foi necessária." -ForegroundColor $colors.Info
}