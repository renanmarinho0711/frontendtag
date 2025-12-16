# ==============================================================================
# Script para REMOVER CONST de blocos com ThemeColors.of(context)
# Este script deve ser executado APÓS a migração
# ==============================================================================

param(
    [switch]$DryRun = $false,
    [string]$TargetFolder = "d:\tagbean\frontend\lib\modules"
)

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "   REMOCAO AGRESSIVA DE CONST                                     " -ForegroundColor Cyan
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host ""

$script:totalRemoved = 0
$script:filesFixed = @()

function Remove-AllConstWithThemeColors {
    param([string]$filePath)
    
    $content = Get-Content $filePath -Raw -Encoding UTF8
    $originalContent = $content
    $removed = 0
    
    if ($content -notmatch "ThemeColors\.of\(context\)") {
        return 0
    }
    
    # Lista extensa de todos os widgets possiveis
    $widgets = @(
        "LinearGradient", "RadialGradient", "SweepGradient",
        "BoxDecoration", "ShapeDecoration", "InputDecoration", 
        "TextStyle", "TextSpan",
        "Icon", "IconButton", "IconData",
        "Text", "RichText", "SelectableText",
        "SnackBar", "SnackBarAction",
        "BorderSide", "Border", "BorderRadius", "RoundedRectangleBorder",
        "OutlineInputBorder", "UnderlineInputBorder",
        "Container", "DecoratedBox", "ColoredBox",
        "Padding", "Margin", "EdgeInsets",
        "Row", "Column", "Wrap", "Stack", "Positioned", "Align",
        "Expanded", "Flexible", "Spacer",
        "Center", "SizedBox", "ConstrainedBox", "FractionallySizedBox",
        "Divider", "VerticalDivider",
        "Card", "Material", "Ink", "InkWell", "InkResponse",
        "ListTile", "ListBody",
        "Chip", "InputChip", "FilterChip", "ChoiceChip", "ActionChip",
        "CircleAvatar", "ClipRRect", "ClipOval", "ClipPath",
        "ColorScheme", "IconThemeData", "ThemeData",
        "Badge", "Tooltip", "Semantics",
        "FloatingActionButton", "ElevatedButton", "TextButton", "OutlinedButton",
        "AppBar", "SliverAppBar", "BottomAppBar",
        "NavigationRail", "NavigationRailDestination",
        "BottomNavigationBar", "BottomNavigationBarItem",
        "Drawer", "DrawerHeader",
        "AlertDialog", "SimpleDialog", "Dialog",
        "PopupMenuButton", "PopupMenuItem", "DropdownButton", "DropdownMenuItem",
        "Tab", "TabBar", "TabBarView",
        "DataTable", "DataColumn", "DataRow", "DataCell",
        "ButtonStyle", "ButtonTheme",
        "InputDecorationTheme", "TextTheme", "ColorSwatch",
        "BoxConstraints", "Offset", "Size", "Rect",
        "Shadow", "BoxShadow", "Decoration", "DecorationImage"
    )
    
    foreach ($widget in $widgets) {
        # Pattern mais simples: encontrar "const Widget("
        $simplePattern = "const\s+($widget)\s*\("
        $matches = [regex]::Matches($content, $simplePattern)
        
        # Processar de tras para frente
        for ($i = $matches.Count - 1; $i -ge 0; $i--) {
            $match = $matches[$i]
            $startIdx = $match.Index
            
            # Encontrar o fechamento balanceado do parentese
            $depth = 1
            $searchStart = $startIdx + $match.Length
            $endIdx = $searchStart
            
            for ($j = $searchStart; $j -lt $content.Length; $j++) {
                $char = $content[$j]
                if ($char -eq '(') { $depth++ }
                elseif ($char -eq ')') { 
                    $depth--
                    if ($depth -eq 0) { 
                        $endIdx = $j
                        break 
                    }
                }
            }
            
            # Extrair bloco completo
            $blockLength = $endIdx - $startIdx + 1
            if ($blockLength -gt 0 -and $startIdx + $blockLength -le $content.Length) {
                $block = $content.Substring($startIdx, $blockLength)
                
                # Verificar se contem ThemeColors.of(context)
                if ($block -match "ThemeColors\.of\(context\)") {
                    # Remover "const " do inicio
                    $newBlock = $block -replace "^const\s+", ""
                    $content = $content.Substring(0, $startIdx) + $newBlock + $content.Substring($startIdx + $blockLength)
                    $removed++
                }
            }
        }
    }
    
    # Também verificar padrões inline: const TextStyle(color: ThemeColors...
    # Esses podem não ter sido pegos
    
    if ($removed -gt 0 -or $content -ne $originalContent) {
        $relativePath = $filePath.Replace($TargetFolder, "").TrimStart("\")
        $script:filesFixed += "${removed} removidos em ${relativePath}"
        $script:totalRemoved += $removed
        
        if (-not $DryRun) {
            Set-Content $filePath $content -NoNewline -Encoding UTF8
        }
        
        Write-Host "   $removed removidos: $relativePath" -ForegroundColor Green
    }
    
    return $removed
}

# Processar arquivos
$dartFiles = Get-ChildItem $TargetFolder -Recurse -Filter "*.dart"

foreach ($file in $dartFiles) {
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if ($content -match "ThemeColors\.of\(context\)" -and $content -match "const\s+\w+\s*\(") {
        Remove-AllConstWithThemeColors -filePath $file.FullName
    }
}

Write-Host ""
Write-Host "==================================================================" -ForegroundColor Cyan
Write-Host "   Total const removidos: $($script:totalRemoved)" -ForegroundColor Green
Write-Host "==================================================================" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "   Modo DRY RUN - nenhum arquivo modificado" -ForegroundColor Yellow
}
