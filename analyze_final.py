#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import json
from collections import defaultdict

# Ler arquivo
with open('d:\\tagbean\\frontend\\analyze_output.txt', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

issues = []

# Padrão: espaços + (error|warning|info) + '-' + mensagem + ' - ' + caminho:linha:coluna + ' - ' + código
# A mensagem pode conter hífens, mas não termina com " - " que precede o caminho
# O caminho termina com .dart:número:número

pattern = r'^\s+(error|warning|info)\s+-\s+(.+?)\s+-\s+(lib\\.+?\.dart):(\d+):(\d+)\s+-\s+(\S+)\s*$'

for line in content.split('\n'):
    match = re.match(pattern, line)
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

print(f"Total issues encontrados: {len(issues)}")

# Análise por tipo
error_count = sum(1 for issue in issues if issue['severity'] == 'error')
warning_count = sum(1 for issue in issues if issue['severity'] == 'warning')
info_count = sum(1 for issue in issues if issue['severity'] == 'info')
total = len(issues)

print(f"Errors: {error_count}, Warnings: {warning_count}, Infos: {info_count}")

if total == 0:
    print("Nenhum issue encontrado! Saindo...")
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
    print(f"{idx}. {arquivo}: {len(file_issues)} issues (🔴{errors} 🟡{warnings} 🔵{infos})")

# Padrões de erro mais comuns
error_patterns = defaultdict(int)
for issue in issues:
    error_patterns[issue['code']] += 1

top_patterns = sorted(error_patterns.items(), key=lambda x: x[1], reverse=True)

print("\n🔴 TOP 15 PADRÕES DE ERRO/WARNING:")
for idx, (padrao, count) in enumerate(top_patterns[:15], 1):
    percentual = (count / total * 100)
    print(f"{idx}. {padrao}: {count} ({percentual:.1f}%)")

# Diretórios com mais issues
dir_issues = defaultdict(int)
for filepath, file_issues_list in files_issues.items():
    parts = filepath.split('/')
    if len(parts) > 2:
        if 'features' in parts:
            idx = parts.index('features')
            if idx + 1 < len(parts):
                dir_key = f"features/{parts[idx+1]}"
            else:
                dir_key = 'features'
        elif 'modules' in parts:
            idx = parts.index('modules')
            if idx + 1 < len(parts):
                dir_key = f"modules/{parts[idx+1]}"
            else:
                dir_key = 'modules'
        elif 'shared' in parts:
            dir_key = 'shared'
        else:
            dir_key = parts[1]
    else:
        dir_key = 'root'
    
    dir_issues[dir_key] += len(file_issues_list)

top_dirs = sorted(dir_issues.items(), key=lambda x: x[1], reverse=True)

print("\n📁 DIRETÓRIOS COM MAIS ISSUES:")
for idx, (diretorio, count) in enumerate(top_dirs[:10], 1):
    percentual = (count / total * 100)
    print(f"{idx}. {diretorio}: {count} ({percentual:.1f}%)")

# Agrupar problemas por tipo de mensagem
pattern_severities = defaultdict(lambda: {'error': 0, 'warning': 0, 'info': 0})
for issue in issues:
    pattern_severities[issue['code']][issue['severity']] += 1

# Criar relatório
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
            'arquivo': arquivo,
            'totalIssues': len(file_issues),
            'distribuicao': {
                'errors': sum(1 for i in file_issues if i['severity'] == 'error'),
                'warnings': sum(1 for i in file_issues if i['severity'] == 'warning'),
                'infos': sum(1 for i in file_issues if i['severity'] == 'info')
            },
            'top3Codigos': [
                (code, sum(1 for i in file_issues if i['code'] == code))
                for code in list(dict.fromkeys([i['code'] for i in file_issues]))[:3]
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
            }
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
        f"🔴 CRÍTICO: {error_count} erros que impedem compilação ({(error_count/total*100):.1f}% do total)",
        f"🟡 MEDIUM: {warning_count} warnings afetando qualidade ({(warning_count/total*100):.1f}%)",
        f"🔵 LOW: {info_count} infos sobre deprecações e boas práticas ({(info_count/total*100):.1f}%)",
        "",
        "📊 CONCENTRAÇÃO DE PROBLEMAS:",
        f"  • Maior concentração: {top_dirs[0][0]} com {top_dirs[0][1]} issues",
        f"  • Segundo lugar: {top_dirs[1][0]} com {top_dirs[1][1]} issues",
        f"  • Problema principal: '{top_patterns[0][0]}' com {top_patterns[0][1]} ocorrências",
        "",
        "⚡ AÇÕES IMEDIATAS (Ordem de Prioridade):",
        "  1. TIPAGEM: 'argument_type_not_assignable' - Revisar tipo 'dynamic' nos modelos",
        "  2. UNDEFINED: Resolver 'undefined_identifier' e 'undefined_method' em widgets",
        "  3. ENCODING: Corrigir caracteres especiais em nomes de variáveis",
        "  4. CONST: Implementar const constructor safety",
        "",
        "🎯 MELHORIAS A LONGO PRAZO:",
        "  • Implementar type-safe Riverpod/Provider em vez de dynamic",
        "  • Adicionar regras de linting strict no analysis_options.yaml",
        "  • Revisar estrutura de imports e dependências circulares",
        "  • Implementar testes unitários para validação de tipos",
        "  • Refatorar models para usar generated_code (freezed/json_serializable)"
    ]
}

# Salvar relatório
with open('d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json', 'w', encoding='utf-8') as f:
    json.dump(report, f, ensure_ascii=False, indent=2)

print("\n" + "="*80)
print("✅ Relatório COMPLETO salvo em:")
print("📄 d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json")
print("="*80)

# Exibir relatório
print(json.dumps(report, ensure_ascii=False, indent=2))
