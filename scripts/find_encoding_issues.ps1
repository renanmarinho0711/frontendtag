# ============================================================================
# Script: find_encoding_issues.ps1
# Descricao: Busca problemas de encoding/caracteres em arquivos Dart (UI)
# Autor: TagBean Team
# Data: 17/12/2025
# ============================================================================

param(
    [string]$SearchPath = "D:\tagbean\frontend\lib",
    [string]$OutputFile = "D:\tagbean\frontend\RELATORIO_ENCODING_ISSUES.md"
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  SCANNER DE PROBLEMAS DE ENCODING - DART  " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Regex para detectar sequencias de UTF-8 double-encoded ou corrompido
# Estes sao os bytes que aparecem quando UTF-8 e interpretado como Latin-1
$regexPatterns = @(
    # Padrao principal: C3 seguido de byte 80-BF (acentos latinos)
    '\xC3[\x80-\xBF]',
    # Padrao secundario: C2 seguido de byte 80-BF  
    '\xC2[\x80-\xBF]',
    # Sequencias especificas conhecidas
    'Ã¡', 'Ã£', 'Ã¢', 'Ã©', 'Ãª', 'Ã­', 'Ã³', 'Ãµ', 'Ã´', 'Ãº', 'Ã§',
    'Ã', 'Â£', 'Â©', 'Â®', 'â€', 'Ã€', 'Ã‰', 'Ã'
)

# Resultados
$issues = [System.Collections.ArrayList]::new()
$fileCount = 0
$issueCount = 0

# Buscar todos os arquivos .dart
Write-Host "Buscando arquivos .dart em: $SearchPath" -ForegroundColor Yellow
$dartFiles = Get-ChildItem -Path $SearchPath -Filter "*.dart" -Recurse -ErrorAction SilentlyContinue

Write-Host "Encontrados $($dartFiles.Count) arquivos .dart" -ForegroundColor Green
Write-Host ""
Write-Host "Analisando arquivos..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $dartFiles) {
    $fileCount++
    $relativePath = $file.FullName.Replace("D:\tagbean\frontend\", "")
    
    try {
        # Ler o conteudo do arquivo
        $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        
        $lines = $content -split "`r?`n"
        $lineNumber = 0
        
        foreach ($line in $lines) {
            $lineNumber++
            $foundIssue = $false
            $foundPatterns = [System.Collections.ArrayList]::new()
            
            # Verificar cada padrao
            foreach ($pattern in $regexPatterns) {
                if ($line -match [regex]::Escape($pattern)) {
                    $foundIssue = $true
                    [void]$foundPatterns.Add($pattern)
                }
            }
            
            if ($foundIssue) {
                $issueCount++
                
                $issue = [PSCustomObject]@{
                    File = $relativePath
                    Line = $lineNumber
                    Patterns = ($foundPatterns -join ", ")
                    Content = $line.Trim()
                    FullPath = $file.FullName
                }
                
                [void]$issues.Add($issue)
                
                Write-Host "[$issueCount] $relativePath`:$lineNumber" -ForegroundColor Red
            }
        }
    }
    catch {
        Write-Host "Erro ao ler arquivo: $($file.FullName)" -ForegroundColor Red
    }
    
    if ($fileCount % 100 -eq 0) {
        Write-Host "  Processados $fileCount arquivos..." -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "           ANALISE CONCLUIDA               " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Total de arquivos analisados: $fileCount" -ForegroundColor Green

if ($issueCount -gt 0) {
    Write-Host "Total de problemas encontrados: $issueCount" -ForegroundColor Red
} else {
    Write-Host "Total de problemas encontrados: $issueCount" -ForegroundColor Green
}

Write-Host ""

# Gerar relatorio Markdown
$report = [System.Text.StringBuilder]::new()

[void]$report.AppendLine("# RELATORIO DE PROBLEMAS DE ENCODING - TagBean Frontend")
[void]$report.AppendLine("")
[void]$report.AppendLine("**Data da Analise:** $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')")
[void]$report.AppendLine("**Diretorio Analisado:** ``$SearchPath``")
[void]$report.AppendLine("**Total de Arquivos:** $fileCount")
[void]$report.AppendLine("**Total de Problemas:** $issueCount")
[void]$report.AppendLine("")
[void]$report.AppendLine("---")
[void]$report.AppendLine("")

# Resumo por arquivo
[void]$report.AppendLine("## RESUMO POR ARQUIVO")
[void]$report.AppendLine("")

$groupedByFile = $issues | Group-Object -Property File | Sort-Object Count -Descending

foreach ($fileGroup in $groupedByFile) {
    [void]$report.AppendLine("- **$($fileGroup.Name)**: $($fileGroup.Count) problemas")
}

[void]$report.AppendLine("")
[void]$report.AppendLine("---")
[void]$report.AppendLine("")

# Detalhamento completo
[void]$report.AppendLine("## DETALHAMENTO COMPLETO")
[void]$report.AppendLine("")

$counter = 1
foreach ($issue in $issues | Sort-Object File, Line) {
    [void]$report.AppendLine("### $counter. $($issue.File) - Linha $($issue.Line)")
    [void]$report.AppendLine("")
    [void]$report.AppendLine("**Padroes Encontrados:** ``$($issue.Patterns)``")
    [void]$report.AppendLine("")
    [void]$report.AppendLine("**Codigo Completo da Linha:**")
    [void]$report.AppendLine("``````dart")
    [void]$report.AppendLine($issue.Content)
    [void]$report.AppendLine("``````")
    [void]$report.AppendLine("")
    $counter++
}

[void]$report.AppendLine("---")
[void]$report.AppendLine("")
[void]$report.AppendLine("**Gerado automaticamente por find_encoding_issues.ps1**")

# Salvar relatorio
[System.IO.File]::WriteAllText($OutputFile, $report.ToString(), [System.Text.Encoding]::UTF8)

Write-Host "Relatorio salvo em: $OutputFile" -ForegroundColor Green
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Script finalizado!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
