# Script Final para Corrigir TODOS os Gradientes - Versão ROBUSTA
param(
    [string]$Path = "F:\tagbean\frontend - Copia\lib"
)

Write-Host "🚀 SCRIPT FINAL - CORREÇÃO COMPLETA DE GRADIENTES" -ForegroundColor Green
Write-Host "Caminho: $Path" -ForegroundColor Yellow

# Encontrar todos os arquivos .dart
$dartFiles = Get-ChildItem -Path $Path -Filter "*.dart" -Recurse

$totalFiles = 0
$totalReplacements = 0
$errorFiles = @()

foreach ($file in $dartFiles) {
    Write-Host "`n📁 Processando: $($file.FullName)" -ForegroundColor Cyan
    
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        $originalContent = $content
        $fileReplacements = 0
        
        # ========== CORREÇÕES DE SINTAXE MALFORMADA ==========
        Write-Host "   🔧 Corrigindo sintaxe malformada..." -ForegroundColor Yellow
        
        # Corrigir AppGradients.darkBackgroun(context)d(context) -> AppGradients.darkBackground(context)
        $pattern = 'AppGradients\.darkBackgroun\(context\)d\(context\)'
        $replacement = 'AppGradients.darkBackground(context)'
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $count = ([regex]::Matches($originalContent, $pattern)).Count
            $fileReplacements += $count
            Write-Host "      ✅ darkBackgroun(context)d(context) -> darkBackground(context): $count" -ForegroundColor Green
        }
        
        # Corrigir AppGradients.primaryHeade(context)r(context) -> AppGradients.primaryHeader(context)
        $pattern = 'AppGradients\.primaryHeade\(context\)r\(context\)'
        $replacement = 'AppGradients.primaryHeader(context)'
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $count = ([regex]::Matches($originalContent, $pattern)).Count
            $fileReplacements += $count
            Write-Host "      ✅ primaryHeade(context)r(context) -> primaryHeader(context): $count" -ForegroundColor Green
        }
        
        # Corrigir AppGradients.syncBlu(context)e(context) -> AppGradients.syncBlue(context)
        $pattern = 'AppGradients\.syncBlu\(context\)e\(context\)'
        $replacement = 'AppGradients.syncBlue(context)'
        if ($content -match $pattern) {
            $content = $content -replace $pattern, $replacement
            $count = ([regex]::Matches($originalContent, $pattern)).Count
            $fileReplacements += $count
            Write-Host "      ✅ syncBlu(context)e(context) -> syncBlue(context): $count" -ForegroundColor Green
        }
        
        # Corrigir AppGradients.fromBaseCol(context)o(context)r -> AppGradients.fromBaseColor(context)
        $pattern = 'AppGradients\.fromBaseCol\(context\)o\(context\)r\([^)]+\)'
        $regexMatches = [regex]::Matches($content, $pattern)
        foreach ($match in $regexMatches) {
            $fullMatch = $match.Value
            # Extrair o parâmetro final
            if ($fullMatch -match 'AppGradients\.fromBaseCol\(context\)o\(context\)r\(([^)]+)\)') {
                $param = $Matches[1]
                $replacement = "AppGradients.fromBaseColor(context, $param)"
                $content = $content.Replace($fullMatch, $replacement)
                $fileReplacements++
                Write-Host "      ✅ fromBaseCol malformado -> fromBaseColor(context, $param): 1" -ForegroundColor Green
            }
        }
        
        # ========== CORREÇÕES DE FUNÇÃO NÃO CHAMADA ==========
        Write-Host "   🔧 Corrigindo gradientes não chamados..." -ForegroundColor Yellow
        
        # Lista de todos os gradientes possíveis
        $gradients = @(
            'darkBackground', 'primaryHeader', 'success', 'alert', 'blueCyan', 'greenProduct', 
            'strategyDetail', 'syncBlue', 'fromBaseColor'
        )
        
        foreach ($gradient in $gradients) {
            # Padrão: gradient: AppGradients.nome, -> gradient: AppGradients.nome(context),
            $pattern = "gradient:\s*AppGradients\.$gradient,"
            $replacement = "gradient: AppGradients.$gradient(context),"
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $replacement
                $count = ([regex]::Matches($originalContent, $pattern)).Count
                $fileReplacements += $count
                Write-Host "      ✅ $gradient, -> $gradient(context),: $count" -ForegroundColor Green
            }
            
            # Padrão para condicionais: ? AppGradients.nome : -> ? AppGradients.nome(context) :
            $pattern = "\?\s*AppGradients\.$gradient\s*:"
            $replacement = "? AppGradients.$gradient(context) :"
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $replacement
                $count = ([regex]::Matches($originalContent, $pattern)).Count
                $fileReplacements += $count
                Write-Host "      ✅ ? $gradient : -> ? $gradient(context) :: $count" -ForegroundColor Green
            }
            
            # Padrão para condicionais: : AppGradients.nome, -> : AppGradients.nome(context),
            $pattern = ":\s*AppGradients\.$gradient,"
            $replacement = ": AppGradients.$gradient(context),"
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $replacement
                $count = ([regex]::Matches($originalContent, $pattern)).Count
                $fileReplacements += $count
                Write-Host "      ✅ : $gradient, -> : $gradient(context),: $count" -ForegroundColor Green
            }
        }
        
        # ========== MÓDULOS GRADIENTES ==========
        $moduleGradients = @('produtos', 'precificacao')
        
        foreach ($gradient in $moduleGradients) {
            # Padrão: gradient: ModuleGradients.nome, -> gradient: ModuleGradients.nome(context),
            $pattern = "gradient:\s*ModuleGradients\.$gradient,"
            $replacement = "gradient: ModuleGradients.$gradient(context),"
            if ($content -match $pattern) {
                $content = $content -replace $pattern, $replacement
                $count = ([regex]::Matches($originalContent, $pattern)).Count
                $fileReplacements += $count
                Write-Host "      ✅ ModuleGradients.$gradient, -> ModuleGradients.$gradient(context),: $count" -ForegroundColor Green
            }
        }
        
        # ========== SALVAR ARQUIVO SE HOUVE MUDANÇAS ==========
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            $totalFiles++
            $totalReplacements += $fileReplacements
            Write-Host "   💾 Arquivo salvo com $fileReplacements correções!" -ForegroundColor Green
        }
        else {
            Write-Host "   ⏭️  Nenhuma correção necessária" -ForegroundColor Gray
        }
    }
    catch {
        Write-Host "   ❌ ERRO: $($_.Exception.Message)" -ForegroundColor Red
        $errorFiles += $file.FullName
    }
}

# ========== RESULTADO FINAL ==========
Write-Host "`n" + "="*60 -ForegroundColor Green
Write-Host "🎉 SCRIPT CONCLUÍDO!" -ForegroundColor Green
Write-Host "📊 Arquivos processados: $($dartFiles.Count)" -ForegroundColor Yellow
Write-Host "📝 Arquivos modificados: $totalFiles" -ForegroundColor Yellow
Write-Host "🔄 Total de correções: $totalReplacements" -ForegroundColor Yellow

if ($errorFiles.Count -gt 0) {
    Write-Host "❌ Arquivos com erro: $($errorFiles.Count)" -ForegroundColor Red
    foreach ($errorFile in $errorFiles) {
        Write-Host "   - $errorFile" -ForegroundColor Red
    }
}

Write-Host "="*60 -ForegroundColor Green