# Script Final para Corrigir TODOS os Gradientes
param(
    [string]$Path = "F:\tagbean\frontend - Copia\lib"
)

Write-Host "🚀 SCRIPT FINAL - CORREÇÃO COMPLETA DE GRADIENTES" -ForegroundColor Green

$dartFiles = Get-ChildItem -Path $Path -Filter "*.dart" -Recurse
$totalFiles = 0
$totalReplacements = 0

foreach ($file in $dartFiles) {
    Write-Host "`nProcessando: $($file.Name)" -ForegroundColor Cyan
    
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    $fileReplacements = 0
    
    # 1. CORRIGIR SINTAXE MALFORMADA
    $fixes = @{
        'AppGradients\.darkBackgroun\(context\)d\(context\)' = 'AppGradients.darkBackground(context)'
        'AppGradients\.primaryHeade\(context\)r\(context\)' = 'AppGradients.primaryHeader(context)'
        'AppGradients\.syncBlu\(context\)e\(context\)' = 'AppGradients.syncBlue(context)'
    }
    
    foreach ($pattern in $fixes.Keys) {
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $fixes[$pattern]
            $count = ([regex]::Matches($originalContent, $pattern)).Count
            $fileReplacements += $count
            Write-Host "  ✅ Corrigido sintaxe malformada: $count" -ForegroundColor Green
        }
    }
    
    # 2. CORRIGIR fromBaseColor malformado
    $pattern = 'AppGradients\.fromBaseCol\(context\)o\(context\)r\(([^)]+)\)'
    $content = $content -replace $pattern, 'AppGradients.fromBaseColor(context, $1)'
    
    # 3. CORRIGIR GRADIENTES NÃO CHAMADOS
    $gradients = @('darkBackground', 'primaryHeader', 'success', 'alert', 'blueCyan', 'greenProduct', 'strategyDetail', 'syncBlue')
    
    foreach ($gradient in $gradients) {
        # gradient: AppGradients.nome, -> gradient: AppGradients.nome(context),
        $pattern = "gradient:\s*AppGradients\.$gradient,"
        $replacement = "gradient: AppGradients.$gradient(context),"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $fileReplacements++
        }
        
        # ? AppGradients.nome : -> ? AppGradients.nome(context) :
        $pattern = "\?\s*AppGradients\.$gradient\s*:"
        $replacement = "? AppGradients.$gradient(context) :"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $fileReplacements++
        }
        
        # : AppGradients.nome, -> : AppGradients.nome(context),
        $pattern = ":\s*AppGradients\.$gradient,"
        $replacement = ": AppGradients.$gradient(context),"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $fileReplacements++
        }
    }
    
    # 4. MÓDULOS GRADIENTES
    $moduleGradients = @('produtos', 'precificacao')
    foreach ($gradient in $moduleGradients) {
        $pattern = "gradient:\s*ModuleGradients\.$gradient,"
        $replacement = "gradient: ModuleGradients.$gradient(context),"
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $fileReplacements++
        }
    }
    
    # SALVAR SE HOUVE MUDANÇAS
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        $totalFiles++
        $totalReplacements += $fileReplacements
        Write-Host "  💾 Salvo com $fileReplacements correções!" -ForegroundColor Green
    }
}

Write-Host "`n🎉 CONCLUÍDO!" -ForegroundColor Green
Write-Host "📝 Arquivos modificados: $totalFiles" -ForegroundColor Yellow
Write-Host "🔄 Total de correções: $totalReplacements" -ForegroundColor Yellow