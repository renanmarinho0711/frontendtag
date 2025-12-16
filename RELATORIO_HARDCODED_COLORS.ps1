#!/usr/bin/env pwsh

param(
    [string]$OutputFile = "d:\tagbean\frontend\RELATORIO_CORES_HARDCODED.txt"
)

$basePath = "d:\tagbean\frontend\lib\features"
$pattern = "Color\("
$resultados = @{}

Write-Host "Procurando por Color( em todos os arquivos .dart..." -ForegroundColor Cyan

$dartFiles = Get-ChildItem -Path $basePath -Recurse -Filter "*.dart" -ErrorAction SilentlyContinue

$totalArquivos = $dartFiles.Count
$contagem = 0

foreach ($file in $dartFiles) {
    $contagem++
    $percentual = [math]::Round(($contagem / $totalArquivos) * 100, 0)
    Write-Progress -Activity "Processando arquivos" -Status "$contagem / $totalArquivos ($percentual porcento)" -PercentComplete $percentual
    
    $relativePath = $file.FullName -replace [regex]::Escape($basePath), ""
    $partes = $relativePath -split "\\"
    $modulo = if ($partes.Count -gt 1) { $partes[1] } else { "root" }
    
    try {
        $conteudo = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($null -eq $conteudo) { continue }
        
        $linhas = $conteudo -split "`n"
        $numeroLinha = 0
        
        foreach ($linha in $linhas) {
            $numeroLinha++
            
            if ($linha -match $pattern) {
                if (-not $resultados.ContainsKey($modulo)) {
                    $resultados[$modulo] = @()
                }
                
                $resultado = @{
                    Arquivo = $file.FullName -replace [regex]::Escape("d:\tagbean\frontend\lib\features\"), ""
                    Linha = $numeroLinha
                    Conteudo = $linha.Trim()
                    CaminhoCompleto = $file.FullName
                }
                
                $resultados[$modulo] += $resultado
            }
        }
    }
    catch {
        Write-Warning "Erro ao processar $($file.FullName): $_"
    }
}

Write-Progress -Activity "Processando arquivos" -Completed

$totalCores = $resultados.Values | ForEach-Object { $_.Count } | Measure-Object -Sum | Select-Object -ExpandProperty Sum

$relatorio = "================================================================================" + "`n"
$relatorio += "                    RELATORIO DE CORES HARDCODED (Color())" + "`n"
$relatorio += "                           Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" + "`n"
$relatorio += "================================================================================" + "`n`n"
$relatorio += "RESUMO`n"
$relatorio += "------`n"
$relatorio += "Total de modulos com cores hardcoded: $($resultados.Keys.Count)`n"
$relatorio += "Total de instancias encontradas: $totalCores`n"
$relatorio += "`nDETALHES POR MODULO`n"
$relatorio += "-------------------`n"

$modulos = $resultados.Keys | Sort-Object

foreach ($modulo in $modulos) {
    $cores = $resultados[$modulo]
    $totalCoresModulo = $cores.Count
    
    $relatorio += "`n`n[MODULO: $modulo] - Total: $totalCoresModulo instancias`n"
    $relatorio += "================================================================================" + "`n"
    
    foreach ($cor in $cores) {
        $relatorio += "`n"
        $relatorio += "Arquivo  : $($cor.Arquivo)`n"
        $relatorio += "Linha    : $($cor.Linha)`n"
        $relatorio += "Conteudo : $($cor.Conteudo)`n"
        $relatorio += "--------------------------------------------------------------------------------`n"
    }
}

$relatorio += "`n`n" + ("=" * 80)
$relatorio += "`nRESUMO FINAL`n"
$relatorio += ("=" * 80) + "`n`n"

foreach ($modulo in $modulos) {
    $totalCoresModulo = $resultados[$modulo].Count
    $relatorio += "[MODULO: $modulo]: $totalCoresModulo cores hardcoded`n"
}

$relatorio | Out-File -FilePath $OutputFile -Encoding UTF8 -Force

Write-Host "`nRelatorio gerado com sucesso!" -ForegroundColor Green
Write-Host "Arquivo: $OutputFile" -ForegroundColor Cyan
Write-Host "`nEstatisticas:" -ForegroundColor Yellow
Write-Host "   - Total de modulos: $($resultados.Keys.Count)" -ForegroundColor White
Write-Host "   - Total de instancias: $totalCores" -ForegroundColor White
Write-Host ""

Write-Host "Resumo por modulo:" -ForegroundColor Cyan
foreach ($modulo in $modulos) {
    $totalCoresModulo = $resultados[$modulo].Count
    Write-Host "   [OK] $modulo : $totalCoresModulo" -ForegroundColor Gray
}
