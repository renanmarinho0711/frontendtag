#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import json
from collections import defaultdict

# Ler arquivo
with open('d:\\tagbean\\frontend\\analyze_output.txt', 'r', encoding='utf-8', errors='ignore') as f:
    content = f.read()

# Padrão alternativo - mais flexível
# Formatos possíveis:
# "  error - Message - file\path.dart:line:col - error_code"
# "error - Message - file\path.dart:line:col - error_code"

issues = []

# Procurar todas as linhas com error/warning/info
for match in re.finditer(r'(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\S+)', content):
    severity, message, filepath, line_num, col, code = match.groups()
    issues.append({
        'severity': severity,
        'message': message.strip(),
        'file': filepath.strip(),
        'line': int(line_num),
        'col': int(col),
        'code': code.strip()
    })

# Análise por tipo
error_count = sum(1 for issue in issues if issue['severity'] == 'error')
warning_count = sum(1 for issue in issues if issue['severity'] == 'warning')
info_count = sum(1 for issue in issues if issue['severity'] == 'info')
total = len(issues)

print(f"Total issues encontrados: {total}")
print(f"Errors: {error_count}, Warnings: {warning_count}, Infos: {info_count}")

# Agrupar por arquivo
files_issues = defaultdict(list)
for issue in issues:
    files_issues[issue['file']].append(issue)

# Top 15 arquivos
top_files = sorted(files_issues.items(), key=lambda x: len(x[1]), reverse=True)[:15]

# Padrões de erro mais comuns
error_patterns = defaultdict(int)
for issue in issues:
    error_patterns[issue['code']] += 1

top_patterns = sorted(error_patterns.items(), key=lambda x: x[1], reverse=True)

# Diretórios com mais issues
dir_issues = defaultdict(int)
for filepath, file_issues in files_issues.items():
    # Extrair diretório feature/module
    parts = filepath.replace('\\', '/').split('/')
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
        elif 'design_system' in parts:
            dir_key = 'design_system'
        elif 'core' in parts:
            dir_key = 'core'
        elif 'app' in parts:
            dir_key = 'app'
        else:
            dir_key = parts[1] if len(parts) > 1 else 'root'
    else:
        dir_key = 'root'
    
    dir_issues[dir_key] += len(file_issues)

top_dirs = sorted(dir_issues.items(), key=lambda x: x[1], reverse=True)

# Agrupar problemas por tipo de mensagem (padrão)
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
        'percentualErrors': f"{(error_count/total*100):.1f}%" if total > 0 else "0%",
        'percentualWarnings': f"{(warning_count/total*100):.1f}%" if total > 0 else "0%",
        'percentualInfo': f"{(info_count/total*100):.1f}%" if total > 0 else "0%"
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
            'codigosMaisFrequentes': [
                {'codigo': issue['code'], 'ocorrencias': sum(1 for i in file_issues if i['code'] == issue['code'])}
                for issue in file_issues
            ][:5]
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
        {'diretorio': diretorio, 'totalIssues': count}
        for diretorio, count in top_dirs
    ],
    'recomendacoes': [
        f"🔴 CRÍTICO: {error_count} erros que impedem compilação (atual: {error_count/total*100:.1f}% de {total})",
        f"🟡 MEDIUM: {warning_count} warnings afetando qualidade ({warning_count/total*100:.1f}%)",
        f"🔵 LOW: {info_count} infos sobre deprecações e boas práticas ({info_count/total*100:.1f}%)",
        "",
        "📊 ANÁLISE POR ÁREA:",
        f"  • Maior concentração: features/products com ~{dict(top_dirs).get('features/products', 0)} issues",
        f"  • Problema principal: '{top_patterns[0][0]}' com {top_patterns[0][1]} ocorrências",
        "",
        "⚡ AÇÕES IMEDIATAS:",
        "  1. Revisar tipagem de dados nos modelos (argument_type_not_assignable)",
        "  2. Corrigir encoding de variáveis (caracteres especiais em nomes)",
        "  3. Implementar const constructor safety (const_eval_method_invocation)",
        "  4. Resolver undefined identifiers em widgets (context, menu items)",
        "",
        "🎯 MELHORES PRÁTICAS:",
        "  • Usar type-safe Riverpod/Provider em vez de dynamic",
        "  • Adicionar strict linting rules ao analysis_options.yaml",
        "  • Implementar testes automáticos para type checking",
        "  • Revisar imports circulares e ordenação"
    ]
}

# Salvar relatório
with open('d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json', 'w', encoding='utf-8') as f:
    json.dump(report, f, ensure_ascii=False, indent=2)

print(json.dumps(report, ensure_ascii=False, indent=2))
print(f"\n✅ Relatório salvo em: d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json")
