# ==============================================================================
# Script COMPLETO de Migracao com Adicao de BuildContext
# VERSAO 7.0 - ADICIONA CONTEXT AOS METODOS QUE PRECISAM
# ==============================================================================
#
# ESTRATEGIA:
# 1. FASE 1: Encontrar todos os metodos _buildXXX que usam AppThemeColors
# 2. FASE 2: Adicionar BuildContext context como parametro
# 3. FASE 3: Atualizar todas as chamadas para passar context
# 4. FASE 4: Migrar AppThemeColors -> ThemeColors.of(context)
# 5. FASE 5: Remover const de blocos com ThemeColors
# 6. FASE 6: Adicionar import
#
# ==============================================================================

param(
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [string]$TargetFolder = "d:\tagbean\frontend\lib\modules",
    [string]$SingleFile = ""
)

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "   MIGRACAO COMPLETA COM ADICAO DE BUILDCONTEXT                   " -ForegroundColor Cyan
Write-Host "                        VERSAO 7.0                                " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO: DRY RUN (simulacao)" -ForegroundColor Yellow
} else {
    Write-Host "   MODO: EXECUCAO REAL" -ForegroundColor Green
}
Write-Host ""

# Contadores
$script:totalMethodsFixed = 0
$script:totalCallsFixed = 0
$script:totalMigrated = 0
$script:totalConstRemoved = 0
$script:filesModified = @()

# ==============================================================================
# Arquivos/pastas a ignorar
# ==============================================================================
$ignorePatterns = @(
    "\\data\\models\\",
    "\\data\\repositories\\",
    "\\domain\\",
    "\\providers\\.*_provider\.dart$",
    "\\application\\",
    "\.g\.dart$",
    "\.freezed\.dart$"
)

function Test-ShouldIgnore {
    param([string]$path)
    foreach ($pattern in $ignorePatterns) {
        if ($path -match $pattern) { return $true }
    }
    return $false
}

# ==============================================================================
# FASE 1 & 2: Encontrar metodos _buildXXX sem context e adicionar
# ==============================================================================
function Add-ContextToMethods {
    param([string]$content)
    
    $methodsFixed = 0
    $callsFixed = 0
    
    # Pattern para encontrar metodos _buildXXX que usam AppThemeColors
    # mas NAO tem BuildContext no parametro
    
    # Primeiro, encontrar todos os metodos que usam AppThemeColors
    $methodPattern = "(?<return>Widget|List<Widget>|Container|Column|Row|Padding|Center|Expanded|Card|Text|Icon|void)\s+(?<name>_build\w+)\s*\((?<params>[^)]*)\)\s*\{"
    
    $methodMatches = [regex]::Matches($content, $methodPattern)
    
    # Coletar metodos que precisam de context
    $methodsNeedingContext = @{}
    
    foreach ($match in $methodMatches) {
        $methodName = $match.Groups["name"].Value
        $params = $match.Groups["params"].Value
        $returnType = $match.Groups["return"].Value
        $fullMatch = $match.Value
        $startIdx = $match.Index
        
        # Verificar se ja tem BuildContext
        if ($params -match "BuildContext") {
            continue
        }
        
        # Encontrar o corpo do metodo (balancear chaves)
        $bodyStart = $startIdx + $fullMatch.Length - 1  # posicao do {
        $depth = 1
        $bodyEnd = $bodyStart + 1
        
        for ($i = $bodyStart + 1; $i -lt $content.Length -and $depth -gt 0; $i++) {
            if ($content[$i] -eq '{') { $depth++ }
            elseif ($content[$i] -eq '}') { $depth-- }
            $bodyEnd = $i
        }
        
        $methodBody = $content.Substring($bodyStart, $bodyEnd - $bodyStart + 1)
        
        # Verificar se o corpo usa AppThemeColors
        if ($methodBody -match "AppThemeColors\.") {
            $methodsNeedingContext[$methodName] = @{
                Index = $match.Index
                Length = $match.Length
                Params = $params
                ReturnType = $returnType
                FullMatch = $fullMatch
            }
        }
    }
    
    # Agora processar de tras para frente para manter os indices
    $sortedMethods = $methodsNeedingContext.GetEnumerator() | Sort-Object { $_.Value.Index } -Descending
    
    foreach ($entry in $sortedMethods) {
        $methodName = $entry.Key
        $info = $entry.Value
        $params = $info.Params
        
        # Criar nova assinatura com BuildContext
        if ([string]::IsNullOrWhiteSpace($params)) {
            $newParams = "BuildContext context"
        } else {
            $newParams = "BuildContext context, $params"
        }
        
        $oldSignature = "$($info.ReturnType) $methodName($params)"
        $newSignature = "$($info.ReturnType) $methodName($newParams)"
        
        # Substituir a assinatura
        $oldPattern = [regex]::Escape("$($info.ReturnType) $methodName(") + [regex]::Escape($params) + "\)"
        $content = $content -replace $oldPattern, "$($info.ReturnType) $methodName($newParams)"
        
        $methodsFixed++
        
        if ($Verbose) {
            Write-Host "      [METHOD] $methodName - adicionado BuildContext" -ForegroundColor Cyan
        }
    }
    
    # FASE 3: Atualizar chamadas aos metodos
    foreach ($entry in $methodsNeedingContext.GetEnumerator()) {
        $methodName = $entry.Key
        $params = $entry.Value.Params
        
        # Pattern para encontrar chamadas: _buildXXX( ou _buildXXX(algo)
        # Mas NAO _buildXXX(context, ou _buildXXX(BuildContext
        
        # Chamada sem argumentos: _buildXXX()
        $callPatternEmpty = "(?<!Widget\s)(?<!void\s)(?<!List<Widget>\s)($methodName)\s*\(\s*\)"
        $content = [regex]::Replace($content, $callPatternEmpty, '$1(context)')
        
        # Chamada com argumentos (mas sem context): _buildXXX(arg1, arg2)
        # Precisamos verificar se o primeiro arg NAO eh context
        $callPatternWithArgs = "(?<!Widget\s)(?<!void\s)(?<!List<Widget>\s)($methodName)\s*\(\s*(?!context)(?!BuildContext)([^)]+)\)"
        
        $callMatches = [regex]::Matches($content, $callPatternWithArgs)
        
        # Processar de tras para frente
        for ($i = $callMatches.Count - 1; $i -ge 0; $i--) {
            $callMatch = $callMatches[$i]
            $name = $callMatch.Groups[1].Value
            $args = $callMatch.Groups[2].Value
            
            # Verificar se ja nao tem context
            if ($args -notmatch "^context\s*,") {
                $newCall = "$name(context, $args)"
                $content = $content.Substring(0, $callMatch.Index) + $newCall + $content.Substring($callMatch.Index + $callMatch.Length)
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
# FASE 4: Migrar AppThemeColors -> ThemeColors.of(context)
# ==============================================================================
function Migrate-AppThemeColors {
    param([string]$content)
    
    $migrated = 0
    
    # Substituir todas as ocorrencias de AppThemeColors.XXX
    $pattern = "AppThemeColors\.(\w+)"
    
    $content = [regex]::Replace($content, $pattern, {
        param($match)
        $script:totalMigrated++
        $migrated++
        return "ThemeColors.of(context).$($match.Groups[1].Value)"
    })
    
    return @{
        Content = $content
        Migrated = $migrated
    }
}

# ==============================================================================
# FASE 5: Remover const de blocos com ThemeColors
# ==============================================================================
function Remove-ConstFromBlocks {
    param([string]$content)
    
    $removed = 0
    
    $widgets = @(
        "LinearGradient", "BoxDecoration", "TextStyle", "Icon", "Text",
        "SnackBar", "BorderSide", "InputDecoration", "OutlineInputBorder",
        "Container", "Padding", "Row", "Column", "Expanded", "Center",
        "SizedBox", "Divider", "Card", "ListTile", "Chip", "CircleAvatar",
        "ColorScheme", "IconThemeData", "Positioned", "ClipRRect", "Material",
        "InkWell", "GestureDetector", "Tooltip", "Badge", "DecoratedBox"
    )
    
    foreach ($widget in $widgets) {
        $pattern = "const\s+($widget)\s*\("
        $matches = [regex]::Matches($content, $pattern)
        
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
                $block = $content.Substring($startIdx, $blockLength)
                
                if ($block -match "ThemeColors\.of\(context\)") {
                    $newBlock = $block -replace "^const\s+", ""
                    $content = $content.Substring(0, $startIdx) + $newBlock + $content.Substring($startIdx + $blockLength)
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
# FASE 6: Adicionar import
# ==============================================================================
function Add-Import {
    param([string]$content)
    
    $importLine = "import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';"
    
    if ($content -match "theme_colors_dynamic\.dart") {
        return $content
    }
    
    # Encontrar onde inserir o import (apos outros imports)
    $importMatch = [regex]::Match($content, "(?m)(^import\s+'[^']+';[\r\n]+)+")
    if ($importMatch.Success) {
        $insertPos = $importMatch.Index + $importMatch.Length
        $content = $content.Insert($insertPos, $importLine + "`n")
    }
    
    return $content
}

# ==============================================================================
# FUNCAO PRINCIPAL: Processar arquivo
# ==============================================================================
function Process-File {
    param([string]$filePath)
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    $originalContent = $content
    
    # Verificar se deve ignorar
    if (Test-ShouldIgnore $filePath) {
        return
    }
    
    # Verificar se tem AppThemeColors
    if ($content -notmatch "AppThemeColors\.") {
        return
    }
    
    $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
    
    # FASE 1 & 2 & 3: Adicionar context aos metodos e atualizar chamadas
    $phase1 = Add-ContextToMethods -content $content
    $content = $phase1.Content
    
    # FASE 4: Migrar AppThemeColors
    $phase4 = Migrate-AppThemeColors -content $content
    $content = $phase4.Content
    
    # FASE 5: Remover const
    $phase5 = Remove-ConstFromBlocks -content $content
    $content = $phase5.Content
    
    # FASE 6: Adicionar import
    $content = Add-Import -content $content
    
    # Estatisticas
    $script:totalMethodsFixed += $phase1.MethodsFixed
    $script:totalCallsFixed += $phase1.CallsFixed
    $script:totalConstRemoved += $phase5.Removed
    
    if ($content -ne $originalContent) {
        $script:filesModified += $relativePath
        
        if (-not $DryRun) {
            Set-Content $filePath $content -NoNewline -Encoding UTF8
        }
        
        Write-Host "   $relativePath" -ForegroundColor White
        Write-Host "      Metodos: $($phase1.MethodsFixed) | Chamadas: $($phase1.CallsFixed) | Migrados: $($phase4.Migrated) | Const: $($phase5.Removed)" -ForegroundColor Gray
    }
}

# ==============================================================================
# EXECUCAO
# ==============================================================================

Write-Host "[1/2] Coletando arquivos..." -ForegroundColor Yellow

$filesToProcess = @()

if ($SingleFile) {
    if (Test-Path $SingleFile) {
        $filesToProcess += Get-Item $SingleFile
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

Write-Host "   Arquivos: $($filesToProcess.Count)" -ForegroundColor Green
Write-Host ""

Write-Host "[2/2] Processando..." -ForegroundColor Yellow
Write-Host ""

foreach ($file in $filesToProcess) {
    Process-File -filePath $file.FullName
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
    Write-Host "   MODO: DRY RUN" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "   Arquivos modificados:  $($script:filesModified.Count)" -ForegroundColor White
Write-Host "   Metodos com context:   $($script:totalMethodsFixed)" -ForegroundColor Cyan
Write-Host "   Chamadas atualizadas:  $($script:totalCallsFixed)" -ForegroundColor Cyan
Write-Host "   AppThemeColors migrados: $($script:totalMigrated)" -ForegroundColor Green
Write-Host "   Const removidos:       $($script:totalConstRemoved)" -ForegroundColor Yellow
Write-Host ""

# Salvar relatorio
$report = @()
$report += "=== RELATORIO v7.0 ==="
$report += "Data: $(Get-Date)"
$report += "Arquivos: $($script:filesModified.Count)"
$report += "Metodos: $($script:totalMethodsFixed)"
$report += "Chamadas: $($script:totalCallsFixed)"
$report += "Migrados: $($script:totalMigrated)"
$report += "Const: $($script:totalConstRemoved)"
$report += ""
$report += "=== ARQUIVOS ==="
$report += $script:filesModified

$report | Out-File "d:\tagbean\MIGRATION_REPORT_V7.txt" -Encoding UTF8
Write-Host "Relatorio: d:\tagbean\MIGRATION_REPORT_V7.txt" -ForegroundColor Gray
