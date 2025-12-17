#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import re
import sys

def create_mapping():
    """Cria mapeamento completo de correções de encoding"""
    return {
        # Caracteres corrompidos por double-encoding
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
        
        # Problemas comuns de acentuação que estão faltando
        'Usuarios': 'Usuários',
        'usuarios': 'usuários',
        'Usuario': 'Usuário',
        'usuario': 'usuário',
        'Integrao': 'Integração',
        'integrao': 'integração',
        'Integracao': 'Integração',
        'integracao': 'integração',
        'Notificaes': 'Notificações',
        'notificaes': 'notificações',
        'Notificacoes': 'Notificações',
        'notificacoes': 'notificações',
        'Segurana': 'Segurança',
        'segurana': 'segurança',
        'Seguranca': 'Segurança',
        'seguranca': 'segurança',
        'Permissoes': 'Permissões',
        'permissoes': 'permissões',
        'estrategias': 'estratégias',
        'Estrategias': 'Estratégias',
        'categoria': 'categoria',
        'categorias': 'categorias',
        'relatorio': 'relatório',
        'relatorios': 'relatórios',
        'Relatorio': 'Relatório',
        'Relatorios': 'Relatórios',
        'configuracao': 'configuração',
        'configuracoes': 'configurações',
        'Configuracao': 'Configuração',
        'Configuracoes': 'Configurações',
        'promocoes': 'promoções',
        'Promocoes': 'Promoções',
        'promocao': 'promoção',
        'Promocao': 'Promoção',
        'sincronizacao': 'sincronização',
        'Sincronizacao': 'Sincronização',
        'importacao': 'importação',
        'Importacao': 'Importação',
        'exportacao': 'exportação',
        'Exportacao': 'Exportação',
        'precificacao': 'precificação',
        'Precificacao': 'Precificação',
        'ativacao': 'ativação',
        'Ativacao': 'Ativação',
        'operacao': 'operação',
        'operacoes': 'operações',
        'Operacao': 'Operação',
        'Operacoes': 'Operações',
        'versao': 'versão',
        'versoes': 'versões',
        'Versao': 'Versão',
        'Versoes': 'Versões'
    }

def is_in_safe_context(line, match_start):
    """Verifica se a mudança está em um contexto seguro (string ou comentário)"""
    line_before_match = line[:match_start]
    
    # Verifica se está em string com aspas simples
    single_quotes = line_before_match.count("'") - line_before_match.count("\\'")
    if single_quotes % 2 == 1:
        return True, "string (aspas simples)"
    
    # Verifica se está em string com aspas duplas  
    double_quotes = line_before_match.count('"') - line_before_match.count('\\"')
    if double_quotes % 2 == 1:
        return True, "string (aspas duplas)"
    
    # Verifica se está em comentário de linha
    if '//' in line_before_match:
        return True, "comentário de linha"
    
    # Verifica se está em comentário de documentação
    stripped = line.strip()
    if stripped.startswith('///'):
        return True, "comentário de documentação"
    
    return False, "CÓDIGO (PERIGOSO!)"

def preview_file_fixes(file_path, mapping):
    """Analisa um arquivo e mostra todas as mudanças que seriam feitas"""
    try:
        with open(file_path, 'r', encoding='utf-8', errors='replace') as f:
            lines = f.readlines()
    except Exception as e:
        return [], f"Erro ao ler arquivo: {e}"
    
    all_fixes = []
    
    for line_num, line in enumerate(lines, 1):
        for old_text, new_text in mapping.items():
            if old_text in line:
                # Encontra todas as ocorrências na linha
                start = 0
                while True:
                    pos = line.find(old_text, start)
                    if pos == -1:
                        break
                    
                    is_safe, context = is_in_safe_context(line, pos)
                    
                    fix_info = {
                        'line_num': line_num,
                        'old_text': old_text,
                        'new_text': new_text,
                        'context': context,
                        'is_safe': is_safe,
                        'line_content': line.strip(),
                        'before': line[:pos],
                        'after': line[pos + len(old_text):]
                    }
                    all_fixes.append(fix_info)
                    start = pos + 1
    
    return all_fixes, None

def main():
    base_dir = "lib"
    if not os.path.exists(base_dir):
        print("❌ Diretório 'lib' não encontrado!")
        return
    
    mapping = create_mapping()
    
    print("🔍 PREVIEW DAS CORREÇÕES QUE SERIAM FEITAS")
    print("=" * 80)
    
    total_files = 0
    total_safe_fixes = 0
    total_dangerous_fixes = 0
    files_with_issues = []
    
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.dart'):
                total_files += 1
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, base_dir)
                
                fixes, error = preview_file_fixes(file_path, mapping)
                
                if error:
                    print(f"❌ {rel_path}: {error}")
                    continue
                
                if fixes:
                    safe_fixes = [f for f in fixes if f['is_safe']]
                    dangerous_fixes = [f for f in fixes if not f['is_safe']]
                    
                    total_safe_fixes += len(safe_fixes)
                    total_dangerous_fixes += len(dangerous_fixes)
                    
                    files_with_issues.append({
                        'path': rel_path,
                        'safe_fixes': safe_fixes,
                        'dangerous_fixes': dangerous_fixes
                    })
    
    # Mostra resumo geral primeiro
    print(f"📊 RESUMO GERAL:")
    print(f"  • Arquivos analisados: {total_files}")
    print(f"  • Arquivos com problemas: {len(files_with_issues)}")
    print(f"  • Correções SEGURAS: {total_safe_fixes}")
    print(f"  • Correções PERIGOSAS: {total_dangerous_fixes}")
    print()
    
    # Se há correções perigosas, mostra elas primeiro
    if total_dangerous_fixes > 0:
        print("🚨 CORREÇÕES PERIGOSAS (em código):")
        print("-" * 50)
        
        for file_info in files_with_issues:
            if file_info['dangerous_fixes']:
                print(f"\n📁 {file_info['path']}")
                for fix in file_info['dangerous_fixes']:
                    print(f"  ⚠️  Linha {fix['line_num']}: '{fix['old_text']}' → '{fix['new_text']}' ({fix['context']})")
                    print(f"      {fix['line_content']}")
        print()
    
    # Agora mostra as correções seguras
    if total_safe_fixes > 0:
        print("✅ CORREÇÕES SEGURAS (em strings/comentários):")
        print("-" * 50)
        
        for file_info in files_with_issues:
            if file_info['safe_fixes']:
                print(f"\n📁 {file_info['path']}")
                
                # Agrupa por tipo de contexto
                contexts = {}
                for fix in file_info['safe_fixes']:
                    context = fix['context']
                    if context not in contexts:
                        contexts[context] = []
                    contexts[context].append(fix)
                
                for context, context_fixes in contexts.items():
                    print(f"  📝 {context.upper()}:")
                    for fix in context_fixes[:3]:  # Mostra só os 3 primeiros
                        print(f"    Linha {fix['line_num']}: '{fix['old_text']}' → '{fix['new_text']}'")
                    
                    if len(context_fixes) > 3:
                        print(f"    ... e mais {len(context_fixes) - 3} correções deste tipo")
    
    print()
    print("=" * 80)
    
    if total_dangerous_fixes > 0:
        print("⚠️  ATENÇÃO: Há correções perigosas que podem quebrar o código!")
        print("   Recomendo corrigir manualmente os problemas em código antes de prosseguir.")
    else:
        print("✅ Todas as correções são seguras! Pode prosseguir com confiança.")
        
        if total_safe_fixes > 0:
            print()
            print("💡 Deseja aplicar as correções seguras? (s/n):", end=' ')
            response = input().lower().strip()
            if response in ['s', 'sim', 'yes', 'y']:
                print("🔧 Execute: python scripts/fix_words.py")
            else:
                print("✋ OK, nenhuma alteração foi feita.")

if __name__ == '__main__':
    main()