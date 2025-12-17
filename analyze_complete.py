#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import json
from collections import defaultdict

# Ler arquivo com encoding UTF-16
with open('d:\\tagbean\\frontend\\analyze_output.txt', 'r', encoding='utf-16', errors='ignore') as f:
    content = f.read()

issues = []

# Padrão: espaços + (error|warning|info) + '-' + mensagem + ' - ' + caminho + ':' + linha + ':' + coluna + ' - ' + código
# Mais permissivo já que há quebras de linha
pattern = r'^\s+(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?\.dart):(\d+):(\d+)\s+-\s+(.+)$'

for line in content.split('\n'):
    match = re.match(pattern, line.strip())
    if match:
        severity, message, filepath, line_num, col, code = match.groups()
        issues.append({
            'severity': severity,
            'message': message.strip(),
            'file': filepath.strip().replace('\\', '/'),
            'line': int(line_num),
            'col': int(col),
            'code': code.strip()
        })

print(f"✅ Total issues encontrados: {len(issues)}")

# Análise por tipo
error_count = sum(1 for issue in issues if issue['severity'] == 'error')
warning_count = sum(1 for issue in issues if issue['severity'] == 'warning')
info_count = sum(1 for issue in issues if issue['severity'] == 'info')
total = len(issues)

print(f"🔴 Errors: {error_count} | 🟡 Warnings: {warning_count} | 🔵 Infos: {info_count}")

if total == 0:
    print("❌ Nenhum issue encontrado! Saindo...")
    exit(1)

# Agrupar por arquivo
files_issues = defaultdict(list)
for issue in issues:
    files_issues[issue['file']].append(issue)

# Top 15 arquivos
top_files = sorted(files_issues.items(), key=lambda x: len(x[1]), reverse=True)[:15]

print("\n🔝 TOP 15 ARQUIVOS COM MAIS ISSUES:")
for idx, (arquivo, file_issues) in enumerate(top_files, 1):
    errors = sum(1 for i in file_issues if i['severity'] == 'error')
    warnings = sum(1 for i in file_issues if i['severity'] == 'warning')
    infos = sum(1 for i in file_issues if i['severity'] == 'info')
    print(f"{idx:2}. [{len(file_issues):3} issues] 🔴{errors:2} 🟡{warnings:2} 🔵{infos:3} - {arquivo[-70:]}")

# Padrões de erro mais comuns
error_patterns = defaultdict(int)
for issue in issues:
    error_patterns[issue['code']] += 1

top_patterns = sorted(error_patterns.items(), key=lambda x: x[1], reverse=True)

print("\n🔴 TOP 15 PADRÕES MAIS FREQUENTES:")
for idx, (padrao, count) in enumerate(top_patterns[:15], 1):
    percentual = (count / total * 100)
    print(f"{idx:2}. [{count:4}] {percentual:5.1f}% - {padrao}")

# Diretórios com mais issues
dir_issues = defaultdict(int)
for filepath, file_issues_list in files_issues.items():
    parts = filepath.split('/')
    if len(parts) >= 3 and parts[0] == 'lib':
        if parts[1] in ['features', 'modules']:
            dir_key = f"{parts[1]}/{parts[2]}"
        else:
            dir_key = parts[1]
    else:
        dir_key = 'root'
    
    dir_issues[dir_key] += len(file_issues_list)

top_dirs = sorted(dir_issues.items(), key=lambda x: x[1], reverse=True)

print("\n📁 DIRETÓRIOS COM MAIS ISSUES:")
for idx, (diretorio, count) in enumerate(top_dirs[:10], 1):
    percentual = (count / total * 100)
    print(f"{idx:2}. [{count:4}] {percentual:5.1f}% - {diretorio}")

# Agrupar problemas por severidade e tipo
pattern_severities = defaultdict(lambda: {'error': 0, 'warning': 0, 'info': 0})
for issue in issues:
    pattern_severities[issue['code']][issue['severity']] += 1

# Criar relatório estruturado
report = {
    'resumoGeral': {
        'totalIssues': total,
        'errors': error_count,
        'warnings': warning_count,
        'info': info_count,
        'percentualErrors': f"{(error_count/total*100):.1f}%",
        'percentualWarnings': f"{(warning_count/total*100):.1f}%",
        'percentualInfo': f"{(info_count/total*100):.1f}%"
    },
    'top15ArquivosComIssues': [
        {
            'arquivo': arquivo.replace('lib/', ''),
            'totalIssues': len(file_issues),
            'distribuicao': {
                'errors': sum(1 for i in file_issues if i['severity'] == 'error'),
                'warnings': sum(1 for i in file_issues if i['severity'] == 'warning'),
                'infos': sum(1 for i in file_issues if i['severity'] == 'info')
            },
            'topCodigos': [
                {'codigo': code, 'ocorrencias': sum(1 for i in file_issues if i['code'] == code)}
                for code in sorted(set(i['code'] for i in file_issues), 
                                 key=lambda c: sum(1 for i in file_issues if i['code'] == c), reverse=True)[:5]
            ]
        }
        for arquivo, file_issues in top_files
    ],
    'padroesMaisComuns': [
        {
            'padrao': padrao,
            'totalOcorrencias': count,
            'percentual': f"{(count/total*100):.1f}%",
            'distribuicao': {
                'errors': pattern_severities[padrao]['error'],
                'warnings': pattern_severities[padrao]['warning'],
                'infos': pattern_severities[padrao]['info']
            },
            'exemplo': next(('| ' + i['file'].replace('lib/', '') + ':' + str(i['line']) + ' | ' + i['message'][:80]) 
                          for i in issues if i['code'] == padrao)
        }
        for padrao, count in top_patterns[:15]
    ],
    'diretoriosComMaisIssues': [
        {
            'diretorio': diretorio,
            'totalIssues': count,
            'percentual': f"{(count/total*100):.1f}%"
        }
        for diretorio, count in top_dirs
    ],
    'recomendacoes': [
        f"🔴 CRÍTICO: {error_count} erros que impedem compilação ({(error_count/total*100):.1f}% do total de {total} issues)",
        f"🟡 MEDIUM: {warning_count} warnings afetando qualidade do código ({(warning_count/total*100):.1f}%)",
        f"🔵 LOW: {info_count} infos sobre deprecações e boas práticas ({(info_count/total*100):.1f}%)",
        "",
        "📊 DISTRIBUIÇÃO GEOGRÁFICA:",
        f"  • Maior concentração: {top_dirs[0][0]} com {top_dirs[0][1]} issues ({(top_dirs[0][1]/total*100):.1f}%)",
        f"  • Segundo lugar: {top_dirs[1][0]} com {top_dirs[1][1]} issues ({(top_dirs[1][1]/total*100):.1f}%)",
        f"  • Terceiro lugar: {top_dirs[2][0]} com {top_dirs[2][1]} issues ({(top_dirs[2][1]/total*100):.1f}%)",
        "",
        "⚡ PADRÕES CRÍTICOS (Top 3):",
        f"  1. '{top_patterns[0][0]}' ({top_patterns[0][1]} ocorrências, {(top_patterns[0][1]/total*100):.1f}%)",
        f"  2. '{top_patterns[1][0]}' ({top_patterns[1][1]} ocorrências, {(top_patterns[1][1]/total*100):.1f}%)",
        f"  3. '{top_patterns[2][0]}' ({top_patterns[2][1]} ocorrências, {(top_patterns[2][1]/total*100):.1f}%)",
        "",
        "🎯 AÇÕES IMEDIATAS (Prioridade):",
        "  1. TIPAGEM: Revisar 'argument_type_not_assignable' - converter 'dynamic' em tipos específicos",
        "  2. UNDEFINED: Resolver 'undefined_identifier' em widgets (context, menu, properties)",
        "  3. ENCODING: Corrigir caracteres especiais em nomes de variáveis",
        "  4. CONST: Implementar const constructor safety (const_eval_method_invocation)",
        "  5. IMPORTS: Resolver undefined_method e circular dependencies",
        "",
        "📈 MELHORIAS A LONGO PRAZO:",
        "  • Implementar Riverpod/Provider com type-safety em vez de dynamic",
        "  • Adicionar strict linting rules no analysis_options.yaml",
        "  • Refatorar models com freezed/json_serializable (code generation)",
        "  • Implementar testes unitários para validação de tipos",
        "  • Revisar estrutura de arquitetura (Clean Architecture + BLoC/Riverpod)",
        "  • Adicionar CI/CD pipeline com análise obrigatória antes de merge"
    ]
}

# Salvar relatório em JSON
with open('d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json', 'w', encoding='utf-8') as f:
    json.dump(report, f, ensure_ascii=False, indent=2)

# Também salvar em formato markdown para melhor visualização
md_content = f"""# 📊 Relatório Detalhado de Issues - Flutter Project

**Data**: 2025-12-17  
**Projeto**: TagBean Frontend  
**Total de Issues**: {total}

## 📈 Resumo Geral

| Métrica | Valor | Percentual |
|---------|-------|-----------|
| **Total de Issues** | {total} | 100% |
| **Erros** | {error_count} | {(error_count/total*100):.1f}% |
| **Warnings** | {warning_count} | {(warning_count/total*100):.1f}% |
| **Infos** | {info_count} | {(info_count/total*100):.1f}% |

## 🔝 Top 15 Arquivos com Mais Issues

"""

for idx, (arquivo, file_issues) in enumerate(top_files, 1):
    errors = sum(1 for i in file_issues if i['severity'] == 'error')
    warnings = sum(1 for i in file_issues if i['severity'] == 'warning')
    infos = sum(1 for i in file_issues if i['severity'] == 'info')
    md_content += f"{idx}. **{arquivo.replace('lib/', '')}** - {len(file_issues)} issues\n"
    md_content += f"   - 🔴 Errors: {errors} | 🟡 Warnings: {warnings} | 🔵 Infos: {infos}\n"

md_content += f"\n## 🔴 Top Padrões Mais Frequentes\n\n"

for idx, (padrao, count) in enumerate(top_patterns[:10], 1):
    percentual = (count / total * 100)
    md_content += f"{idx}. **{padrao}** - {count} ocorrências ({percentual:.1f}%)\n"

md_content += f"\n## 📁 Distribuição por Diretório\n\n"

for idx, (diretorio, count) in enumerate(top_dirs[:10], 1):
    percentual = (count / total * 100)
    bar = "█" * int(percentual / 5)
    md_content += f"{idx}. `{diretorio}` - {count} issues ({percentual:.1f}%) {bar}\n"

md_content += f"""
## 🎯 Recomendações

### Ações Imediatas (Críticas)

1. **Tipagem de Dados**: Resolver {top_patterns[0][1]} casos de `{top_patterns[0][0]}`
   - Converter tipos `dynamic` em tipos específicos
   - Revisar parsing JSON em models

2. **Identificadores Indefinidos**: Revisar references em widgets
   - Verificar imports e namespace
   - Implementar late initialization onde necessário

3. **Encoding**: Corrigir caracteres especiais
   - UTF-8 em nomes de variáveis
   - Renovar análise de encoding

### Melhorias a Longo Prazo

- Implementar Riverpod/Provider type-safe
- Adicionar strict linting rules
- Refatorar com code generation (freezed)
- Implementar testes unitários
- Revisar arquitetura Clean Architecture

---
*Relatório gerado em: 2025-12-17*
"""

with open('d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.md', 'w', encoding='utf-8') as f:
    f.write(md_content)

print("\n" + "="*80)
print("✅ RELATÓRIOS SALVOS COM SUCESSO:")
print("  📄 JSON: d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json")
print("  📝 MD:   d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.md")
print("="*80)

# Exibir resumo final
print(f"\n📊 RESUMO FINAL:")
print(json.dumps(report, ensure_ascii=False, indent=2))
