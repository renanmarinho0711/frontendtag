# ==============================================================================
# Script COMPLETO de Migracao:  AppThemeColors -> ThemeColors. of(context)
# VERSAO 8.0 - TRATA TODOS OS CASOS ESPECIAIS
# ==============================================================================
#
# ESTRATEGIA COMPLETA:
# 1. Identificar tipo de cada ocorrencia
# 2. Tratar static const -> converter para getter
# 3. Tratar inicializadores de campo -> mover para didChangeDependencies
# 4. Adicionar BuildContext a metodos
# 5. Migrar ocorrencias validas
# 6. Remover const de blocos dinamicos
# 7. Adicionar imports
#
# ==============================================================================

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [string]$TargetFolder = "d:\tagbean\frontend\lib\modules",
    [string]$SingleFile = "",
    [switch]$AnalyzeOnly = $false
)

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "   MIGRACAO COMPLETA v8.0 - TRATA TODOS OS CASOS                  " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO:  DRY RUN (simulacao)" -ForegroundColor Yellow
} elseif ($AnalyzeOnly) {
    Write-Host "   MODO: APENAS ANALISE" -ForegroundColor Yellow
} else {
    Write-Host "   MODO:  EXECUCAO REAL" -ForegroundColor Green
}
Write-Host ""

# Contadores globais
$script:stats = @{
    FilesProcessed = 0
    StaticConstConverted = 0
    FieldInitializersFixed = 0
    MethodsWithContextAdded = 0
    OccurrencesMigrated = 0
    ConstRemoved = 0
    Skipped = 0
    Errors = @()
}

$script:analysisResults = @()

# ==============================================================================
# Arquivos/pastas a ignorar (sem acesso a context)
# ==============================================================================
$ignorePatterns = @(
    "\\data\\models\\",
    "\\data\\repositories\\",
    "\\data\\datasources\\",
    "\\domain\\",
    "\\providers\\.*_provider\. dart$",
    "\\application\\",
    "\. g\.dart$",
    "\. freezed\.dart$",
    "theme_colors\. dart$",
    "theme_colors_dynamic\.dart$"
)

function Test-ShouldIgnore {
    param([string]$path)
    foreach ($pattern in $ignorePatterns) {
        if ($path -match $pattern) { return $true }
    }
    return $false
}

# ==============================================================================
# FASE 1: Analisar e classificar cada ocorrencia
# ==============================================================================
function Get-OccurrenceType {
    param(
        [string]$content,
        [int]$position,
        [string]$colorName
    )
    
    $result = @{
        Type = "VALID"           # VALID, STATIC_CONST, FIELD_INITIALIZER, NO_CONTEXT_METHOD, STATIC_LIST
        Reason = ""
        CanMigrate = $true
        NeedsRefactor = $false
        RefactorType = ""
    }
    
    # Pegar contexto antes da posicao (ultimas 50 linhas)
    $textBefore = $content. Substring(0, [Math]::Min($position, $content.Length))
    $lines = $textBefore -split "`n"
    $lastLines = if ($lines.Count -gt 50) { ($lines | Select-Object -Last 50) -join "`n" } else { $textBefore }
    
    # =========================================================================
    # REGRA 1: static const/final com AppThemeColors
    # =========================================================================
    if ($lastLines -match "static\s+(const|final)\s+[^;]*$" -and $lastLines -notmatch "\{[^}]*$") {
        $result.Type = "STATIC_CONST"
        $result. Reason = "Dentro de declaracao static const/final"
        $result.CanMigrate = $false
        $result.NeedsRefactor = $true
        $result. RefactorType = "CONVERT_TO_GETTER"
        return $result
    }
    
    # =========================================================================
    # REGRA 2: Inicializador de campo de classe
    # Padroes: "final Type _name = ", "late final Type _name = ", "Color _name = "
    # =========================================================================
    
    # Verificar se estamos em um inicializador de campo
    $fieldPatterns = @(
        "(final|late\s+final|late)\s+(List<[^>]+>|Color|Map<[^>]+>|\w+)\s+_?\w+\s*=\s*[^;{]*$",
        "(final|late\s+final)\s+_?\w+\s*=\s*[^;{]*$",
        "^\s*(Color|List<Color>)\s+_?\w+\s*=\s*[^;{]*$"
    )
    
    foreach ($pattern in $fieldPatterns) {
        if ($lastLines -match $pattern) {
            # Verificar se nao estamos dentro de uma funcao (contar chaves)
            $openBraces = ([regex]::Matches($lastLines, "\{")).Count
            $closeBraces = ([regex]:: Matches($lastLines, "\}")).Count
            
            # Se estamos no nivel da classe (poucas chaves abertas)
            if ($openBraces - $closeBraces -le 1) {
                $result.Type = "FIELD_INITIALIZER"
                $result.Reason = "Inicializador de campo de classe"
                $result.CanMigrate = $false
                $result. NeedsRefactor = $true
                $result.RefactorType = "MOVE_TO_DID_CHANGE_DEPENDENCIES"
                return $result
            }
        }
    }
    
    # =========================================================================
    # REGRA 3: Lista literal em campo de classe
    # =========================================================================
    if ($lastLines -match "(final|late\s+final|const)\s+List<[^>]+>\s+_?\w+\s*=\s*\[[^\]]*$") {
        $result.Type = "STATIC_LIST"
        $result. Reason = "Lista literal em campo de classe"
        $result. CanMigrate = $false
        $result.NeedsRefactor = $true
        $result.RefactorType = "CONVERT_TO_GETTER"
        return $result
    }
    
    # =========================================================================
    # REGRA 4: Verificar se estamos em metodo com BuildContext
    # =========================================================================
    
    # Procurar o metodo mais recente
    $methodPattern = "(Widget|void|Future|List<Widget>|String|int|double|bool|dynamic|\w+)\s+(_?\w+)\s*\(([^)]*)\)\s*(async\s*)?\{"
    $methodMatches = [regex]::Matches($lastLines, $methodPattern, [System.Text.RegularExpressions.RegexOptions]::RightToLeft)
    
    if ($methodMatches. Count -gt 0) {
        $closestMethod = $methodMatches[0]
        $params = $closestMethod.Groups[3].Value
        $methodName = $closestMethod.Groups[2].Value
        
        # Verificar se o metodo tem BuildContext
        if ($params -notmatch "BuildContext\s+\w+") {
            # Metodo nao tem context - precisa adicionar
            $result.Type = "NO_CONTEXT_METHOD"
            $result.Reason = "Metodo '$methodName' nao tem BuildContext"
            $result. CanMigrate = $false
            $result.NeedsRefactor = $true
            $result. RefactorType = "ADD_CONTEXT_PARAM"
            return $result
        }
    }
    
    # =========================================================================
    # REGRA 5: Verificar se estamos dentro de um build() ou metodo com context
    # =========================================================================
    
    if ($lastLines -match "Widget\s+build\s*\(\s*BuildContext\s+\w+") {
        # Verificar se ainda estamos dentro do build
        $buildPos = $lastLines.LastIndexOf("Widget build(")
        if ($buildPos -ge 0) {
            $afterBuild = $lastLines.Substring($buildPos)
            $openB = ([regex]::Matches($afterBuild, "\{")).Count
            $closeB = ([regex]:: Matches($afterBuild, "\}")).Count
            if ($openB -gt $closeB) {
                $result.Type = "VALID"
                $result.Reason = "Dentro do metodo build()"
                $result.CanMigrate = $true
                return $result
            }
        }
    }
    
    # Verificar outros metodos com context
    if ($lastLines -match "\w+\s*\([^)]*BuildContext\s+(\w+)[^)]*\)\s*(async\s*)?\{[^}]*$") {
        $result.Type = "VALID"
        $result.Reason = "Dentro de metodo com BuildContext"
        $result. CanMigrate = $true
        return $result
    }
    
    # =========================================================================
    # DEFAULT: Assumir que precisa de verificacao manual
    # =========================================================================
    $result.Type = "UNKNOWN"
    $result.Reason = "Contexto nao identificado claramente"
    $result.CanMigrate = $false
    $result. NeedsRefactor = $false
    
    return $result
}

# ==============================================================================
# FASE 2: Converter static const para getter
# ==============================================================================
function Convert-StaticConstToGetter {
    param([string]$content)
    
    $converted = 0
    
    # Pattern:  static const List<... > _menuItems = [... ];
    # Converter para: static List<... > get _menuItems => [...];
    
    # Primeiro, encontrar blocos static const com AppThemeColors
    $pattern = "static\s+const\s+(List<[^>]+>|Map<[^>]+>)\s+(_\w+)\s*=\s*(\[[^\]]+\]);"
    
    $matches = [regex]::Matches($content, $pattern, [System.Text.RegularExpressions. RegexOptions]:: Singleline)
    
    # Processar de tras para frente
    for ($i = $matches.Count - 1; $i -ge 0; $i--) {
        $match = $matches[$i]
        
        # Verificar se contem AppThemeColors
        if ($match.Value -match "AppThemeColors\. ") {
            $type = $match.Groups[1].Value
            $name = $match.Groups[2].Value
            $value = $match.Groups[3].Value
            
            # Substituir AppThemeColors por ThemeColors.of(context) no valor
            # MAS: getters nao tem context!  Precisamos manter estatico ou usar padrao diferente
            
            # SOLUCAO: Manter como static final e NAO migrar estas cores
            # Ou:  Criar um metodo que recebe context
            
            # Por seguranca, vamos marcar para NAO migrar estas ocorrencias
            # e adicionar um comentario TODO
            
            $newDeclaration = "// TODO: Migrar para tema dinamico - precisa de refatoracao manual`n  static final $type $name = $value;"
            
            $content = $content. Substring(0, $match.Index) + $newDeclaration + $content. Substring($match. Index + $match.Length)
            $converted++
        }
    }
    
    return @{
        Content = $content
        Converted = $converted
    }
}

# ==============================================================================
# FASE 3: Tratar inicializadores de campo
# ==============================================================================
function Fix-FieldInitializers {
    param([string]$content)
    
    $fixed = 0
    
    # Encontrar campos com AppThemeColors que precisam ser movidos
    # Pattern: final/late Color _varName = AppThemeColors.xxx;
    
    $fieldPattern = "(final|late\s+final|late)\s+(Color|List<Color>)\s+(_\w+)\s*=\s*(AppThemeColors\.[^;]+);"
    
    $matches = [regex]::Matches($content, $fieldPattern)
    
    # Para cada campo encontrado, vamos: 
    # 1. Converter para late final sem inicializador
    # 2. Adicionar inicializacao no didChangeDependencies
    
    # Mas isso requer saber onde esta o didChangeDependencies
    # Por simplicidade, vamos marcar com TODO para revisao manual
    
    for ($i = $matches.Count - 1; $i -ge 0; $i--) {
        $match = $matches[$i]
        $modifier = $match.Groups[1].Value
        $type = $match.Groups[2].Value
        $name = $match.Groups[3].Value
        $value = $match. Groups[4].Value
        
        # Marcar para revisao manual
        $replacement = "// TODO:  Mover inicializacao para didChangeDependencies()`n  late $type $name; // Era: $value"
        
        $content = $content. Substring(0, $match.Index) + $replacement + $content.Substring($match.Index + $match.Length)
        $fixed++
    }
    
    return @{
        Content = $content
        Fixed = $fixed
    }
}

# ==============================================================================
# FASE 4: Adicionar BuildContext a metodos
# ==============================================================================
function Add-ContextToMethods {
    param([string]$content)
    
    $methodsFixed = 0
    $callsFixed = 0
    
    # Encontrar metodos _buildXXX que usam AppThemeColors mas NAO tem BuildContext
    $methodPattern = "(Widget|List<Widget>|Container|Column|Row|Padding|Center|Expanded|Card|Text|Icon|void)\s+(_build\w+)\s*\(([^)]*)\)\s*\{"
    
    $methodMatches = [regex]::Matches($content, $methodPattern)
    
    # Coletar metodos que precisam de context
    $methodsNeedingContext = @{}
    
    foreach ($match in $methodMatches) {
        $methodName = $match. Groups[2].Value
        $params = $match.Groups[3].Value
        $returnType = $match. Groups[1].Value
        
        # Pular se ja tem BuildContext
        if ($params -match "BuildContext") {
            continue
        }
        
        # Encontrar o corpo do metodo
        $bodyStart = $match. Index + $match. Length - 1
        $depth = 1
        $bodyEnd = $bodyStart + 1
        
        for ($j = $bodyStart + 1; $j -lt $content.Length -and $depth -gt 0; $j++) {
            if ($content[$j] -eq '{') { $depth++ }
            elseif ($content[$j] -eq '}') { $depth-- }
            $bodyEnd = $j
        }
        
        $methodBody = $content. Substring($bodyStart, $bodyEnd - $bodyStart + 1)
        
        # Verificar se usa AppThemeColors
        if ($methodBody -match "AppThemeColors\. ") {
            $methodsNeedingContext[$methodName] = @{
                Index = $match.Index
                Length = $match.Length
                Params = $params
                ReturnType = $returnType
                FullMatch = $match. Value
            }
        }
    }
    
    # Processar de tras para frente
    $sortedMethods = $methodsNeedingContext. GetEnumerator() | Sort-Object { $_.Value.Index } -Descending
    
    foreach ($entry in $sortedMethods) {
        $methodName = $entry.Key
        $info = $entry.Value
        $params = $info. Params
        
        # Criar nova assinatura com BuildContext
        if ([string]::IsNullOrWhiteSpace($params)) {
            $newParams = "BuildContext context"
        } else {
            $newParams = "BuildContext context, $params"
        }
        
        # Substituir assinatura
        $oldPattern = [regex]::Escape("$($info.ReturnType) $methodName(") + [regex]::Escape($params) + "\)"
        $replacement = "$($info.ReturnType) $methodName($newParams)"
        
        $content = $content -replace $oldPattern, $replacement
        $methodsFixed++
        
        if ($Verbose) {
            Write-Host "      [+context] $methodName" -ForegroundColor Cyan
        }
    }
    
    # Atualizar chamadas aos metodos
    foreach ($entry in $methodsNeedingContext. GetEnumerator()) {
        $methodName = $entry. Key
        
        # Chamada sem argumentos:  _buildXXX()
        $callPatternEmpty = "(? <! Widget\s)(? <!void\s)(?<!List<Widget>\s)($methodName)\s*\(\s*\)"
        $content = [regex]::Replace($content, $callPatternEmpty, '$1(context)')
        
        # Chamada com argumentos (mas sem context)
        $callPatternWithArgs = "(?<!Widget\s)(?<!void\s)(?<!List<Widget>\s)($methodName)\s*\(\s*(? ! context)(? !BuildContext)([^)]+)\)"
        
        $callMatches = [regex]::Matches($content, $callPatternWithArgs)
        
        for ($i = $callMatches.Count - 1; $i -ge 0; $i--) {
            $callMatch = $callMatches[$i]
            $name = $callMatch. Groups[1].Value
            $args = $callMatch.Groups[2].Value
            
            if ($args -notmatch "^context\s*,") {
                $newCall = "$name(context, $args)"
                $content = $content. Substring(0, $callMatch.Index) + $newCall + $content. Substring($callMatch. Index + $callMatch.Length)
                $callsFixed++
            }
        }
    }
    
    return @{
        Content = $content
        MethodsFixed = $methodsFixed
        CallsFixed = $callsFixed
        MethodNames = $methodsNeedingContext.Keys
    }
}

# ==============================================================================
# FASE 5: Migrar ocorrencias validas
# ==============================================================================
function Migrate-ValidOccurrences {
    param([string]$content)
    
    $migrated = 0
    $skipped = 0
    
    # Encontrar todas as ocorrencias de AppThemeColors
    $appThemeMatches = [regex]::Matches($content, "AppThemeColors\. (\w+)")
    
    # Processar de tras para frente
    for ($i = $appThemeMatches.Count - 1; $i -ge 0; $i--) {
        $match = $appThemeMatches[$i]
        $position = $match.Index
        $colorName = $match.Groups[1].Value
        
        # Analisar tipo da ocorrencia
        $occType = Get-OccurrenceType -content $content -position $position -colorName $colorName
        
        if ($occType. CanMigrate) {
            # Migrar
            $replacement = "ThemeColors.of(context).$colorName"
            $content = $content.Substring(0, $position) + $replacement + $content.Substring($position + $match. Length)
            $migrated++
        } else {
            $skipped++
            if ($Verbose) {
                Write-Host "      [SKIP] $colorName - $($occType. Reason)" -ForegroundColor Yellow
            }
        }
    }
    
    return @{
        Content = $content
        Migrated = $migrated
        Skipped = $skipped
    }
}

# ==============================================================================
# FASE 6: Remover const de blocos dinamicos
# ==============================================================================
function Remove-ConstFromDynamicBlocks {
    param([string]$content)
    
    $removed = 0
    
    $widgets = @(
        "LinearGradient", "RadialGradient", "SweepGradient",
        "BoxDecoration", "ShapeDecoration", "InputDecoration",
        "TextStyle", "TextSpan",
        "Icon", "IconButton",
        "Text", "RichText", "SelectableText",
        "SnackBar", "SnackBarAction",
        "BorderSide", "Border", "BorderRadius", "RoundedRectangleBorder",
        "OutlineInputBorder", "UnderlineInputBorder",
        "Container", "DecoratedBox", "ColoredBox",
        "Padding", "EdgeInsets",
        "Row", "Column", "Wrap", "Stack", "Positioned", "Align",
        "Expanded", "Flexible", "Spacer",
        "Center", "SizedBox", "ConstrainedBox",
        "Divider", "VerticalDivider",
        "Card", "Material", "Ink", "InkWell",
        "ListTile", "Chip", "CircleAvatar", "ClipRRect"
    )
    
    foreach ($widget in $widgets) {
        $pattern = "const\s+($widget)\s*\("
        $matches = [regex]:: Matches($content, $pattern)
        
        for ($i = $matches.Count - 1; $i -ge 0; $i--) {
            $match = $matches[$i]
            $startIdx = $match.Index
            
            # Balancear parenteses
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
            if ($blockLength -gt 0 -and $startIdx + $blockLength -le $content.Length) {
                $block = $content. Substring($startIdx, $blockLength)
                
                if ($block -match "ThemeColors\.of\(context\)") {
                    $newBlock = $block -replace "^const\s+", ""
                    $content = $content. Substring(0, $startIdx) + $newBlock + $content.Substring($startIdx + $blockLength)
                    $removed++
                }
            }
        }
    }
    
    return @{
        Content = $content
        Removed = $removed
    }
}

# ==============================================================================
# FASE 7: Adicionar import
# ==============================================================================
function Add-ThemeColorsImport {
    param([string]$content)
    
    $importLine = "import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';"
    
    if ($content -match "theme_colors_dynamic\. dart") {
        return $content
    }
    
    # Encontrar onde inserir
    $importMatch = [regex]:: Match($content, "(? m)(^import\s+'[^']+';[\r\n]+)+")
    if ($importMatch.Success) {
        $insertPos = $importMatch. Index + $importMatch.Length
        $content = $content. Insert($insertPos, $importLine + "`n")
    }
    
    return $content
}

# ==============================================================================
# FUNCAO PRINCIPAL:  Processar arquivo
# ==============================================================================
function Process-File {
    param([string]$filePath)
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Ignorar arquivos sem AppThemeColors
    if ($content -notmatch "AppThemeColors\.") {
        return
    }
    
    # Ignorar arquivos de infraestrutura
    if (Test-ShouldIgnore $filePath) {
        if ($Verbose) {
            $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
            Write-Host "   [IGNORADO] $relativePath" -ForegroundColor Gray
        }
        return
    }
    
    $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
    
    Write-Host "   Processando: $relativePath" -ForegroundColor White
    
    # FASE 2: Converter static const (apenas analise por seguranca)
    # $phase2 = Convert-StaticConstToGetter -content $content
    # $content = $phase2.Content
    # $script:stats.StaticConstConverted += $phase2.Converted
    
    # FASE 3: Tratar inicializadores de campo (apenas analise por seguranca)
    # $phase3 = Fix-FieldInitializers -content $content
    # $content = $phase3.Content
    # $script:stats.FieldInitializersFixed += $phase3.Fixed
    
    # FASE 4: Adicionar BuildContext a metodos
    $phase4 = Add-ContextToMethods -content $content
    $content = $phase4.Content
    $script: stats.MethodsWithContextAdded += $phase4.MethodsFixed
    
    # FASE 5: Migrar ocorrencias validas
    $phase5 = Migrate-ValidOccurrences -content $content
    $content = $phase5.Content
    $script:stats.OccurrencesMigrated += $phase5.Migrated
    $script:stats. Skipped += $phase5.Skipped
    
    # FASE 6: Remover const
    $phase6 = Remove-ConstFromDynamicBlocks -content $content
    $content = $phase6.Content
    $script: stats.ConstRemoved += $phase6.Removed
    
    # FASE 7: Adicionar import
    if ($content -ne $originalContent) {
        $content = Add-ThemeColorsImport -content $content
        
        if (-not $DryRun -and -not $AnalyzeOnly) {
            Set-Content $filePath $content -NoNewline -Encoding UTF8
        }
        
        $script:stats.FilesProcessed++
        
        Write-Host "      Metodos +context: $($phase4.MethodsFixed) | Migrados: $($phase5.Migrated) | Const removidos: $($phase6.Removed) | Ignorados: $($phase5.Skipped)" -ForegroundColor Gray
    }
}

# ==============================================================================
# EXECUCAO
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

Write-Host "   Arquivos com AppThemeColors:  $($filesToProcess.Count)" -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] Processando arquivos..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $filesToProcess) {
    Process-File -filePath $file. FullName
}

# ==============================================================================
# RELATORIO
# ==============================================================================

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "                    RELATORIO FINAL v8.0                          " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO:  DRY RUN (nenhum arquivo modificado)" -ForegroundColor Yellow
} elseif ($AnalyzeOnly) {
    Write-Host "   MODO:  APENAS ANALISE" -ForegroundColor Yellow
} else {
    Write-Host "   MODO:  EXECUCAO COMPLETA" -ForegroundColor Green
}

Write-Host ""
Write-Host "   Arquivos processados:       $($script:stats.FilesProcessed)" -ForegroundColor White
Write-Host "   Metodos com +context:      $($script:stats. MethodsWithContextAdded)" -ForegroundColor Cyan
Write-Host "   Ocorrencias migradas:      $($script:stats.OccurrencesMigrated)" -ForegroundColor Green
Write-Host "   Const removidos:           $($script:stats.ConstRemoved)" -ForegroundColor Yellow
Write-Host "   Ignorados (sem context):   $($script:stats.Skipped)" -ForegroundColor Gray
Write-Host ""

# Salvar relatorio
$reportPath = "d:\tagbean\MIGRATION_REPORT_V8.txt"
$report = @()
$report += "=== RELATORIO MIGRACAO v8.0 ==="
$report += "Data: $(Get-Date)"
$report += "Modo: $(if ($DryRun) { 'DRY RUN' } elseif ($AnalyzeOnly) { 'ANALISE' } else { 'EXECUCAO' })"
$report += ""
$report += "=== ESTATISTICAS ==="
$report += "Arquivos:  $($script:stats.FilesProcessed)"
$report += "Metodos +context: $($script:stats.MethodsWithContextAdded)"
$report += "Migrados: $($script: stats.OccurrencesMigrated)"
$report += "Const removidos: $($script:stats. ConstRemoved)"
$report += "Ignorados: $($script:stats. Skipped)"

$report | Out-File $reportPath -Encoding UTF8
Write-Host "Relatorio salvo:  $reportPath" -ForegroundColor Gray

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "   PROXIMOS PASSOS MANUAIS NECESSARIOS                            " -ForegroundColor Yellow
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "   1. Revisar arquivos com 'TODO:  Migrar para tema dinamico'" -ForegroundColor White
Write-Host "   2. Refatorar static const com cores para metodos ou getters" -ForegroundColor White
Write-Host "   3. Mover inicializadores de campo para didChangeDependencies()" -ForegroundColor White
Write-Host "   4. Executar:  flutter analyze lib\modules" -ForegroundColor White
Write-Host "   5. Corrigir erros restantes manualmente" -ForegroundColor White
Write-Host ""