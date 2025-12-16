# ==============================================================================
# Script de Migracao: AppThemeColors -> ThemeColors.of(context)
# VERSAO 4.0 - Processamento completo com remocao de const multi-linha
# ==============================================================================
#
# MELHORIAS V4:
# - Processa o arquivo INTEIRO, nao linha por linha
# - Remove 'const' mesmo quando esta em linhas diferentes do ThemeColors
# - Detecta blocos const que contem ThemeColors.of(context)
# - Ignora contextos invalidos (inicializadores de campo, static const)
# - Melhor tratamento de LinearGradient, SnackBar, Text, Icon multi-linha
# ==============================================================================

param(
    [switch]$DryRun = $false,
    [switch]$NoBackup = $false,
    [string]$SingleFile = "",
    [string]$TargetFolder = "d:\tagbean\frontend\lib",
    [switch]$Verbose = $false
)

$BackupFolder = "d:\tagbean\frontend\lib_backup_themes_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "     MIGRACAO: AppThemeColors -> ThemeColors.of(context)          " -ForegroundColor Cyan
Write-Host "                        VERSAO 4.0                                " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO: DRY RUN (simulacao - nenhum arquivo sera modificado)" -ForegroundColor Yellow
} else {
    Write-Host "   MODO: EXECUCAO REAL" -ForegroundColor Green
}
Write-Host ""

# Contadores
$script:totalFiles = 0
$script:totalReplacements = 0
$script:modifiedFiles = @()
$script:skippedFiles = @()
$script:errorFiles = @()
$script:manualReviewFiles = @()

# ==============================================================================
# ARQUIVOS/PASTAS A IGNORAR COMPLETAMENTE (nao tem acesso a context)
# ==============================================================================
$ignorePatterns = @(
    "*\theme_colors.dart",
    "*\theme_colors_*.dart",
    "*\theme_provider.dart",
    "*\temas\*",
    "*\data\models\*",
    "*\data\repositories\*",
    "*\data\datasources\*",
    "*\domain\entities\*",
    "*\domain\repositories\*",
    "*\domain\usecases\*",
    "*\providers\*_provider.dart",
    "*\application\*",
    "*\core\constants\*",
    "*\core\utils\*",
    "*.g.dart",
    "*.freezed.dart"
)

# ==============================================================================
# FUNCAO: Verificar se arquivo deve ser ignorado
# ==============================================================================
function Test-ShouldIgnoreFile {
    param([string]$filePath)
    
    foreach ($pattern in $ignorePatterns) {
        if ($filePath -like $pattern) { return $true }
    }
    
    $content = Get-Content $filePath -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
    if ($content) {
        $hasWidget = $content -match "extends\s+(Stateless|Stateful)Widget" -or 
                     $content -match "extends\s+ConsumerWidget" -or
                     $content -match "extends\s+ConsumerStatefulWidget" -or
                     $content -match "extends\s+HookConsumerWidget" -or
                     $content -match "BuildContext\s+context"
        
        if (-not $hasWidget -and $content -match "AppThemeColors\.") {
            return $true
        }
    }
    
    return $false
}

# ==============================================================================
# FUNCAO: Remover const de blocos que contem ThemeColors.of(context)
# Esta funcao processa o conteudo INTEIRO do arquivo
# ==============================================================================
function Remove-ConstFromThemeColorBlocks {
    param([string]$content)
    
    $modified = $false
    
    # Lista de widgets que podem ter const e conter cores
    $widgets = @(
        "LinearGradient",
        "BoxDecoration", 
        "TextStyle",
        "Icon",
        "Text",
        "SnackBar",
        "BorderSide",
        "Expanded",
        "Container",
        "Padding",
        "Center",
        "Row",
        "Column",
        "Divider",
        "InputDecoration",
        "OutlineInputBorder",
        "UnderlineInputBorder"
    )
    
    foreach ($widget in $widgets) {
        # Pattern para encontrar "const WidgetName(" seguido de conteudo ate o fechamento
        # que contenha ThemeColors.of(context)
        
        # Abordagem: encontrar todas as ocorrencias de "const $widget("
        # e verificar se o bloco contem ThemeColors.of(context)
        
        $pattern = "const\s+($widget)\s*\("
        $matches = [regex]::Matches($content, $pattern)
        
        # Processar de tras para frente para nao afetar os indices
        for ($i = $matches.Count - 1; $i -ge 0; $i--) {
            $match = $matches[$i]
            $startIdx = $match.Index
            
            # Encontrar o fechamento do parentese
            $depth = 1
            $searchStart = $startIdx + $match.Length
            $endIdx = $searchStart
            
            for ($j = $searchStart; $j -lt $content.Length -and $depth -gt 0; $j++) {
                if ($content[$j] -eq '(') { $depth++ }
                elseif ($content[$j] -eq ')') { $depth-- }
                $endIdx = $j
            }
            
            # Extrair o bloco
            $blockLength = $endIdx - $startIdx + 1
            $block = $content.Substring($startIdx, $blockLength)
            
            # Verificar se o bloco contem ThemeColors.of(context)
            if ($block -match "ThemeColors\.of\(context\)") {
                # Remover o "const " do inicio
                $newBlock = $block -replace "^const\s+", ""
                $content = $content.Substring(0, $startIdx) + $newBlock + $content.Substring($startIdx + $blockLength)
                $modified = $true
            }
        }
    }
    
    return @{
        Content = $content
        Modified = $modified
    }
}

# ==============================================================================
# FUNCAO: Verificar se uma posicao esta em contexto invalido
# ==============================================================================
function Test-PositionInInvalidContext {
    param([string]$content, [int]$position)
    
    # Encontrar o inicio da linha
    $lineStart = $content.LastIndexOf("`n", [Math]::Max(0, $position - 1))
    if ($lineStart -lt 0) { $lineStart = 0 }
    
    # Encontrar o fim da linha
    $lineEnd = $content.IndexOf("`n", $position)
    if ($lineEnd -lt 0) { $lineEnd = $content.Length }
    
    # Extrair contexto (algumas linhas antes)
    $contextStart = $content.LastIndexOf("`n", [Math]::Max(0, $lineStart - 1))
    for ($i = 0; $i -lt 5; $i++) {
        $prev = $content.LastIndexOf("`n", [Math]::Max(0, $contextStart - 1))
        if ($prev -ge 0) { $contextStart = $prev }
    }
    
    $contextBlock = $content.Substring($contextStart, $position - $contextStart)
    
    # Verificar padroes invalidos
    
    # 1. Declaracao de campo de classe (final List<Color>, Color _var = ...)
    if ($contextBlock -match "(final|late\s+final)\s+List<Color>\s+\w+\s*=\s*\[" -and $contextBlock -notmatch "\];") {
        return $true
    }
    
    # 2. static const/final
    if ($contextBlock -match "static\s+(const|final)\s+" -and $contextBlock -notmatch "[;{}]$") {
        return $true
    }
    
    # 3. Inicializador de campo simples
    if ($contextBlock -match "^\s*(Color|final\s+Color)\s+_\w+\s*=\s*$") {
        return $true
    }
    
    return $false
}

# ==============================================================================
# FUNCAO PRINCIPAL: Processar arquivo
# ==============================================================================
function Invoke-FileProcessing {
    param([string]$filePath, [bool]$isDryRun)
    
    try {
        $content = Get-Content $filePath -Raw -Encoding UTF8
        $originalContent = $content
        $count = 0
        $needsManualReview = @()
        
        if ($content -notmatch "AppThemeColors\.") { return 0 }
        
        # ==================================================================
        # PASSO 1: Identificar e marcar contextos invalidos
        # ==================================================================
        
        # Encontrar blocos que NAO devem ser migrados
        $invalidBlocks = @()
        
        # Pattern: final List<Color> _xxx = [...];
        $listPattern = "(final|late\s+final)\s+List<Color>\s+\w+\s*=\s*\[[^\]]+\];"
        $listMatches = [regex]::Matches($content, $listPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        foreach ($m in $listMatches) {
            $invalidBlocks += @{ Start = $m.Index; End = $m.Index + $m.Length; Text = $m.Value }
        }
        
        # Pattern: static const/final ... = ...;
        $staticPattern = "static\s+(const|final)\s+[^;]+;"
        $staticMatches = [regex]::Matches($content, $staticPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
        foreach ($m in $staticMatches) {
            if ($m.Value -match "AppThemeColors\.") {
                $invalidBlocks += @{ Start = $m.Index; End = $m.Index + $m.Length; Text = $m.Value }
            }
        }
        
        # Pattern: Color _xxx = AppThemeColors.xxx; (inicializador de campo)
        $fieldPattern = "^\s*(Color|final\s+Color|late\s+Color)\s+_\w+\s*=\s*AppThemeColors\.\w+;"
        $fieldMatches = [regex]::Matches($content, $fieldPattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)
        foreach ($m in $fieldMatches) {
            $invalidBlocks += @{ Start = $m.Index; End = $m.Index + $m.Length; Text = $m.Value }
        }
        
        # Registrar blocos invalidos para revisao manual
        foreach ($block in $invalidBlocks) {
            if ($block.Text -match "AppThemeColors\.") {
                $lineNum = ($content.Substring(0, $block.Start) -split "`n").Count
                $needsManualReview += "Linha $lineNum : Contexto invalido (inicializador/static)"
            }
        }
        
        # ==================================================================
        # PASSO 2: Substituir AppThemeColors -> ThemeColors.of(context)
        # (apenas em contextos validos)
        # ==================================================================
        
        # Encontrar todas as ocorrencias de AppThemeColors
        $appThemeMatches = [regex]::Matches($content, "AppThemeColors\.(\w+)")
        
        # Processar de tras para frente
        for ($i = $appThemeMatches.Count - 1; $i -ge 0; $i--) {
            $match = $appThemeMatches[$i]
            $pos = $match.Index
            
            # Verificar se esta em um bloco invalido
            $isInvalid = $false
            foreach ($block in $invalidBlocks) {
                if ($pos -ge $block.Start -and $pos -lt $block.End) {
                    $isInvalid = $true
                    break
                }
            }
            
            if (-not $isInvalid) {
                # Substituir
                $colorName = $match.Groups[1].Value
                $replacement = "ThemeColors.of(context).$colorName"
                $content = $content.Substring(0, $pos) + $replacement + $content.Substring($pos + $match.Length)
                $count++
            }
        }
        
        # ==================================================================
        # PASSO 3: Remover 'const' de blocos que agora tem ThemeColors.of(context)
        # ==================================================================
        
        $result = Remove-ConstFromThemeColorBlocks -content $content
        $content = $result.Content
        
        # ==================================================================
        # PASSO 4: Limpeza adicional - const residuais na mesma linha
        # ==================================================================
        
        # Pattern: const Widget(...ThemeColors.of(context)...) na mesma linha
        $inlineConstPatterns = @(
            'const\s+(TextStyle\s*\([^)]*ThemeColors\.of\(context\)[^)]*\))',
            'const\s+(Icon\s*\([^)]*ThemeColors\.of\(context\)[^)]*\))',
            'const\s+(BorderSide\s*\([^)]*ThemeColors\.of\(context\)[^)]*\))',
            'const\s+(Text\s*\([^)]*ThemeColors\.of\(context\)[^)]*\))'
        )
        
        foreach ($pattern in $inlineConstPatterns) {
            $content = [regex]::Replace($content, $pattern, '$1')
        }
        
        # ==================================================================
        # PASSO 5: Adicionar import se necessario
        # ==================================================================
        
        if ($content -ne $originalContent) {
            $importLine = "import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';"
            
            if ($content -notmatch "theme_colors_dynamic\.dart") {
                # Encontrar ultima linha de import
                $importMatch = [regex]::Match($content, "(?m)(^import\s+'[^']+';[\r\n]+)+")
                if ($importMatch.Success) {
                    $insertPos = $importMatch.Index + $importMatch.Length
                    $content = $content.Insert($insertPos, $importLine + "`n")
                }
            }
            
            if (-not $isDryRun) {
                Set-Content $filePath $content -NoNewline -Encoding UTF8
            }
            
            $script:totalReplacements += $count
            $script:totalFiles++
            
            $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
            $script:modifiedFiles += "$count substituicoes: $relativePath"
            
            if ($needsManualReview.Count -gt 0) {
                $script:manualReviewFiles += @{
                    Path = $relativePath
                    Lines = $needsManualReview
                }
            }
            
            return $count
        }
        
        # Se nao modificou mas tem blocos invalidos, registrar
        if ($needsManualReview.Count -gt 0) {
            $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
            $script:manualReviewFiles += @{
                Path = $relativePath
                Lines = $needsManualReview
            }
        }
        
        return 0
    }
    catch {
        $script:errorFiles += "$filePath : $($_.Exception.Message)"
        return 0
    }
}

# ==============================================================================
# PASSO 1: Backup
# ==============================================================================
if (-not $DryRun -and -not $NoBackup -and -not $SingleFile) {
    Write-Host "[1/4] Criando backup..." -ForegroundColor Yellow
    Copy-Item $TargetFolder $BackupFolder -Recurse
    Write-Host "      Backup criado: $BackupFolder" -ForegroundColor Green
} else {
    Write-Host "[1/4] Backup ignorado" -ForegroundColor Gray
}

# ==============================================================================
# PASSO 2: Coletar arquivos
# ==============================================================================
Write-Host ""
Write-Host "[2/4] Coletando arquivos..." -ForegroundColor Yellow

$filesToProcess = @()

if ($SingleFile) {
    if (Test-Path $SingleFile) {
        $filesToProcess += Get-Item $SingleFile
        Write-Host "      Arquivo unico: $SingleFile" -ForegroundColor Green
    } else {
        Write-Host "      Arquivo nao encontrado: $SingleFile" -ForegroundColor Red
        exit 1
    }
} else {
    $allFiles = Get-ChildItem $TargetFolder -Recurse -Filter "*.dart"
    $totalScanned = 0
    $totalSkipped = 0
    
    foreach ($file in $allFiles) {
        $totalScanned++
        if (Test-ShouldIgnoreFile $file.FullName) {
            $totalSkipped++
            $relativePath = $file.FullName.Replace($TargetFolder, "").TrimStart("\")
            $script:skippedFiles += $relativePath
            continue
        }
        
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -match "AppThemeColors\.") {
            $filesToProcess += $file
        }
    }
    
    Write-Host "      Total escaneados: $totalScanned arquivos" -ForegroundColor Gray
    Write-Host "      Ignorados (sem context): $totalSkipped arquivos" -ForegroundColor Gray
    Write-Host "      Para processar: $($filesToProcess.Count) arquivos" -ForegroundColor Green
}

# ==============================================================================
# PASSO 3: Processar
# ==============================================================================
Write-Host ""
Write-Host "[3/4] Processando substituicoes..." -ForegroundColor Yellow
Write-Host ""

$progressCount = 0
foreach ($file in $filesToProcess) {
    $progressCount++
    $percent = [math]::Round(($progressCount / $filesToProcess.Count) * 100)
    $count = Invoke-FileProcessing -filePath $file.FullName -isDryRun $DryRun
    if ($count -gt 0) {
        $relativePath = $file.FullName.Replace($TargetFolder, "").TrimStart("\")
        Write-Host "      [$percent%] $relativePath - $count substituicoes" -ForegroundColor White
    }
}

# ==============================================================================
# PASSO 4: Relatorio
# ==============================================================================
Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "                    RELATORIO FINAL                               " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "   MODO: DRY RUN (nenhum arquivo foi modificado)" -ForegroundColor Yellow
} else {
    Write-Host "   MODO: EXECUCAO COMPLETA" -ForegroundColor Green
}

Write-Host ""
Write-Host "   Arquivos modificados: $($script:totalFiles)" -ForegroundColor White
Write-Host "   Total substituicoes:  $($script:totalReplacements)" -ForegroundColor White
Write-Host "   Arquivos ignorados:   $($script:skippedFiles.Count)" -ForegroundColor Gray

if ($script:manualReviewFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "   REVISAO MANUAL NECESSARIA: $($script:manualReviewFiles.Count) arquivos" -ForegroundColor Yellow
    foreach ($item in $script:manualReviewFiles) {
        Write-Host "      - $($item.Path)" -ForegroundColor Yellow
    }
}

if ($script:errorFiles.Count -gt 0) {
    Write-Host ""
    Write-Host "   ERROS: $($script:errorFiles.Count) arquivos com problema" -ForegroundColor Red
    foreach ($err in $script:errorFiles) {
        Write-Host "      - $err" -ForegroundColor Red
    }
}

Write-Host ""

if ($DryRun) {
    Write-Host "Para executar de verdade:" -ForegroundColor Green
    Write-Host "  .\migrate_theme_colors_v4.ps1" -ForegroundColor Cyan
}

# Salvar relatorio
$reportPath = "d:\tagbean\MIGRATION_REPORT_V4.txt"
$reportContent = @()
$reportContent += "=== RELATORIO DE MIGRACAO V4.0 ==="
$reportContent += "Data: $(Get-Date)"
$reportContent += "Modo: $(if ($DryRun) { 'DRY RUN' } else { 'EXECUCAO' })"
$reportContent += ""
$reportContent += "=== ARQUIVOS MODIFICADOS ==="
$reportContent += $script:modifiedFiles
$reportContent += ""
$reportContent += "=== ARQUIVOS IGNORADOS (sem context) ==="
$reportContent += $script:skippedFiles
$reportContent += ""
$reportContent += "=== REVISAO MANUAL NECESSARIA ==="
$reportContent += "Os seguintes arquivos contem AppThemeColors em contextos invalidos"
$reportContent += "(inicializadores de campo, static const, etc) e NAO foram migrados:"
$reportContent += ""
foreach ($item in $script:manualReviewFiles) {
    $reportContent += "ARQUIVO: $($item.Path)"
    foreach ($line in $item.Lines) {
        $reportContent += "   $line"
    }
    $reportContent += ""
}
$reportContent += ""
$reportContent += "=== ERROS ==="
$reportContent += $script:errorFiles

$reportContent | Out-File $reportPath -Encoding UTF8
Write-Host "Relatorio salvo em: $reportPath" -ForegroundColor Gray
