#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import re
import json
from collections import defaultdict
from pathlib import Path

# Ler arquivo
with open('d:\\tagbean\\frontend\\analyze_output.txt', 'r', encoding='utf-8', errors='ignore') as f:
    lines = f.readlines()

# Padrão para extrair informações
# Formato: "  error - Message - file\path.dart:line:col - error_code"
pattern = r'^\s+(error|warning|info)\s+-\s+(.+?)\s+-\s+(.+?):(\d+):(\d+)\s+-\s+(\S+)$'

issues = []
for line in lines:
    match = re.match(pattern, line)
    if match:
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

top_patterns = sorted(error_patterns.items(), key=lambda x: x[1], reverse=True)[:10]

# Diretórios com mais issues
dir_issues = defaultdict(int)
for filepath, file_issues in files_issues.items():
    # Extrair diretório (features ou modules)
    parts = filepath.split('\\')
    if len(parts) > 1 and parts[0] in ['lib']:
        if len(parts) > 2 and parts[1] in ['features', 'modules']:
            dir_key = parts[1] + '/' + (parts[2] if len(parts) > 2 else 'root')
        else:
            dir_key = parts[1]
        dir_issues[dir_key] += len(file_issues)

top_dirs = sorted(dir_issues.items(), key=lambda x: x[1], reverse=True)

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
            'count': len(file_issues),
            'tiposPrincipais': [
                {'tipo': issue['code'], 'count': sum(1 for i in file_issues if i['code'] == issue['code'])}
                for issue in file_issues
            ][:5],
            'severidades': {
                'errors': sum(1 for i in file_issues if i['severity'] == 'error'),
                'warnings': sum(1 for i in file_issues if i['severity'] == 'warning'),
                'infos': sum(1 for i in file_issues if i['severity'] == 'info')
            }
        }
        for arquivo, file_issues in top_files
    ],
    'padroesMaisComuns': [
        {
            'padrao': padrao,
            'count': count,
            'percentual': f"{(count/total*100):.1f}%",
            'severidade': next((issue['severity'] for issue in issues if issue['code'] == padrao), 'desconhecida')
        }
        for padrao, count in top_patterns
    ],
    'diretoriosComMaisIssues': [
        {'diretorio': diretorio, 'count': count}
        for diretorio, count in top_dirs[:20]
    ],
    'recomendacoes': [
        f"🔴 Prioridade Alta: Resolver {error_count} erros críticos que impedem compilação",
        f"🟡 Prioridade Média: Revisar {warning_count} warnings para melhorar qualidade do código",
        f"🔵 Prioridade Baixa: Considerar {info_count} infos de deprecação e boas práticas",
        "⚠️ Arquivo crítico: lib\\modules\\products\\presentation\\screens\\products_list_screen.dart com mais de 50 issues",
        "⚠️ Padrão crítico: 'argument_type_not_assignable' é o erro mais comum - revisar tipagem de dados",
        "⚠️ Encoding: Há problemas com caracteres especiais em nomes de variáveis (estrat├®giasData)",
        "🎯 Recomendação: Implementar type safety com Riverpod/Provider para reduzir 'dynamic' types"
    ]
}

# Salvar relatório
with open('d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json', 'w', encoding='utf-8') as f:
    json.dump(report, f, ensure_ascii=False, indent=2)

print(json.dumps(report, ensure_ascii=False, indent=2))
print(f"\n✅ Relatório salvo em: d:\\tagbean\\frontend\\RELATORIO_ISSUES_DETALHADO.json")
