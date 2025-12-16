#!/usr/bin/env pwsh

param(
    [string]$OutputFile = "d:\tagbean\frontend\ANALISE_CONTEXTUAL_CORES.txt"
)

$basePath = "d:\tagbean\frontend\lib\features"
$pattern = "Color\("
$resultados = @{}

Write-Host "Analisando contexto de Color( em arquivos .dart..." -ForegroundColor Cyan

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
                # Verificar tipo de ocorrencia
                $tipo = "DESCONHECIDO"
                $ehHardcoded = $false
                $corValor = ""
                
                # Extrair valor Color(0x...)
                if ($linha -match "Color\(0x[0-9A-Fa-f]+\)") {
                    $corValor = $matches[0]
                    $ehHardcoded = $true
                    $tipo = "COLOR_HARDCODED"
                }
                # Verificar se eh metodo (type hint, return type, parameter)
                elseif ($linha -match ":\s*Color\s*(\(|$)" -or $linha -match "Color\s*\)" -or $linha -match "Color\s*\{" -or $linha -match "-> Color") {
                    $tipo = "TYPE_HINT"
                    $ehHardcoded = $false
                }
                # Verificar se eh comentario
                elseif ($linha -match "//.*Color\(") {
                    $tipo = "COMENTARIO"
                    $ehHardcoded = $false
                }
                # Verificar se eh chamada de metodo
                elseif ($linha -match "_.*Color|getColor|StatusColor|getBackgroundColor" -or $linha -match "Color\s*\)" -or $linha -match "\.\s*Color\s*\(") {
                    $tipo = "METODO_FUNCAO"
                    $ehHardcoded = $false
                }
                # Verificar se eh parametro de funcao
                elseif ($linha -match "Color\s*=|color:\s*Color" -or $linha -match "color:\s*_") {
                    $tipo = "PARAM_VARIAVEL"
                    $ehHardcoded = $false
                }
                
                if ($ehHardcoded) {
                    if (-not $resultados.ContainsKey($modulo)) {
                        $resultados[$modulo] = @()
                    }
                    
                    # Pegar contexto (5 linhas antes e depois)
                    $inicio = [Math]::Max(0, $numeroLinha - 6)
                    $fim = [Math]::Min($linhas.Count - 1, $numeroLinha + 5)
                    $contexto = $linhas[$inicio..$fim]
                    
                    $resultado = @{
                        Arquivo = $file.FullName -replace [regex]::Escape("d:\tagbean\frontend\lib\features\"), ""
                        Linha = $numeroLinha
                        Conteudo = $linha.Trim()
                        CorValor = $corValor
                        Tipo = $tipo
                        Contexto = $contexto
                        CaminhoCompleto = $file.FullName
                    }
                    
                    $resultados[$modulo] += $resultado
                }
            }
        }
    }
    catch {
        # Silenciosamente ignorar erros de processamento
    }
}

Write-Progress -Activity "Processando arquivos" -Completed

# Contar apenas hardcoded
$totalCores = 0
foreach ($modulo in $resultados.Keys) {
    $totalCores += $resultados[$modulo].Count
}

$relatorio = "================================================================================" + "`n"
$relatorio += "                  ANALISE CONTEXTUAL DE CORES HARDCODED" + "`n"
$relatorio += "                 Verificacao de Color() vs ThemeColors" + "`n"
$relatorio += "                           Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" + "`n"
$relatorio += "================================================================================" + "`n`n"
$relatorio += "RESUMO EXECUTIVO`n"
$relatorio += "----------------`n"
$relatorio += "Total de modulos com Color() hardcoded: $($resultados.Keys.Count)`n"
$relatorio += "Total de instancias Color() hardcoded: $totalCores`n"
$relatorio += "`nNOTA: Chamadas de metodo, type hints e comentarios foram EXCLUIDOS desta analise`n"
$relatorio += "      Esta analise mostra APENAS ocorrencias que precisam migrar para ThemeColors.of(context)`n"
$relatorio += "`nANALISE DETALHADA POR MODULO`n"
$relatorio += "============================`n"

$modulos = $resultados.Keys | Sort-Object

foreach ($modulo in $modulos) {
    $cores = $resultados[$modulo]
    $totalCoresModulo = $cores.Count
    
    $relatorio += "`n`n[MODULO: $modulo] - Total: $totalCoresModulo instancias de Color() hardcoded`n"
    $relatorio += "================================================================================" + "`n"
    
    foreach ($cor in $cores) {
        $relatorio += "`n"
        $relatorio += "Arquivo      : $($cor.Arquivo)`n"
        $relatorio += "Linha        : $($cor.Linha)`n"
        $relatorio += "Tipo         : $($cor.Tipo)`n"
        $relatorio += "Cor Encontrada: $($cor.CorValor)`n"
        $relatorio += "`nConteudo da linha:`n"
        $relatorio += "   $($cor.Conteudo)`n"
        $relatorio += "`nContexto (5 linhas antes e depois):`n"
        
        foreach ($ctx in $cor.Contexto) {
            $relatorio += "   $ctx`n"
        }
        
        # Sugerir mapeamento
        $sugestao = ""
        switch -Regex ($cor.CorValor) {
            "0xFF6B7280" { $sugestao = "SUGESTAO: ThemeColors.of(context).grey600" }
            "0xFF9CA3AF" { $sugestao = "SUGESTAO: ThemeColors.of(context).grey400" }
            "0xFFFEF3C7" { $sugestao = "SUGESTAO: ThemeColors.of(context).yellow50" }
            "0xFFD97706" { $sugestao = "SUGESTAO: ThemeColors.of(context).warningDark" }
            "0xFFF59E0B" { $sugestao = "SUGESTAO: ThemeColors.of(context).warningMain" }
            "0xFF10B981" { $sugestao = "SUGESTAO: ThemeColors.of(context).greenMaterial" }
            "0xFFEF4444" { $sugestao = "SUGESTAO: ThemeColors.of(context).errorMain" }
            "0xFFD1FAE5" { $sugestao = "SUGESTAO: ThemeColors.of(context).greenSurface" }
            "0xFF059669" { $sugestao = "SUGESTAO: ThemeColors.of(context).greenSuccess" }
            "0xFFA7F3D0" { $sugestao = "SUGESTAO: ThemeColors.of(context).greenLight" }
            "0xFFE5E7EB" { $sugestao = "SUGESTAO: ThemeColors.of(context).grey200" }
            "0xFF22C55E" { $sugestao = "SUGESTAO: ThemeColors.of(context).greenMaterial ou successMain" }
            "0xFFFF9800" { $sugestao = "SUGESTAO: ThemeColors.of(context).orangeMaterial" }
            "0xFF64748B" { $sugestao = "SUGESTAO: ThemeColors.of(context).grey500" }
            "0xFF4B5563" { $sugestao = "SUGESTAO: ThemeColors.of(context).grey700" }
            default { $sugestao = "SUGESTAO: Verificar design_system para mapeamento correto" }
        }
        
        $relatorio += "`n$sugestao`n"
        $relatorio += "--------------------------------------------------------------------------------`n"
    }
}

$relatorio += "`n`n" + ("=" * 80)
$relatorio += "`nRESUMO POR TIPO DE COR`n"
$relatorio += ("=" * 80) + "`n`n"

# Agrupar por valor de cor
$coresPorValor = @{}
foreach ($modulo in $resultados.Keys) {
    foreach ($cor in $resultados[$modulo]) {
        if (-not $coresPorValor.ContainsKey($cor.CorValor)) {
            $coresPorValor[$cor.CorValor] = 0
        }
        $coresPorValor[$cor.CorValor]++
    }
}

$coresOrdenadas = $coresPorValor.GetEnumerator() | Sort-Object -Property Value -Descending

foreach ($cor in $coresOrdenadas) {
    $relatorio += "$($cor.Name): $($cor.Value) ocorrencias`n"
}

$relatorio += "`n`n" + ("=" * 80)
$relatorio += "`nRESUMO FINAL POR MODULO`n"
$relatorio += ("=" * 80) + "`n`n"

foreach ($modulo in $modulos) {
    $totalCoresModulo = $resultados[$modulo].Count
    $relatorio += "[MODULO: $modulo]: $totalCoresModulo Color() hardcoded`n"
}

$relatorio | Out-File -FilePath $OutputFile -Encoding UTF8 -Force

Write-Host "`nRelatorio de analise contextual gerado com sucesso!" -ForegroundColor Green
Write-Host "Arquivo: $OutputFile" -ForegroundColor Cyan
Write-Host "`nEstatisticas:" -ForegroundColor Yellow
Write-Host "   - Total de modulos: $($resultados.Keys.Count)" -ForegroundColor White
Write-Host "   - Total de Color() hardcoded: $totalCores" -ForegroundColor White
Write-Host ""

Write-Host "Distribuicao por modulo:" -ForegroundColor Cyan
foreach ($modulo in $modulos) {
    $totalCoresModulo = $resultados[$modulo].Count
    Write-Host "   [$modulo]: $totalCoresModulo" -ForegroundColor Gray
}

Write-Host "`nCores mais frequentes:" -ForegroundColor Cyan
$top5 = $coresOrdenadas | Select-Object -First 5
foreach ($cor in $top5) {
    Write-Host "   [$($cor.Name)]: $($cor.Value) vezes" -ForegroundColor Gray
}
