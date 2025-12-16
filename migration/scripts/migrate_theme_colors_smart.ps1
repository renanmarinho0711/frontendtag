# ==============================================================================
# Script INTELIGENTE de Migracao: AppThemeColors -> ThemeColors.of(context)
# VERSAO 6.0 - ANALISE CONTEXTUAL COMPLETA
# ==============================================================================
#
# Este script analisa CADA ocorrencia de AppThemeColors e decide:
# 1. Se pode migrar (tem acesso a context)
# 2. Se deve ignorar (static, field initializer, metodo sem context)
# 3. Se precisa adicionar context como parametro
#
# REGRAS LOGICAS:
# - Metodo build() -> TEM context
# - Metodo com (BuildContext context) -> TEM context
# - Metodo sem context no escopo -> NAO MIGRAR
# - Inicializador de campo -> NAO MIGRAR
# - static const/final -> NAO MIGRAR
# - Dentro de lista literal em campo -> NAO MIGRAR
# ==============================================================================

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [string]$TargetFolder = "d:\tagbean\frontend\lib\modules",
    [string]$SingleFile = ""
)

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "   MIGRACAO INTELIGENTE: AppThemeColors -> ThemeColors.of(context)" -ForegroundColor Cyan
Write-Host "                        VERSAO 6.0                                " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO: DRY RUN (simulacao)" -ForegroundColor Yellow
} else {
    Write-Host "   MODO: EXECUCAO REAL" -ForegroundColor Green
}
Write-Host ""

# Contadores globais
$script:totalMigrated = 0
$script:totalSkipped = 0
$script:totalFiles = 0
$script:skippedDetails = @()
$script:migratedFiles = @()

# ==============================================================================
# FUNCAO: Encontrar o metodo/funcao que contem uma posicao especifica
# Retorna informacoes sobre o escopo (tem context? eh static? eh field?)
# ==============================================================================
function Get-ScopeInfo {
    param(
        [string]$content,
        [int]$position
    )
    
    $result = @{
        HasContext = $false
        IsStatic = $false
        IsFieldInitializer = $false
        IsListLiteral = $false
        MethodName = ""
        Reason = ""
    }
    
    # Pegar o texto ANTES da posicao para analisar o contexto
    $textBefore = $content.Substring(0, [Math]::Min($position, $content.Length))
    
    # =========================================================================
    # REGRA 1: Verificar se esta dentro de inicializador de campo
    # Padrao: "final/late/var Type _name = [...]" ou "= AppThemeColors..."
    # =========================================================================
    
    # Encontrar a ultima linha que parece ser declaracao de campo
    $lines = $textBefore -split "`n"
    $lastLines = ($lines | Select-Object -Last 30) -join "`n"
    
    # Verificar se estamos dentro de uma lista literal de campo
    if ($lastLines -match "(final|late\s+final|const)\s+List<[^>]+>\s+_?\w+\s*=\s*\[[^\]]*$") {
        $result.IsListLiteral = $true
        $result.IsFieldInitializer = $true
        $result.Reason = "Lista literal em campo de classe"
        return $result
    }
    
    # Verificar inicializador de campo simples
    if ($lastLines -match "(final|late|var|Color|const)\s+_?\w+\s*=\s*[^;{]*$" -and $lastLines -notmatch "\{[^}]*$") {
        # Verificar se nao estamos dentro de uma funcao
        $braceCount = ($lastLines -split "\{").Count - ($lastLines -split "\}").Count
        if ($braceCount -le 1) {
            $result.IsFieldInitializer = $true
            $result.Reason = "Inicializador de campo"
            return $result
        }
    }
    
    # =========================================================================
    # REGRA 2: Verificar se esta em bloco static
    # =========================================================================
    
    if ($lastLines -match "static\s+(const|final)\s+[^;]+$") {
        $result.IsStatic = $true
        $result.Reason = "Bloco static const/final"
        return $result
    }
    
    # =========================================================================
    # REGRA 3: Encontrar o metodo que contem esta posicao
    # =========================================================================
    
    # Procurar pela assinatura do metodo mais proximo (de tras para frente)
    # Padroes de metodo: Widget build(...), void _method(...), etc.
    
    $methodPatterns = @(
        # build com context
        "Widget\s+build\s*\(\s*BuildContext\s+(\w+)",
        # Metodo com BuildContext como parametro
        "\w+\s+_?\w+\s*\([^)]*BuildContext\s+(\w+)[^)]*\)",
        # Metodo generico (para detectar metodos SEM context)
        "(void|Widget|Future|List|Map|String|int|double|bool|dynamic|\w+)\s+(_\w+)\s*\(([^)]*)\)\s*(async\s*)?\{"
    )
    
    # Encontrar todos os metodos no texto antes da posicao
    $methodMatches = @()
    
    foreach ($pattern in $methodPatterns) {
        $matches = [regex]::Matches($textBefore, $pattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        foreach ($m in $matches) {
            $methodMatches += @{
                Index = $m.Index
                Length = $m.Length
                Value = $m.Value
                Pattern = $pattern
            }
        }
    }
    
    # Ordenar por posicao (mais proximo primeiro = ultimo na lista)
    $methodMatches = $methodMatches | Sort-Object -Property Index -Descending
    
    if ($methodMatches.Count -gt 0) {
        $closestMethod = $methodMatches[0]
        
        # Verificar se o metodo tem BuildContext
        if ($closestMethod.Value -match "BuildContext\s+(\w+)") {
            $contextVarName = $matches[1]
            $result.HasContext = $true
            $result.MethodName = $closestMethod.Value
            $result.Reason = "Metodo com BuildContext: $contextVarName"
            return $result
        }
        
        # Metodo sem BuildContext
        if ($closestMethod.Value -match "(void|Widget|Future)\s+(_\w+)\s*\(([^)]*)\)") {
            $methodName = $matches[2]
            $params = $matches[3]
            
            # Verificar se os parametros incluem context indiretamente
            if ($params -match "context|ctx") {
                $result.HasContext = $true
                $result.Reason = "Metodo com context no nome do parametro"
                return $result
            }
            
            $result.HasContext = $false
            $result.MethodName = $methodName
            $result.Reason = "Metodo '$methodName' nao tem BuildContext"
            return $result
        }
    }
    
    # =========================================================================
    # REGRA 4: Verificar se estamos no corpo de um Widget (build method)
    # =========================================================================
    
    # Contar chaves para ver se estamos dentro de um bloco de build
    $openBraces = ($textBefore -split "\{").Count - 1
    $closeBraces = ($textBefore -split "\}").Count - 1
    $braceDepth = $openBraces - $closeBraces
    
    # Se ha um build( antes e estamos em profundidade > 0
    if ($textBefore -match "Widget\s+build\s*\(" -and $braceDepth -gt 0) {
        # Verificar se nao saimos do build
        $lastBuildPos = $textBefore.LastIndexOf("Widget build(")
        $textAfterBuild = $textBefore.Substring($lastBuildPos)
        
        $buildOpenBraces = ($textAfterBuild -split "\{").Count - 1
        $buildCloseBraces = ($textAfterBuild -split "\}").Count - 1
        
        if ($buildOpenBraces -gt $buildCloseBraces) {
            $result.HasContext = $true
            $result.Reason = "Dentro do metodo build()"
            return $result
        }
    }
    
    # =========================================================================
    # REGRA 5: Verificar se esta em um callback/closure que recebe context
    # =========================================================================
    
    if ($lastLines -match "(builder|itemBuilder|onTap|onPressed):\s*\([^)]*context[^)]*\)\s*(\{|=>)") {
        $result.HasContext = $true
        $result.Reason = "Callback com context"
        return $result
    }
    
    # =========================================================================
    # DEFAULT: Assumir que NAO tem context (seguro)
    # =========================================================================
    
    $result.HasContext = $false
    $result.Reason = "Contexto nao identificado - assumindo sem context"
    return $result
}

# ==============================================================================
# FUNCAO: Processar um arquivo
# ==============================================================================
function Process-File {
    param([string]$filePath)
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Verificar se tem AppThemeColors
    if ($content -notmatch "AppThemeColors\.") {
        return @{ Migrated = 0; Skipped = 0 }
    }
    
    # Verificar se eh um arquivo de modelo/provider (ignorar completamente)
    $ignorePatterns = @(
        "\\data\\models\\",
        "\\data\\repositories\\",
        "\\domain\\",
        "\\providers\\",
        "\\application\\",
        "_provider\.dart$",
        "_repository\.dart$",
        "_model\.dart$",
        "\.g\.dart$",
        "\.freezed\.dart$"
    )
    
    foreach ($pattern in $ignorePatterns) {
        if ($filePath -match $pattern) {
            if ($Verbose) {
                Write-Host "   [SKIP] Arquivo ignorado: $filePath" -ForegroundColor Gray
            }
            return @{ Migrated = 0; Skipped = 0 }
        }
    }
    
    # Encontrar todas as ocorrencias de AppThemeColors
    $appThemeMatches = [regex]::Matches($content, "AppThemeColors\.(\w+)")
    
    $migrated = 0
    $skipped = 0
    $skipReasons = @{}
    
    # Processar de tras para frente para manter os indices corretos
    for ($i = $appThemeMatches.Count - 1; $i -ge 0; $i--) {
        $match = $appThemeMatches[$i]
        $position = $match.Index
        $colorName = $match.Groups[1].Value
        
        # Analisar o contexto desta ocorrencia
        $scopeInfo = Get-ScopeInfo -content $content -position $position
        
        if ($scopeInfo.HasContext) {
            # MIGRAR: Substituir AppThemeColors.XXX por ThemeColors.of(context).XXX
            $replacement = "ThemeColors.of(context).$colorName"
            $content = $content.Substring(0, $position) + $replacement + $content.Substring($position + $match.Length)
            $migrated++
        } else {
            # NAO MIGRAR: Registrar motivo
            $reason = $scopeInfo.Reason
            if (-not $skipReasons.ContainsKey($reason)) {
                $skipReasons[$reason] = 0
            }
            $skipReasons[$reason]++
            $skipped++
        }
    }
    
    # Se migrou algo, remover const de blocos com ThemeColors
    if ($migrated -gt 0) {
        $content = Remove-ConstFromBlocks -content $content
        
        # Adicionar import se necessario
        if ($content -notmatch "theme_colors_dynamic\.dart") {
            $importLine = "import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';"
            $importMatch = [regex]::Match($content, "(?m)(^import\s+'[^']+';[\r\n]+)+")
            if ($importMatch.Success) {
                $insertPos = $importMatch.Index + $importMatch.Length
                $content = $content.Insert($insertPos, $importLine + "`n")
            }
        }
        
        if (-not $DryRun) {
            Set-Content $filePath $content -NoNewline -Encoding UTF8
        }
        
        $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
        $script:migratedFiles += "$migrated migracoes: $relativePath"
    }
    
    # Registrar skips
    if ($skipped -gt 0) {
        $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
        foreach ($reason in $skipReasons.Keys) {
            $script:skippedDetails += "$relativePath : $($skipReasons[$reason])x - $reason"
        }
    }
    
    return @{ Migrated = $migrated; Skipped = $skipped; SkipReasons = $skipReasons }
}

# ==============================================================================
# FUNCAO: Remover const de blocos que contem ThemeColors.of(context)
# ==============================================================================
function Remove-ConstFromBlocks {
    param([string]$content)
    
    $widgets = @(
        "LinearGradient", "BoxDecoration", "TextStyle", "Icon", "Text",
        "SnackBar", "BorderSide", "InputDecoration", "OutlineInputBorder",
        "Container", "Padding", "Row", "Column", "Expanded", "Center",
        "SizedBox", "Divider", "Card", "ListTile", "Chip"
    )
    
    foreach ($widget in $widgets) {
        $pattern = "const\s+($widget)\s*\("
        $matches = [regex]::Matches($content, $pattern)
        
        for ($i = $matches.Count - 1; $i -ge 0; $i--) {
            $match = $matches[$i]
            $startIdx = $match.Index
            
            # Encontrar fechamento balanceado
            $depth = 1
            $searchStart = $startIdx + $match.Length
            $endIdx = $searchStart
            
            for ($j = $searchStart; $j -lt $content.Length; $j++) {
                if ($content[$j] -eq '(') { $depth++ }
                elseif ($content[$j] -eq ')') { 
                    $depth--
                    if ($depth -eq 0) { $endIdx = $j; break }
                }
            }
            
            $blockLength = $endIdx - $startIdx + 1
            if ($blockLength -gt 0) {
                $block = $content.Substring($startIdx, $blockLength)
                
                if ($block -match "ThemeColors\.of\(context\)") {
                    $newBlock = $block -replace "^const\s+", ""
                    $content = $content.Substring(0, $startIdx) + $newBlock + $content.Substring($startIdx + $blockLength)
                }
            }
        }
    }
    
    return $content
}

# ==============================================================================
# EXECUCAO PRINCIPAL
# ==============================================================================

Write-Host "[1/3] Coletando arquivos..." -ForegroundColor Yellow

$filesToProcess = @()

if ($SingleFile) {
    if (Test-Path $SingleFile) {
        $filesToProcess += Get-Item $SingleFile
    } else {
        Write-Host "Arquivo nao encontrado: $SingleFile" -ForegroundColor Red
        exit 1
    }
} else {
    $allFiles = Get-ChildItem $TargetFolder -Recurse -Filter "*.dart"
    foreach ($file in $allFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -match "AppThemeColors\.") {
            $filesToProcess += $file
        }
    }
}

Write-Host "   Arquivos com AppThemeColors: $($filesToProcess.Count)" -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] Processando arquivos..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $filesToProcess) {
    $result = Process-File -filePath $file.FullName
    
    if ($result.Migrated -gt 0 -or $result.Skipped -gt 0) {
        $script:totalFiles++
        $script:totalMigrated += $result.Migrated
        $script:totalSkipped += $result.Skipped
        
        $relativePath = $file.FullName.Replace($TargetFolder, "").TrimStart("\")
        if ($Verbose -or $result.Migrated -gt 0) {
            Write-Host "   $relativePath" -ForegroundColor White
            Write-Host "      Migrados: $($result.Migrated) | Ignorados: $($result.Skipped)" -ForegroundColor Gray
        }
    }
}

# ==============================================================================
# RELATORIO
# ==============================================================================

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "                    RELATORIO FINAL                               " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO: DRY RUN (nenhum arquivo modificado)" -ForegroundColor Yellow
} else {
    Write-Host "   MODO: EXECUCAO COMPLETA" -ForegroundColor Green
}

Write-Host ""
Write-Host "   Arquivos processados: $($script:totalFiles)" -ForegroundColor White
Write-Host "   Total MIGRADOS:       $($script:totalMigrated)" -ForegroundColor Green
Write-Host "   Total IGNORADOS:      $($script:totalSkipped)" -ForegroundColor Yellow
Write-Host ""

if ($script:skippedDetails.Count -gt 0 -and $Verbose) {
    Write-Host "   DETALHES DOS IGNORADOS:" -ForegroundColor Yellow
    $script:skippedDetails | Select-Object -First 20 | ForEach-Object {
        Write-Host "      $_" -ForegroundColor Gray
    }
    if ($script:skippedDetails.Count -gt 20) {
        Write-Host "      ... e mais $($script:skippedDetails.Count - 20) items" -ForegroundColor Gray
    }
}

Write-Host ""

# Salvar relatorio
$reportPath = "d:\tagbean\MIGRATION_REPORT_SMART.txt"
$report = @()
$report += "=== RELATORIO MIGRACAO INTELIGENTE v6.0 ==="
$report += "Data: $(Get-Date)"
$report += "Modo: $(if ($DryRun) { 'DRY RUN' } else { 'EXECUCAO' })"
$report += ""
$report += "=== ESTATISTICAS ==="
$report += "Arquivos: $($script:totalFiles)"
$report += "Migrados: $($script:totalMigrated)"
$report += "Ignorados: $($script:totalSkipped)"
$report += ""
$report += "=== ARQUIVOS MIGRADOS ==="
$report += $script:migratedFiles
$report += ""
$report += "=== DETALHES DOS IGNORADOS ==="
$report += $script:skippedDetails

$report | Out-File $reportPath -Encoding UTF8
Write-Host "Relatorio: $reportPath" -ForegroundColor Gray
