#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys
from datetime import datetime

def create_mapping():
    """Cria mapeamento de correções básicas de encoding"""
    return {
        # Caracteres corrompidos por double-encoding (estes são sempre seguros)
        'Ã£': 'ã',
        'Ã¡': 'á', 
        'Ã©': 'é',
        'Ãª': 'ê',
        'Ã­': 'í',
        'Ã³': 'ó',
        'Ãµ': 'õ',
        'Ãº': 'ú',
        'Ã§': 'ç',
        'Ã¢': 'â',
        'Ã´': 'ô',
        'Ã¬': 'ì',
        'Ã¨': 'è',
        'Ã¹': 'ù',
        'Ã ': 'à',
        'Ã‡': 'Ç',
        'Ã': 'À',
        'Ã‰': 'É',
        'Ãˆ': 'È',
    }

def create_risky_words():
    """Palavras que podem ser perigosas mesmo em strings"""
    return {
        # PALAVRAS COM PROBLEMAS DE ENCODING REAL
        'Usuarios': 'Usuários',    # Falta acento - real  
        'Usuario': 'Usuário',      # Falta acento - real
        'Integrao': 'Integração',  # Falta ç - real
        'Integracao': 'Integração', # Falta ç - real
        'Notificaes': 'Notificações', # Falta ç - real
        'Notificacoes': 'Notificações', # Falta ç - real
        'Segurana': 'Segurança',   # Falta ç - real
        'Seguranca': 'Segurança',  # Falta ç - real
        'Permissoes': 'Permissões', # Falta õ - real
        'Importacao': 'Importação', # Falta ç - real
        'Exportacao': 'Exportação', # Falta ç - real
        'Sincronizacao': 'Sincronização', # Falta ç - real
        'Precificacao': 'Precificação', # Falta ç - real
        'Configuracoes': 'Configurações', # Falta ç e õ - real
        'Estrategias': 'Estratégias', # Falta é - real
        'estrategias': 'estratégias', # Falta é - real
        'integrao': 'integração',  # Falta ç - real
        'promocoes': 'promoções',   # Falta ç - real
        'promocao': 'promoção',     # Falta ç - real
        'configuracao': 'configuração', # Falta ç - real
        'sincronizacao': 'sincronização', # Falta ç - real
        'operacao': 'operação',     # Falta ç - real
        'operacoes': 'operações',   # Falta ç e õ - real
        'relatorio': 'relatório',   # Falta ó - real
        'relatorios': 'relatórios', # Falta ó - real
        'Relatorio': 'Relatório',   # Falta ó - real
        'Relatorios': 'Relatórios', # Falta ó - real
        'versao': 'versão',         # Falta ã - real
        'versoes': 'versões',       # Falta õ - real
        'Versao': 'Versão',         # Falta ã - real
        'Versoes': 'Versões',       # Falta õ - real
        'codigo': 'código',         # Falta ó - PERIGOSO!
        'usuario': 'usuário',       # Falta á - PERIGOSO!
        
        # PROBLEMAS ESPECÍFICOS ENCONTRADOS
        'ativacao': 'ativação',     # Falta ç - real
        'Ativacao': 'Ativação',     # Falta ç - real
    }

def is_in_safe_context(line, match_start):
    """Verifica se a mudança está em um contexto seguro"""
    line_before_match = line[:match_start]
    
    # Verifica se está em string com aspas simples
    single_quotes = line_before_match.count("'") - line_before_match.count("\\'")
    if single_quotes % 2 == 1:
        return True, "STRING_SIMPLES"
    
    # Verifica se está em string com aspas duplas  
    double_quotes = line_before_match.count('"') - line_before_match.count('\\"')
    if double_quotes % 2 == 1:
        return True, "STRING_DUPLAS"
    
    # Verifica se está em comentário de linha
    if '//' in line_before_match:
        return True, "COMENTARIO_LINHA"
    
    # Verifica se está em comentário de documentação
    stripped = line.strip()
    if stripped.startswith('///'):
        return True, "COMENTARIO_DOC"
    
    return False, "CODIGO"

def analyze_line_safety(word, line_content):
    """Analisa se uma palavra na linha é perigosa"""
    
    # Ignora se não há mudança real
    word_mapping = create_risky_words()
    if word not in word_mapping:
        return "IGNORAR"
    
    new_word = word_mapping[word]
    if word == new_word:  # Não há mudança real
        return "IGNORAR"
    
    # Palavras sempre perigosas em código
    super_dangerous = ['codigo', 'usuario']
    
    if word.lower() in super_dangerous:
        # Padrões muito perigosos
        if any(pattern in line_content for pattern in ['.', 'get', 'set', '${', '$', '(', ')', '=', ':', ';']):
            return "MUITO_PERIGOSO"
        if 'case ' in line_content or 'class ' in line_content or 'final ' in line_content:
            return "MUITO_PERIGOSO"
        return "PERIGOSO"
    
    # Outras palavras - análise mais suave
    moderately_dangerous = ['promocao', 'promocoes', 'relatorio', 'relatorios', 'configuracao']
    
    if word.lower() in moderately_dangerous:
        if '.' in line_content and ('get' in line_content.lower() or 'set' in line_content.lower()):
            return "PERIGOSO"
        if '${' in line_content:
            return "PERIGOSO"
        if 'case ' in line_content:
            return "PERIGOSO"
    
    return "SEGURO"

def analyze_file_detailed(file_path):
    """Analisa um arquivo e retorna relatório detalhado"""
    try:
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            lines = f.readlines()
    except Exception as e:
        return None, f"Erro ao ler arquivo: {e}"
    
    file_report = {
        'path': file_path,
        'total_lines': len(lines),
        'char_fixes': [],
        'safe_word_fixes': [],
        'risky_word_fixes': []
    }
    
    char_mapping = create_mapping()
    word_mapping = create_risky_words()
    
    for line_num, line in enumerate(lines, 1):
        line_clean = line.rstrip('\n\r')
        
        # 1. Analisa caracteres corrompidos
        for old_char, new_char in char_mapping.items():
            if old_char in line_clean:
                start = 0
                while True:
                    pos = line_clean.find(old_char, start)
                    if pos == -1:
                        break
                    
                    is_safe, context = is_in_safe_context(line_clean, pos)
                    if is_safe:
                        fix_entry = {
                            'line_num': line_num,
                            'old_text': old_char,
                            'new_text': new_char,
                            'context_type': context,
                            'full_line': line_clean,
                            'position': pos
                        }
                        file_report['char_fixes'].append(fix_entry)
                    
                    start = pos + 1
        
        # 2. Analisa palavras
        for old_word, new_word in word_mapping.items():
            if old_word in line_clean:
                start = 0
                while True:
                    pos = line_clean.find(old_word, start)
                    if pos == -1:
                        break
                    
                    is_safe_context, context = is_in_safe_context(line_clean, pos)
                    
                    if is_safe_context:
                        safety_analysis = analyze_line_safety(old_word, line_clean)
                        
                        # Ignora mapeamentos que não fazem mudança real
                        if safety_analysis == "IGNORAR":
                            start = pos + 1
                            continue
                        
                        fix_entry = {
                            'line_num': line_num,
                            'old_text': old_word,
                            'new_text': new_word,
                            'context_type': context,
                            'safety_analysis': safety_analysis,
                            'full_line': line_clean,
                            'position': pos
                        }
                        
                        if safety_analysis == "SEGURO":
                            file_report['safe_word_fixes'].append(fix_entry)
                        else:
                            file_report['risky_word_fixes'].append(fix_entry)
                    
                    start = pos + 1
    
    return file_report, None

def generate_detailed_report(all_reports):
    """Gera relatório HTML detalhado"""
    now = datetime.now()
    
    html = f"""<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relatório de Correções de Encoding - TagBean</title>
    <style>
        body {{ font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 20px; background: #f5f5f5; }}
        .container {{ max-width: 1200px; margin: 0 auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
        .header {{ background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; margin-bottom: 20px; }}
        .summary {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; margin-bottom: 30px; }}
        .stat {{ background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; border-left: 4px solid #007bff; }}
        .stat-dangerous {{ border-left-color: #dc3545; }}
        .stat-safe {{ border-left-color: #28a745; }}
        .file-section {{ margin-bottom: 30px; border: 1px solid #ddd; border-radius: 8px; }}
        .file-header {{ background: #f8f9fa; padding: 15px; border-bottom: 1px solid #ddd; font-weight: bold; }}
        .fix-item {{ padding: 10px 15px; border-bottom: 1px solid #eee; }}
        .fix-item:last-child {{ border-bottom: none; }}
        .line-number {{ display: inline-block; background: #007bff; color: white; padding: 2px 8px; border-radius: 4px; margin-right: 10px; font-size: 0.9em; }}
        .change {{ background: #fff3cd; padding: 2px 6px; border-radius: 4px; margin: 0 5px; }}
        .old-text {{ background: #f8d7da; color: #721c24; }}
        .new-text {{ background: #d4edda; color: #155724; }}
        .full-line {{ margin-top: 8px; padding: 8px; background: #f8f9fa; border-radius: 4px; font-family: 'Courier New', monospace; font-size: 0.9em; white-space: pre-wrap; }}
        .context-type {{ display: inline-block; background: #17a2b8; color: white; padding: 1px 6px; border-radius: 3px; font-size: 0.8em; margin-left: 10px; }}
        .safety-analysis {{ display: inline-block; padding: 1px 6px; border-radius: 3px; font-size: 0.8em; margin-left: 10px; }}
        .seguro {{ background: #28a745; color: white; }}
        .perigoso {{ background: #dc3545; color: white; }}
        .dangerous-section {{ background: #fff5f5; border-left: 4px solid #dc3545; }}
        .safe-section {{ background: #f0fff4; border-left: 4px solid #28a745; }}
        .char-section {{ background: #e8f4f8; border-left: 4px solid #17a2b8; }}
        h1, h2, h3 {{ color: #333; }}
        .toc {{ background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; }}
        .toc ul {{ list-style: none; padding-left: 0; }}
        .toc li {{ margin: 5px 0; }}
        .toc a {{ text-decoration: none; color: #007bff; }}
        .toc a:hover {{ text-decoration: underline; }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Relatório de Correções de Encoding - TagBean Frontend</h1>
            <p>Gerado em: {now.strftime('%d/%m/%Y às %H:%M:%S')}</p>
        </div>
"""
    
    # Conta totais
    total_files = len([r for r in all_reports if r])
    total_char_fixes = sum(len(r['char_fixes']) for r in all_reports if r)
    total_safe_word_fixes = sum(len(r['safe_word_fixes']) for r in all_reports if r)
    total_risky_word_fixes = sum(len(r['risky_word_fixes']) for r in all_reports if r)
    
    files_with_char_fixes = len([r for r in all_reports if r and r['char_fixes']])
    files_with_safe_fixes = len([r for r in all_reports if r and r['safe_word_fixes']])
    files_with_risky_fixes = len([r for r in all_reports if r and r['risky_word_fixes']])
    
    # Resumo executivo
    html += f"""
        <div class="summary">
            <div class="stat">
                <h3>{total_files}</h3>
                <p>Arquivos Analisados</p>
            </div>
            <div class="stat stat-safe">
                <h3>{total_char_fixes}</h3>
                <p>Correções de Caracteres (100% Seguras)</p>
            </div>
            <div class="stat stat-safe">
                <h3>{total_safe_word_fixes}</h3>
                <p>Correções de Palavras (Seguras)</p>
            </div>
            <div class="stat stat-dangerous">
                <h3>{total_risky_word_fixes}</h3>
                <p>Correções Arriscadas</p>
            </div>
        </div>
        
        <div class="toc">
            <h2>📋 Índice do Relatório</h2>
            <ul>
                <li><a href="#char-fixes">🔧 Correções de Caracteres Corrompidos ({files_with_char_fixes} arquivos)</a></li>
                <li><a href="#safe-word-fixes">✅ Correções de Palavras Seguras ({files_with_safe_fixes} arquivos)</a></li>
                <li><a href="#risky-fixes">⚠️ Correções Arriscadas ({files_with_risky_fixes} arquivos)</a></li>
            </ul>
        </div>
"""
    
    # Seção de correções de caracteres
    html += f"""
        <section id="char-fixes">
            <h2>🔧 Correções de Caracteres Corrompidos (100% Seguras)</h2>
            <p>Estas correções são completamente seguras e melhoram a legibilidade da interface:</p>
"""
    
    for report in all_reports:
        if not report or not report['char_fixes']:
            continue
            
        rel_path = os.path.relpath(report['path'], 'lib')
        html += f"""
            <div class="file-section char-section">
                <div class="file-header">📁 {rel_path}</div>
"""
        
        for fix in report['char_fixes']:
            html += f"""
                <div class="fix-item">
                    <span class="line-number">Linha {fix['line_num']}</span>
                    <span class="change old-text">{fix['old_text']}</span>
                    →
                    <span class="change new-text">{fix['new_text']}</span>
                    <span class="context-type">{fix['context_type']}</span>
                    <div class="full-line">{fix['full_line']}</div>
                </div>
"""
        
        html += "</div>"
    
    html += "</section>"
    
    # Seção de correções seguras de palavras
    html += f"""
        <section id="safe-word-fixes">
            <h2>✅ Correções de Palavras Seguras</h2>
            <p>Estas correções aparentam ser seguras, mas recomenda-se revisão:</p>
"""
    
    for report in all_reports:
        if not report or not report['safe_word_fixes']:
            continue
            
        rel_path = os.path.relpath(report['path'], 'lib')
        html += f"""
            <div class="file-section safe-section">
                <div class="file-header">📁 {rel_path}</div>
"""
        
        for fix in report['safe_word_fixes']:
            html += f"""
                <div class="fix-item">
                    <span class="line-number">Linha {fix['line_num']}</span>
                    <span class="change old-text">{fix['old_text']}</span>
                    →
                    <span class="change new-text">{fix['new_text']}</span>
                    <span class="context-type">{fix['context_type']}</span>
                    <span class="safety-analysis seguro">{fix['safety_analysis']}</span>
                    <div class="full-line">{fix['full_line']}</div>
                </div>
"""
        
        html += "</div>"
    
    html += "</section>"
    
    # Seção de correções arriscadas
    html += f"""
        <section id="risky-fixes">
            <h2>⚠️ Correções Arriscadas (NÃO APLICAR)</h2>
            <p>Estas correções podem quebrar o código e devem ser feitas manualmente:</p>
"""
    
    for report in all_reports:
        if not report or not report['risky_word_fixes']:
            continue
            
        rel_path = os.path.relpath(report['path'], 'lib')
        html += f"""
            <div class="file-section dangerous-section">
                <div class="file-header">📁 {rel_path}</div>
"""
        
        for fix in report['risky_word_fixes']:
            html += f"""
                <div class="fix-item">
                    <span class="line-number">Linha {fix['line_num']}</span>
                    <span class="change old-text">{fix['old_text']}</span>
                    →
                    <span class="change new-text">{fix['new_text']}</span>
                    <span class="context-type">{fix['context_type']}</span>
                    <span class="safety-analysis perigoso">{fix['safety_analysis']}</span>
                    <div class="full-line">{fix['full_line']}</div>
                </div>
"""
        
        html += "</div>"
    
    html += """
        </section>
        
        <footer style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; text-align: center; color: #666;">
            <p>Relatório gerado automaticamente pelo sistema de análise de encoding do TagBean</p>
        </footer>
    </div>
</body>
</html>
"""
    
    return html
def main():
    base_dir = "lib"
    if not os.path.exists(base_dir):
        print("❌ Diretório 'lib' não encontrado!")
        return
    
    print("🔍 GERANDO RELATÓRIO DETALHADO DE CORREÇÕES")
    print("=" * 80)
    
    all_reports = []
    total_files = 0
    
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                total_files += 1
                file_path = os.path.join(root, file)
                
                print(f"⏳ Analisando {total_files}: {os.path.relpath(file_path, base_dir)}")
                
                report, error = analyze_file_detailed(file_path)
                
                if error:
                    print(f"❌ Erro: {error}")
                    all_reports.append(None)
                else:
                    all_reports.append(report)
    
    # Gera relatório HTML
    print("\n📝 Gerando relatório HTML...")
    html_content = generate_detailed_report(all_reports)
    
    # Salva o relatório
    report_filename = f"relatorio_encoding_{datetime.now().strftime('%Y%m%d_%H%M%S')}.html"
    
    try:
        with open(report_filename, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        print(f"✅ Relatório gerado com sucesso: {report_filename}")
        
        # Resumo final
        total_char_fixes = sum(len(r['char_fixes']) for r in all_reports if r)
        total_safe_word_fixes = sum(len(r['safe_word_fixes']) for r in all_reports if r)
        total_risky_word_fixes = sum(len(r['risky_word_fixes']) for r in all_reports if r)
        
        print(f"\n📊 RESUMO EXECUTIVO:")
        print(f"  • Arquivos analisados: {total_files}")
        print(f"  • ✅ Correções seguras de caracteres: {total_char_fixes}")
        print(f"  • ✅ Correções seguras de palavras: {total_safe_word_fixes}")
        print(f"  • ⚠️  Correções arriscadas: {total_risky_word_fixes}")
        
        print(f"\n🌐 Abra o arquivo '{report_filename}' no seu navegador para ver o relatório completo!")
        
    except Exception as e:
        print(f"❌ Erro ao salvar relatório: {e}")

if __name__ == '__main__':
    main()