# Script para migrar AppThemeColors para ThemeColors.of(context)
# Execute na pasta frontend

param(
    [string]$Path = "D:\tagbean\frontend\lib\features\dashboard",
    [switch]$DryRun = $false
)

Write-Host "=== Migracao de Cores Estaticas para Dinamicas ===" -ForegroundColor Cyan
Write-Host ""

$files = Get-ChildItem -Path $Path -Recurse -Filter "*.dart"
$totalFiles = 0
$totalReplacements = 0

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    if ($content -match 'AppThemeColors\.') {
        $matchCount = ([regex]::Matches($content, 'AppThemeColors\.')).Count
        
        if (-not $DryRun) {
            # Adiciona import se nao existir
            if ($content -notmatch "import.*theme_colors_dynamic\.dart") {
                $importLine = "import 'package:tagbean/design_system/theme/theme_colors_dynamic.dart';"
                # Encontra a ultima linha de import e adiciona apos
                $content = $content -replace "(import[^;]+;)(\r?\n)(?!import)", "`$1`$2$importLine`$2"
            }
            
            # Salva o arquivo modificado
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        }
        
        $totalFiles++
        $totalReplacements += $matchCount
        Write-Host "[$matchCount ocorrencias] $($file.Name)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=== Resumo ===" -ForegroundColor Cyan
Write-Host "Arquivos afetados: $totalFiles"
Write-Host "Total de ocorrencias: $totalReplacements"
Write-Host ""
Write-Host "IMPORTANTE: A substituicao de AppThemeColors. para ThemeColors.of(context). deve ser feita manualmente em cada arquivo," -ForegroundColor Red
Write-Host "pois requer adicionar 'final colors = ThemeColors.of(context);' no metodo build() e usar 'colors.' ao inves de 'AppThemeColors.'" -ForegroundColor Red
Write-Host ""
Write-Host "Exemplo de conversao:" -ForegroundColor Green
Write-Host "  ANTES: color: AppThemeColors.surface," -ForegroundColor Gray
Write-Host "  DEPOIS: color: ThemeColors.of(context).surface," -ForegroundColor Gray
Write-Host ""
Write-Host "Ou com variavel de cache (recomendado para performance):" -ForegroundColor Green
Write-Host "  final colors = ThemeColors.of(context);" -ForegroundColor Gray
Write-Host "  color: colors.surface," -ForegroundColor Gray
